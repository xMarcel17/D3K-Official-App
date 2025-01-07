import SwiftUI

struct BandView: View {
    @EnvironmentObject var bleManager: BLEManager
    @State private var showWifiFields = false
    @State private var wifiSSID = ""
    @State private var wifiPassword = ""

    var body: some View {
        VStack(spacing: 20) {
            // Przycisk do połączenia z urządzeniem
            Button(action: {
                bleManager.startScanning()
            }) {
                Text("Połącz z urządzeniem")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(Color.green)
                    .cornerRadius(15.0)
            }

            // Przycisk do rozłączenia z urządzeniem
            Button(action: {
                bleManager.disconnect()
            }) {
                Text("Rozłącz z urządzeniem")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(Color.red)
                    .cornerRadius(15.0)
            }

            // Przycisk do synchronizacji czasu
            Button(action: {
                if bleManager.isConnected && bleManager.timeSyncCharacteristic != nil {
                    bleManager.sendTimeSync()
                } else {
                    print("Nie znaleziono charakterystyki lub urządzenia.")
                }
            }) {
                Text("Synchronizuj czas")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(Color.purple)
                    .cornerRadius(15.0)
            }

            // Przycisk do wysłania informacji o WiFi
            Button(action: {
                showWifiFields.toggle()
            }) {
                Text("Wyślij informacje o WiFi")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(Color.blue)
                    .cornerRadius(15.0)
            }

            // Pola tekstowe do wpisania SSID i hasła oraz przycisk Wyślij
            if showWifiFields {
                VStack {
                    TextField("SSID", text: $wifiSSID)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    SecureField("Hasło WiFi", text: $wifiPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    Button(action: {
                        bleManager.sendWiFiCredentials(ssid: wifiSSID, password: wifiPassword)
                        wifiSSID = ""
                        wifiPassword = ""
                        showWifiFields = false
                    }) {
                        Text("Wyślij")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 100, height: 40)
                            .background(Color.blue)
                            .cornerRadius(10.0)
                    }
                }
                .padding()
            }

            // Informacje o statusie połączenia
            if bleManager.isConnected {
                Text("Połączono z urządzeniem!")
                    .font(.title)
                    .foregroundColor(.green)
            } else {
                Text("Nie połączono z urządzeniem.")
                    .font(.title)
                    .foregroundColor(.red)
            }

            // Sekcja z informacjami o opasce
            VStack(alignment: .leading, spacing: 15) {
                InfoRow(label: "Poziom baterii", value: "\(bleManager.batteryLevel)%")
                InfoRow(label: "Wersja firmware", value: bleManager.firmwareVersion)
                InfoRow(label: "Liczba plików do przesłania", value: "\(bleManager.filesToSend)")
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(15.0)
            .padding(.horizontal)
        }
        .padding()
    }
}

//// Komponent dla pojedynczego wiersza informacji
//struct InfoRow: View {
//    let label: String
//    let value: String
//
//    var body: some View {
//        HStack {
//            Text(label)
//                .font(.headline)
//            Spacer()
//            Text(value)
//                .font(.subheadline)
//                .foregroundColor(.gray)
//        }
//        .padding()
//        .background(Color(.tertiarySystemBackground))
//        .cornerRadius(10.0)
//    }
//}
