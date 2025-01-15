import SwiftUI

struct TrainingTypeView: View {
    @EnvironmentObject var bleManager: BLEManager
    @EnvironmentObject var webSocketManager: WebSocketManager
    
    let onDismiss: () -> Void
    
    @State private var selectedWorkoutType: String = "Sprint"
    
    let workoutTypes: [String] = [
        "Walking", "Jogging", "Running", "Sprint", "Hiking",
        "Tennis", "Football", "Basketball", "Volleyball",
        "LightExertion", "ModerateExertion", "IntenseExertion"
    ]

    var body: some View {
        VStack(spacing: 30) {
            Text("Select training type for this particular training session")
                .font(
                  Font.custom("Roboto Mono", size: 26)
                    .weight(.bold)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))

            Picker("Select Workout Type", selection: $selectedWorkoutType) {
                ForEach(workoutTypes, id: \ .self) { workoutType in
                    Text(workoutType).tag(workoutType)
                }
            }
            .frame(width: 200, height: 40) // Zmieniono wysokość
            .background(Color(red: 0.27, green: 0.43, blue: 0.69))
            .cornerRadius(20)
            .pickerStyle(.menu)

            Button(action: {
                sendJSONFile(workoutType: selectedWorkoutType)
                onDismiss()
            }) {
                Text("OK")
                    .font(Font.custom("RobotoMono-Bold", size: 20))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 131, height: 44)
                    .background(
                        LinearGradient(
                            stops: [
                                Gradient.Stop(color: Color(red: 0.5, green: 0.63, blue: 0.83), location: 0.00),
                                Gradient.Stop(color: Color(red: 0.46, green: 0.79, blue: 0.78), location: 1.00),
                            ],
                            startPoint: UnitPoint(x: 0, y: 0.5),
                            endPoint: UnitPoint(x: 1, y: 0.5)
                        )
                    )
                    .cornerRadius(100.0)
                    .shadow(radius: 5)
            }
        }
        .background(Color(red: 1, green: 1, blue: 1))
        .padding()
    }
    
    func sendJSONFile(workoutType: String) {
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

        guard MET[workoutType] != nil else {
            print("Nieznany typ treningu: \(workoutType)")
            return
        }

        guard let filePath = Bundle.main.path(forResource: "testDane2", ofType: "json") else {
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

struct TrainingTypeView_Previews: PreviewProvider {
    static var previews: some View {
        TrainingTypeView() {
            // Dismiss action
        }
        .environmentObject(BLEManager()) // Przykładowe środowisko BLEManager
        .environmentObject(WebSocketManager()) // Przykładowe środowisko WebSocketManager
    }
}
