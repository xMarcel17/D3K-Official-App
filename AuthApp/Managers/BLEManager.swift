import CoreBluetooth
import SwiftUI

class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    @Published var receivedData: Data = Data() // Przechowujemy dane binarne
    @Published var isConnected = false
    @Published var batteryLevel: Int = 0
    @Published var firmwareVersion: String = ""
    @Published var filesToSend: Int = 0
    @Published var isSubscribed = false

    private var messageParts = Data() // Zmienna do przechowywania części wiadomości binarnych
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

    private var expectedDataSize: Int? // Zmienna do przechowywania rozmiaru oczekiwanych danych
    private var currentDataSize: Int = 0 // Aktualna liczba odebranych bajtów danych

    override init() {
        super.init()
        //deleteJsonFile() // Usuwanie pliku JSON na początku działania aplikacji
        //DatabaseManager.shared.clearDatabase() // czyszczenie bazy danych na początku działania aplikacji
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    // Wymagana metoda CBCentralManagerDelegate
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            print("Bluetooth jest włączony")
        } else {
            print("Bluetooth nie jest dostępny")
        }
    }

    func startScanning() {
        centralManager.scanForPeripherals(withServices: [serviceUUID], options: nil)
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        print("Znaleziono urządzenie: \(peripheral.name ?? "Brak nazwy")")
        self.peripheral = peripheral
        self.peripheral?.delegate = self
        centralManager.stopScan()
        centralManager.connect(peripheral, options: nil)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Połączono z urządzeniem: \(peripheral.name ?? "Brak nazwy")")
        isConnected = true
        peripheral.discoverServices([serviceUUID])
        let mtuSize = peripheral.maximumWriteValueLength(for: .withoutResponse)
        print("MTU size after connection: \(mtuSize) bytes")
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Nie udało się połączyć z urządzeniem: \(error?.localizedDescription ?? "Brak błędu")")
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        isConnected = false
        print("Rozłączono z urządzeniem: \(error?.localizedDescription ?? "Brak błędu")")
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                if service.uuid == serviceUUID {
                    peripheral.discoverCharacteristics([
                        characteristicUUID, confirmationUUID, timeSyncUUID,
                        batteryUUID, firmwareUUID, filesToSendUUID, ssidUUID, passwordUUID, privateKeyUUID
                    ], for: service)
                }
            }
        }
        
        let mtuSize = peripheral.maximumWriteValueLength(for: .withoutResponse)
        print("MTU size after discovering services: \(mtuSize) bytes")
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                if characteristic.uuid == privateKeyUUID {
                    print("Odnaleziono charakterystykę Private Key \(characteristic.uuid)")
                    self.privateKeyCharacteristic = characteristic
                    sendPrivateKey()
                    sleep(1) // Opóźnienie po wysłaniu klucza prywatnego
                } else if characteristic.uuid == characteristicUUID {
                    print("Odnaleziono charakterystykę danych \(characteristic.uuid)")
                    self.dataCharacteristic = characteristic

                    // Subskrybuj powiadomienia dla tej charakterystyki
                    peripheral.setNotifyValue(true, for: characteristic)

                    // Dodanie obsługi deskryptora 2902 dla powiadomień
                    if let descriptors = characteristic.descriptors {
                        for descriptor in descriptors where descriptor.uuid == CBUUID(string: "00002902-0000-1000-8000-00805f9b34fb") {
                            let enableValue = Data([0x01, 0x00]) // Włącz powiadomienia
                            peripheral.writeValue(enableValue, for: descriptor)
                            print("Subskrypcja na Notify ustawiona.")
                        }
                    }
                } else if characteristic.uuid == confirmationUUID {
                    print("Odnaleziono charakterystykę potwierdzenia \(characteristic.uuid)")
                    self.confirmationCharacteristic = characteristic
                } else if characteristic.uuid == timeSyncUUID {
                    print("Odnaleziono charakterystykę synchronizacji czasu \(characteristic.uuid)")
                    self.timeSyncCharacteristic = characteristic
                } else if characteristic.uuid == batteryUUID {
                    print("Odnaleziono charakterystykę poziomu baterii \(characteristic.uuid)")
                    self.batteryCharacteristic = characteristic
                } else if characteristic.uuid == firmwareUUID {
                    print("Odnaleziono charakterystykę wersji firmware \(characteristic.uuid)")
                    self.firmwareCharacteristic = characteristic
                } else if characteristic.uuid == filesToSendUUID {
                    print("Odnaleziono charakterystykę liczby plików do przesłania \(characteristic.uuid)")
                    self.filesToSendCharacteristic = characteristic
                } else if characteristic.uuid == ssidUUID {
                    print("Odnaleziono charakterystykę SSID \(characteristic.uuid)")
                    self.ssidCharacteristic = characteristic
                } else if characteristic.uuid == passwordUUID {
                    print("Odnaleziono charakterystykę hasła WiFi \(characteristic.uuid)")
                    self.passwordCharacteristic = characteristic
                }
            }

            // Wywołanie readValue dla odpowiednich charakterystyk po zakończeniu pętli
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

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let data = characteristic.value, characteristic == dataCharacteristic {
            handleDataCharacteristicUpdate(data: data)
        } else if characteristic == batteryCharacteristic, let data = characteristic.value {
            batteryLevel = Int(data[0])
            print("Poziom baterii: \(batteryLevel)%")
        } else if characteristic == firmwareCharacteristic, let data = characteristic.value {
            firmwareVersion = String(data: data, encoding: .utf8) ?? "Nieznana"
            print("Wersja firmware: \(firmwareVersion)")
        } else if characteristic == filesToSendCharacteristic, let data = characteristic.value {
            filesToSend = Int(data[0])
            print("Liczba plików do przesłania: \(filesToSend)")
        }
    }

    


    private func handleDataCharacteristicUpdate(data: Data?) {
        guard let data = data else { return }

        // Definicja końcowego znacznika danych
        let endMessage = Data(repeating: 0, count: 16)

        // Sprawdzamy, czy zakończono odbieranie danych
        if data == endMessage {
            if let expectedSize = expectedDataSize {
                print("Odebrano dane: \(currentDataSize) bajtów.")
                print("Przewidywana wielkość danych: \(expectedSize) bajtów.")
                let difference = expectedSize - currentDataSize
                print("Różnica między przewidywaną a odebraną wielkością: \(difference) bajtów.")
            } else {
                print("Odebrano dane, ale brak przewidywanej wielkości danych.")
            }

            if let expectedSize = expectedDataSize, currentDataSize == expectedSize {
                self.receivedData = self.messageParts

                // Przetwarzanie i zapisanie danych
                processReceivedData()
            } else {
                print("Błąd: Rozmiar odebranych danych nie zgadza się z przewidywaną wielkością.")
            }
            
            // Automatyczne odsubskrybowanie
            stopNotifications()
            print("Automatyczne wyłączenie subskrypcji po zakończeniu transmisji.")
            return
        } else {
            //print("Odebrano partię danych: \(data.count) bajtów")
            
            // Jeśli przewidywana wielkość danych nie jest jeszcze ustawiona, odczytujemy pierwsze 4 bajty jako rozmiar
            if expectedDataSize == nil, data.count >= 4 {
                // Odczytujemy pierwsze 4 bajty jako przewidywany rozmiar danych (little-endian) i pomijamy je
                expectedDataSize = Int(data[0]) | Int(data[1]) << 8 | Int(data[2]) << 16 | Int(data[3]) << 24
                print("Przewidywana wielkość wysyłanych danych: \(expectedDataSize ?? 0) bajtów")
                
                // Po ustaleniu przewidywanej wielkości danych, dodajemy tylko faktyczne dane (poza pierwszymi 4 bajtami)
                let actualData = data.dropFirst(4)
                messageParts.append(actualData)
                currentDataSize += actualData.count
            } else {
                // Gdy rozmiar danych jest już ustawiony, dodajemy każdą odebraną partię danych
                messageParts.append(data)
                currentDataSize += data.count
            }
        }
    }



    
    private func processReceivedData() {
        var offset = 0

        // Pobieranie timestamp (kolejne 4 bajty, little-endian)
        let timestamp = Int(messageParts[offset]) | Int(messageParts[offset + 1]) << 8 | Int(messageParts[offset + 2]) << 16 | Int(messageParts[offset + 3]) << 24
        offset += 4
        print("Pobrany timestamp: \(timestamp)")

        // Przetwarzanie reszty danych cyklicznie
        while offset + 14 <= messageParts.count {
            // Pobieranie ir (4 bajty, little-endian, signed)
            let ir = Int32(bitPattern: UInt32(messageParts[offset]) | UInt32(messageParts[offset + 1]) << 8 | UInt32(messageParts[offset + 2]) << 16 | UInt32(messageParts[offset + 3]) << 24)
            offset += 4

            // Pobieranie red (4 bajty, little-endian, signed)
            let red = Int32(bitPattern: UInt32(messageParts[offset]) | UInt32(messageParts[offset + 1]) << 8 | UInt32(messageParts[offset + 2]) << 16 | UInt32(messageParts[offset + 3]) << 24)
            offset += 4

            // Pobieranie accX (2 bajty, little-endian, signed)
            let accX = Int16(bitPattern: UInt16(messageParts[offset]) | UInt16(messageParts[offset + 1]) << 8)
            offset += 2

            // Pobieranie accY (2 bajty, little-endian, signed)
            let accY = Int16(bitPattern: UInt16(messageParts[offset]) | UInt16(messageParts[offset + 1]) << 8)
            offset += 2

            // Pobieranie accZ (2 bajty, little-endian, signed)
            let accZ = Int16(bitPattern: UInt16(messageParts[offset]) | UInt16(messageParts[offset + 1]) << 8)
            offset += 2

            // Zapis do bazy danych z wykorzystaniem tego samego timestamp
            DatabaseManager.shared.insertData(timestamp: timestamp, ir: Int(ir), red: Int(red), accX: Int(accX), accY: Int(accY), accZ: Int(accZ))
        }

        // Sprawdzenie zgodności rozmiaru danych
        if offset == expectedDataSize {
            print("Dane zostały przetworzone i zapisane do bazy danych.")
            sendConfirmation()
            sendTimeSync()
            DatabaseManager.shared.exportDataToJSON()
            // Zapisanie danych binarnych do pliku .bin
            saveBinaryFile(content: messageParts)
        } else {
            print("Ostrzeżenie: rozmiar przetworzonych danych nie zgadza się z przewidywanym rozmiarem.")
        }
    }


    func sendConfirmation() {
        guard let confirmationCharacteristic = confirmationCharacteristic, let peripheral = peripheral else {
            print("Nie znaleziono charakterystyki do wysłania potwierdzenia.")
            return
        }
        
        let confirmationMessage = "OK"
        if let data = confirmationMessage.data(using: .utf8) {
            peripheral.writeValue(data, for: confirmationCharacteristic, type: .withResponse)
            print("Wysłano wiadomość 'OK' do urządzenia.")
        }
    }

    func sendTimeSync() {
        guard let timeSyncCharacteristic = timeSyncCharacteristic, let peripheral = peripheral else {
            print("Nie znaleziono charakterystyki do wysłania czasu.")
            return
        }
        
        let currentUnixTime = UInt32(Date().timeIntervalSince1970)
        let timeData = withUnsafeBytes(of: currentUnixTime.littleEndian, Array.init)

        peripheral.writeValue(Data(timeData), for: timeSyncCharacteristic, type: .withResponse)
        print("Wysłano czas UNIX \(currentUnixTime) do urządzenia.")
    }
    
    // Funkcja wysyłająca SSID i hasło
    func sendWiFiCredentials(ssid: String, password: String) {
        guard isConnected else {
            print("Nie połączono z urządzeniem.")
            return
        }

        guard let ssidCharacteristic = ssidCharacteristic else {
            print("Nie znaleziono charakterystyki SSID.")
            return
        }

        guard let passwordCharacteristic = passwordCharacteristic else {
            print("Nie znaleziono charakterystyki hasła WiFi.")
            return
        }

        // Wysyłanie SSID
        if let ssidData = ssid.data(using: .utf8) {
            peripheral?.writeValue(ssidData, for: ssidCharacteristic, type: .withResponse)
            print("Wysłano SSID: \(ssid)")
        }

        // Opóźnienie przed wysłaniem hasła
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let passwordData = password.data(using: .utf8) {
                self.peripheral?.writeValue(passwordData, for: passwordCharacteristic, type: .withResponse)
                print("Wysłano hasło WiFi.")
            }
        }
    }
    
    // Funkcja wysyłająca klucz prywatny po połączeniu
    private func sendPrivateKey() {
        guard let privateKeyCharacteristic = privateKeyCharacteristic, let peripheral = peripheral else {
            print("Nie znaleziono charakterystyki klucza prywatnego.")
            return
        }

        let privateKey = "nuvijridkvinorj"
        if let data = privateKey.data(using: .utf8) {
            peripheral.writeValue(data, for: privateKeyCharacteristic, type: .withResponse)
            print("Wysłano klucz prywatny: \(privateKey)")
        }
    }

    func saveBinaryFile(content: Data) {
        let fileName = "receivedFile.bin"
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
        
        do {
            try content.write(to: path)
            print("Plik zapisany w: \(path)")
        } catch {
            print("Błąd podczas zapisywania pliku: \(error)")
        }
    }
    
    // Funkcja usuwająca plik JSON
        private func deleteJsonFile() {
            let fileName = "exportedData.json"
            let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
            
            if FileManager.default.fileExists(atPath: fileURL.path) {
                do {
                    try FileManager.default.removeItem(at: fileURL)
                    print("Plik JSON został usunięty.")
                } catch {
                    print("Błąd podczas usuwania pliku JSON: \(error)")
                }
            } else {
                print("Plik JSON nie istnieje, nie ma czego usuwać.")
            }
        }

    func disconnect() {
        if let peripheral = peripheral {
            centralManager.cancelPeripheralConnection(peripheral)
            isConnected = false
            print("Rozłączono z urządzeniem.")
        }
    }
    
    func startNotifications() {
        guard let characteristic = dataCharacteristic, let peripheral = peripheral else {
            print("Nie znaleziono charakterystyki danych lub urządzenia.")
            return
        }

        // Resetuj liczniki
        self.currentDataSize = 0
        self.expectedDataSize = nil
        self.messageParts = Data()
        self.receivedData = Data() // Reset wyświetlanej liczby danych
        
        // Najpierw wyłącz powiadomienia
        peripheral.setNotifyValue(false, for: characteristic)
        isSubscribed = false

        // Krótkie opóźnienie przed ponowną subskrypcją (opcjonalne, aby uniknąć konfliktów)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Teraz włącz powiadomienia
            peripheral.setNotifyValue(true, for: characteristic)
            self.isSubscribed = true

            // Obsługa deskryptora 2902
            if let descriptors = characteristic.descriptors {
                for descriptor in descriptors where descriptor.uuid == CBUUID(string: "2902") {
                    let enableValue = Data([0x01, 0x00]) // Włącz powiadomienia
                    peripheral.writeValue(enableValue, for: descriptor)
                    print("Subskrypcja na Notify została włączona.")
                }
            }
        }
    }


    func stopNotifications() {
        guard let characteristic = dataCharacteristic, let peripheral = peripheral else {
            print("Nie znaleziono charakterystyki danych lub urządzenia.")
            return
        }

        peripheral.setNotifyValue(false, for: characteristic)
        isSubscribed = false

        if let descriptors = characteristic.descriptors {
            for descriptor in descriptors where descriptor.uuid == CBUUID(string: "2902") {
                let disableValue = Data([0x00, 0x00]) // Wyłącz powiadomienia
                peripheral.writeValue(disableValue, for: descriptor)
                print("Subskrypcja na Notify została wyłączona.")
            }
        }
    }

}
