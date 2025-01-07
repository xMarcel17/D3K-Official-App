import SwiftUI

struct SmartbandView: View {
    @EnvironmentObject var bleManager: BLEManager
    @State private var showWifiFields = false
    @State private var wifiSSID = ""
    @State private var wifiPassword = ""

    var body: some View {
        ZStack {
            ZStack{
                VStack (spacing: 15){
                    VStack (spacing: 5){
                        Image("Smartband")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 163, height: 163)
                            .padding(.bottom, 590)
                    }


                }
            }
            .padding(.bottom, 10)
            
            ZStack{
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: abs(500), height: abs(100))
                    .background(
                        LinearGradient(
                            stops: [
                                Gradient.Stop(color: Color(red: 0.75, green: 0.73, blue: 0.87), location: 0.00),
                                Gradient.Stop(color: Color(red: 0.5, green: 0.63, blue: 0.83), location: 1.00),
                            ],
                            startPoint: UnitPoint(x: 0.5, y: 0),
                            endPoint: UnitPoint(x: 0.5, y: 1)
                        )
                        .frame(width: abs(500), height: abs(100))
                        .shadow(radius: 5)
                    )
            }
            .padding(.top, 800)
        }
        .background(.white)
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

struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.headline)
            Spacer()
            Text(value)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.tertiarySystemBackground))
        .cornerRadius(10.0)
    }
}

struct SmartbandView_Previews: PreviewProvider {
    static var previews: some View {
        SmartbandView(
        )
        .environmentObject(BLEManager())             // Przykładowe środowisko BLEManager
        //.preferredColorScheme(.light)                 // Dodatkowe zabezpieczenie dla podglądu
    }
}
