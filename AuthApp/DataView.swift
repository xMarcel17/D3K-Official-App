import SwiftUI

struct DataView: View {
    @EnvironmentObject var bleManager: BLEManager

    var body: some View {
        VStack(spacing: 20) {
            Button(action: {
                if bleManager.isConnected && bleManager.dataCharacteristic != nil {
                    bleManager.startNotifications()
                    print("Rozpoczęto subskrypcję.")
                } else {
                    print("Nie znaleziono charakterystyki lub urządzenia.")
                }
            }) {
                Text("Pobierz dane")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(Color.blue)
                    .cornerRadius(15.0)
            }

            Text(bleManager.isSubscribed ? "Subskrypcja aktywna" : "Subskrypcja nieaktywna")
                .foregroundColor(bleManager.isSubscribed ? .green : .red)
                .font(.headline)
                .padding()

            Button(action: {
                
            }) {
                Text("Udostępnij plik")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(Color.orange)
                    .cornerRadius(15.0)
            }

            Button(action: {
                sendJSONFile(workoutType: "Sprint")
            }) {
                Text("Wyślij JSON")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(Color.green)
                    .cornerRadius(15.0)
            }

            Text("Odebrane dane: \(bleManager.receivedData.count) bajtów")
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .onAppear {
                    // Reset wyświetlanej wartości po pojawieniu się widoku
                    bleManager.receivedData = Data()
                }
        }
        .padding()
    }

    func sendJSONFile(workoutType: String) {
        // Zbiór wartości MET dla typów treningu
        let MET: [String: Double] = [
            "Walking": 3.8,
            "Jogging": 7.5,
            "Running": 7.0,
            "Sprint": 12.0,
            "Hiking": 6.0,
            "Tennis": 6.8,
            "Football": 8.0,
            "Basketball": 7.5,
            "Volleyball": 4.0,
            "LightExertion": 3.0,
            "ModerateExertion": 5.0,
            "IntenseExertion": 7.0
        ]

        // Sprawdzenie, czy workoutType istnieje w MET
        guard MET[workoutType] != nil else {
            print("Nieznany typ treningu: \(workoutType)")
            return
        }
        
        guard let filePath = Bundle.main.path(forResource: "testDane", ofType: "json") else {
            print("Nie znaleziono pliku JSON w zasobach projektu.")
            return
        }
        
        guard let jsonText = try? String(contentsOfFile: filePath, encoding: .utf8) else {
            print("Nie można załadować zawartości pliku JSON")
            return
        }

        guard let sessionId = UserDefaults.standard.string(forKey: "session_id") else {
            print("Brak session-id w UserDefaults")
            return
        }

        // Dodanie workoutType do URL-a
        guard let url = URL(string: "http://192.168.1.20:8000/sensors/handle_sensor_data?workoutType=\(workoutType)") else {
            print("Niepoprawny URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(sessionId, forHTTPHeaderField: "session-id")
        request.httpBody = jsonText.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Błąd podczas wysyłania danych: \(error)")
                    return
                }
                if let httpResponse = response as? HTTPURLResponse {
                    print("Status kod serwera: \(httpResponse.statusCode)")
                    if httpResponse.statusCode == 200 {
                        print("Dane zostały pomyślnie wysłane na serwer.")
                    } else {
                        print("Błąd serwera: \(httpResponse.statusCode)")
                    }
                }
            }
        }.resume()
    }


}
