import CoreBluetooth
import SwiftUI

class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    @Published var receivedData: Data = Data() // Store binary data
    @Published var isConnected = false
    @Published var batteryLevel: Int = 0
    @Published var firmwareVersion: String = ""
    @Published var filesToSend: Int = 0
    @Published var isSubscribed = false
    
    static let shared = BLEManager()

    private var messageParts = Data() // Store parts of binary messages
    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral?
    var dataCharacteristic: CBCharacteristic?
    var confirmationCharacteristic: CBCharacteristic?
    var timeSyncCharacteristic: CBCharacteristic?
    var batteryCharacteristic: CBCharacteristic?
    var firmwareCharacteristic: CBCharacteristic?
    var filesToSendCharacteristic: CBCharacteristic?
    var ssidCharacteristic: CBCharacteristic?
    var passwordCharacteristic: CBCharacteristic?
    var privateKeyCharacteristic: CBCharacteristic?

    private let serviceUUID = CBUUID(string: "12345678-1234-1234-1234-123456789012")
    private let characteristicUUID = CBUUID(string: "e2e3f5a4-8c4f-11eb-8dcd-0242ac130005")
    private let confirmationUUID = CBUUID(string: "e2e3f5a4-8c4f-11eb-8dcd-0242ac130006")
    private let timeSyncUUID = CBUUID(string: "e2e3f5a4-8c4f-11eb-8dcd-0242ac130007")
    private let batteryUUID = CBUUID(string: "e2e3f5a4-8c4f-11eb-8dcd-0242ac130021")
    private let firmwareUUID = CBUUID(string: "e2e3f5a4-8c4f-11eb-8dcd-0242ac130022")
    private let filesToSendUUID = CBUUID(string: "e2e3f5a4-8c4f-11eb-8dcd-0242ac130023")
    private let ssidUUID = CBUUID(string: "e2e3f5a4-8c4f-11eb-8dcd-0242ac130003")
    private let passwordUUID = CBUUID(string: "e2e3f5a4-8c4f-11eb-8dcd-0242ac130004")
    private let privateKeyUUID = CBUUID(string: "e2e3f5a4-8c4f-11eb-8dcd-0242ac130025")

    private var expectedDataSize: Int?
    private var currentDataSize: Int = 0
    
    @Published var isDataFetched = false

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    // CBCentralManagerDelegate required method
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            print("Bluetooth is powered on")
        } else {
            print("Bluetooth is not available")
        }
    }

    func startScanning() {
        centralManager.scanForPeripherals(withServices: [serviceUUID], options: nil)
    }

    func centralManager(_ central: CBCentralManager,
                       didDiscover peripheral: CBPeripheral,
                       advertisementData: [String: Any],
                       rssi RSSI: NSNumber) {
        print("Found device: \(peripheral.name ?? "No name")")
        self.peripheral = peripheral
        self.peripheral?.delegate = self
        centralManager.stopScan()
        centralManager.connect(peripheral, options: nil)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to device: \(peripheral.name ?? "No name")")
        isConnected = true
        peripheral.discoverServices([serviceUUID])
        let mtuSize = peripheral.maximumWriteValueLength(for: .withoutResponse)
        print("MTU size after connection: \(mtuSize) bytes")
    }

    func centralManager(_ central: CBCentralManager,
                       didFailToConnect peripheral: CBPeripheral,
                       error: Error?) {
        print("Failed to connect to device: \(error?.localizedDescription ?? "No error")")
    }

    func centralManager(_ central: CBCentralManager,
                       didDisconnectPeripheral peripheral: CBPeripheral,
                       error: Error?) {
        isConnected = false
        print("Disconnected from device: \(error?.localizedDescription ?? "No error")")
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                if service.uuid == serviceUUID {
                    peripheral.discoverCharacteristics([
                        characteristicUUID,
                        confirmationUUID,
                        timeSyncUUID,
                        batteryUUID,
                        firmwareUUID,
                        filesToSendUUID,
                        ssidUUID,
                        passwordUUID,
                        privateKeyUUID
                    ], for: service)
                }
            }
        }
        
        let mtuSize = peripheral.maximumWriteValueLength(for: .withoutResponse)
        print("MTU size after discovering services: \(mtuSize) bytes")
    }

    func peripheral(_ peripheral: CBPeripheral,
                    didDiscoverCharacteristicsFor service: CBService,
                    error: Error?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                if characteristic.uuid == privateKeyUUID {
                    print("Found Private Key characteristic \(characteristic.uuid)")
                    self.privateKeyCharacteristic = characteristic
                    sendPrivateKey()
                    sleep(1)
                } else if characteristic.uuid == characteristicUUID {
                    print("Found data characteristic \(characteristic.uuid)")
                    self.dataCharacteristic = characteristic
                    peripheral.setNotifyValue(true, for: characteristic)
                    
                    // Handle descriptor 2902 for notifications
                    if let descriptors = characteristic.descriptors {
                        for descriptor in descriptors where descriptor.uuid == CBUUID(string: "00002902-0000-1000-8000-00805f9b34fb") {
                            let enableValue = Data([0x01, 0x00])
                            peripheral.writeValue(enableValue, for: descriptor)
                            print("Notify subscription set.")
                        }
                    }
                } else if characteristic.uuid == confirmationUUID {
                    print("Found confirmation characteristic \(characteristic.uuid)")
                    self.confirmationCharacteristic = characteristic
                } else if characteristic.uuid == timeSyncUUID {
                    print("Found time sync characteristic \(characteristic.uuid)")
                    self.timeSyncCharacteristic = characteristic
                } else if characteristic.uuid == batteryUUID {
                    print("Found battery level characteristic \(characteristic.uuid)")
                    self.batteryCharacteristic = characteristic
                } else if characteristic.uuid == firmwareUUID {
                    print("Found firmware version characteristic \(characteristic.uuid)")
                    self.firmwareCharacteristic = characteristic
                } else if characteristic.uuid == filesToSendUUID {
                    print("Found 'files to send' characteristic \(characteristic.uuid)")
                    self.filesToSendCharacteristic = characteristic
                } else if characteristic.uuid == ssidUUID {
                    print("Found SSID characteristic \(characteristic.uuid)")
                    self.ssidCharacteristic = characteristic
                } else if characteristic.uuid == passwordUUID {
                    print("Found WiFi password characteristic \(characteristic.uuid)")
                    self.passwordCharacteristic = characteristic
                }
            }

            // Read values for certain characteristics
            if let batteryCharacteristic = self.batteryCharacteristic {
                peripheral.readValue(for: batteryCharacteristic)
            }
            if let firmwareCharacteristic = self.firmwareCharacteristic {
                peripheral.readValue(for: firmwareCharacteristic)
            }
            if let filesToSendCharacteristic = self.filesToSendCharacteristic {
                peripheral.readValue(for: filesToSendCharacteristic)
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral,
                    didUpdateValueFor characteristic: CBCharacteristic,
                    error: Error?) {
        if let data = characteristic.value, characteristic == dataCharacteristic {
            handleDataCharacteristicUpdate(data: data)
        } else if characteristic == batteryCharacteristic, let data = characteristic.value {
            batteryLevel = Int(data[0])
            print("Battery level: \(batteryLevel)%")
        } else if characteristic == firmwareCharacteristic, let data = characteristic.value {
            firmwareVersion = String(data: data, encoding: .utf8) ?? "Unknown"
            print("Firmware version: \(firmwareVersion)")
        } else if characteristic == filesToSendCharacteristic, let data = characteristic.value {
            filesToSend = Int(data[0])
            print("Number of files to send: \(filesToSend)")
        }
    }

    private func handleDataCharacteristicUpdate(data: Data?) {
        guard let data = data else { return }

        let endMessage = Data(repeating: 0, count: 16)
        
        // Check if data reception is finished
        if data == endMessage {
            if let expectedSize = expectedDataSize {
                print("Received data: \(currentDataSize) bytes.")
                print("Expected data size: \(expectedSize) bytes.")
                let difference = expectedSize - currentDataSize
                print("Difference between expected and received size: \(difference) bytes.")
            } else {
                print("Data received, but no expected data size was provided.")
            }

            if let expectedSize = expectedDataSize, currentDataSize == expectedSize {
                self.receivedData = self.messageParts
                processReceivedData()
            } else {
                print("Error: The size of the received data does not match the expected size.")
            }
            
            stopNotifications()
            print("Notify subscription automatically disabled after transmission.")
            return
        } else {
            // If the expected data size is not set yet, read the first 4 bytes as size
            if expectedDataSize == nil, data.count >= 4 {
                expectedDataSize = Int(data[0])
                    | Int(data[1]) << 8
                    | Int(data[2]) << 16
                    | Int(data[3]) << 24
                print("Expected data size: \(expectedDataSize ?? 0) bytes")
                
                let actualData = data.dropFirst(4)
                messageParts.append(actualData)
                currentDataSize += actualData.count
            } else {
                messageParts.append(data)
                currentDataSize += data.count
            }
        }
    }

    private func processReceivedData() {
        var offset = 0

        // Fetch timestamp (next 4 bytes, little-endian)
        let timestamp = Int(messageParts[offset])
            | Int(messageParts[offset + 1]) << 8
            | Int(messageParts[offset + 2]) << 16
            | Int(messageParts[offset + 3]) << 24
        offset += 4
        print("Fetched timestamp: \(timestamp)")

        // Process the rest of the data in a loop
        while offset + 14 <= messageParts.count {
            let ir = Int32(bitPattern:
                UInt32(messageParts[offset])
                | UInt32(messageParts[offset + 1]) << 8
                | UInt32(messageParts[offset + 2]) << 16
                | UInt32(messageParts[offset + 3]) << 24
            )
            offset += 4

            let red = Int32(bitPattern:
                UInt32(messageParts[offset])
                | UInt32(messageParts[offset + 1]) << 8
                | UInt32(messageParts[offset + 2]) << 16
                | UInt32(messageParts[offset + 3]) << 24
            )
            offset += 4

            let accX = Int16(bitPattern:
                UInt16(messageParts[offset])
                | UInt16(messageParts[offset + 1]) << 8
            )
            offset += 2

            let accY = Int16(bitPattern:
                UInt16(messageParts[offset])
                | UInt16(messageParts[offset + 1]) << 8
            )
            offset += 2

            let accZ = Int16(bitPattern:
                UInt16(messageParts[offset])
                | UInt16(messageParts[offset + 1]) << 8
            )
            offset += 2

            DatabaseManager.shared.insertData(
                timestamp: timestamp,
                ir: Int(ir),
                red: Int(red),
                accX: Int(accX),
                accY: Int(accY),
                accZ: Int(accZ)
            )
        }

        if offset == expectedDataSize {
            print("Data has been processed and saved to the database.")
            sendConfirmation()
            sendTimeSync()
            DatabaseManager.shared.exportDataToJSON()
            saveBinaryFile(content: messageParts)
            
            DispatchQueue.main.async {
                self.isDataFetched = true
            }
        } else {
            print("Warning: The size of the processed data does not match the expected size.")
        }
    }

    func sendConfirmation() {
        guard let confirmationCharacteristic = confirmationCharacteristic,
              let peripheral = peripheral else {
            print("Confirmation characteristic not found.")
            return
        }
        
        let confirmationMessage = "OK"
        if let data = confirmationMessage.data(using: .utf8) {
            peripheral.writeValue(data, for: confirmationCharacteristic, type: .withResponse)
            print("Sent 'OK' message to the device.")
        }
    }

    func sendTimeSync() {
        guard let timeSyncCharacteristic = timeSyncCharacteristic,
              let peripheral = peripheral else {
            print("Time sync characteristic not found.")
            return
        }
        
        let currentUnixTime = UInt32(Date().timeIntervalSince1970)
        let timeData = withUnsafeBytes(of: currentUnixTime.littleEndian, Array.init)

        peripheral.writeValue(Data(timeData), for: timeSyncCharacteristic, type: .withResponse)
        print("Sent UNIX time \(currentUnixTime) to the device.")
    }
    
    func sendWiFiCredentials(ssid: String, password: String) {
        guard isConnected else {
            print("Not connected to the device.")
            return
        }

        guard let ssidCharacteristic = ssidCharacteristic else {
            print("SSID characteristic not found.")
            return
        }

        guard let passwordCharacteristic = passwordCharacteristic else {
            print("WiFi password characteristic not found.")
            return
        }

        // Send SSID
        if let ssidData = ssid.data(using: .utf8) {
            peripheral?.writeValue(ssidData, for: ssidCharacteristic, type: .withResponse)
            print("SSID has been sent: \(ssid)")
        }

        // Small delay before sending the password
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let passwordData = password.data(using: .utf8) {
                self.peripheral?.writeValue(passwordData, for: passwordCharacteristic, type: .withResponse)
                print("WiFi password has been sent.")
            }
        }
    }
    
    private func sendPrivateKey() {
        guard let privateKeyCharacteristic = privateKeyCharacteristic,
              let peripheral = peripheral else {
            print("Private key characteristic not found.")
            return
        }

        let privateKey = "nuvijridkvinorj"
        if let data = privateKey.data(using: .utf8) {
            peripheral.writeValue(data, for: privateKeyCharacteristic, type: .withResponse)
            print("Private key has been sent: \(privateKey)")
        }
    }

    func saveBinaryFile(content: Data) {
        let fileName = "receivedFile.bin"
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(fileName)
        
        do {
            try content.write(to: path)
            print("File saved to: \(path)")
        } catch {
            print("Error saving file: \(error)")
        }
    }
    
    func deleteJsonFile() {
        let fileName = "exportedData.json"
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(fileName)
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(at: fileURL)
                print("JSON file has been removed.")
            } catch {
                print("Error removing JSON file: \(error)")
            }
        } else {
            print("JSON file does not exist, nothing to remove.")
        }
    }

    func disconnect() {
        if let peripheral = peripheral {
            centralManager.cancelPeripheralConnection(peripheral)
            isConnected = false
            print("Disconnected from the device.")
        }
    }
    
    func startNotifications() {
        guard let characteristic = dataCharacteristic, let peripheral = peripheral else {
            print("Data characteristic or device not found.")
            return
        }
        
        self.isDataFetched = false
        self.currentDataSize = 0
        self.expectedDataSize = nil
        self.messageParts = Data()
        self.receivedData = Data()
        
        peripheral.setNotifyValue(false, for: characteristic)
        isSubscribed = false

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            peripheral.setNotifyValue(true, for: characteristic)
            self.isSubscribed = true

            if let descriptors = characteristic.descriptors {
                for descriptor in descriptors where descriptor.uuid == CBUUID(string: "2902") {
                    let enableValue = Data([0x01, 0x00])
                    peripheral.writeValue(enableValue, for: descriptor)
                    print("Notify subscription has been enabled.")
                }
            }
        }
    }

    func stopNotifications() {
        guard let characteristic = dataCharacteristic, let peripheral = peripheral else {
            print("Data or device characteristic not found.")
            return
        }

        peripheral.setNotifyValue(false, for: characteristic)
        isSubscribed = false

        if let descriptors = characteristic.descriptors {
            for descriptor in descriptors where descriptor.uuid == CBUUID(string: "2902") {
                let disableValue = Data([0x00, 0x00])
                peripheral.writeValue(disableValue, for: descriptor)
                print("Notify subscription has been disabled.")
            }
        }
    }
}
