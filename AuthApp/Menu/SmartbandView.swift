import SwiftUI

struct SmartbandView: View {
    @EnvironmentObject var bleManager: BLEManager
    @State private var showBandInfoNotification = false
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
                            .frame(width: 167, height: 167)
                        
                        Text("Smartband D3K")
                          .font(
                            Font.custom("Roboto Mono", size: 32)
                              .weight(.bold)
                          )
                          .multilineTextAlignment(.center)
                          .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))

                        Text("Status:")
                          .font(
                            Font.custom("Roboto Mono", size: 16)
                              .weight(.bold)
                          )
                          .multilineTextAlignment(.center)
                          .foregroundColor(.black)
                        
                        // Informacje o statusie połączenia
                        if bleManager.isConnected {
                            Text("CONNECTED")
                              .font(
                                Font.custom("Roboto Mono", size: 20)
                                  .weight(.bold)
                              )
                              .multilineTextAlignment(.center)
                              .foregroundColor(Color(red: 0.13, green: 0.7, blue: 0.23))
                        } else {
                            Text("DISCONNECTED")
                              .font(
                                Font.custom("Roboto Mono", size: 20)
                                  .weight(.bold)
                              )
                              .multilineTextAlignment(.center)
                              .foregroundColor(Color(red: 0.82, green: 0.02, blue: 0.04))
                        }
                    }
                    
                    VStack(spacing: 18){
                        Button(action: {
                            bleManager.startScanning()
                        }) {
                            Text("Connect")
                                .font(Font.custom("RobotoMono-Bold", size: 14))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 249, height: 42)
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
                        
                        Button(action: {
                            bleManager.disconnect()
                        }) {
                            Text("Disonnect")
                                .font(Font.custom("RobotoMono-Bold", size: 14))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 249, height: 42)
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
                        
                        Button(action: {
                            if bleManager.isConnected && bleManager.dataCharacteristic != nil {
                                bleManager.startNotifications()
                                print("Rozpoczęto subskrypcję.")
                            } else {
                                print("Nie znaleziono charakterystyki lub urządzenia.")
                            }
                        }) {
                            Text("Receive data")
                                .font(Font.custom("RobotoMono-Bold", size: 14))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 249, height: 42)
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
                        
                        Button(action: {
                            sendJSONFile(workoutType: "Sprint")
                        }) {
                            Text("Send data to server")
                                .font(Font.custom("RobotoMono-Bold", size: 14))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 249, height: 42)
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
                        
                        Button(action: {
                            showWifiFields.toggle()
                        }) {
                            Text("Send WiFi")
                                .font(Font.custom("RobotoMono-Bold", size: 14))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 249, height: 42)
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
                        
                        // Pola tekstowe do wpisania SSID i hasła oraz przycisk Wyślij
                        if showWifiFields {
                            VStack (spacing: 40){
                                // TextField z własnym placeholderem i tłem
                                ZStack(alignment: .leading) {
                                    if wifiSSID.isEmpty { // Sprawdzanie, czy pole jest puste, aby wyświetlić placeholder
                                        Text("SSID")
                                            .padding(.leading, 17) // Opcjonalne odsunięcie tekstu placeholdera
                                            .font(Font.custom("RobotoMono-Bold", size: 14))
                                            .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                                    }
                                    TextField("", text: $wifiSSID)
                                        .padding()
                                        .background(Color(red: 0.87, green: 0.85, blue: 0.89, opacity: 0.75))
                                        .cornerRadius(40)
                                        .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                                        .autocapitalization(.none)
                                        .font(Font.custom("RobotoMono-Bold", size: 14))
                                }
                                .frame(width: 200, height: 22)

                                // SecureField z własnym placeholderem i tłem
                                ZStack(alignment: .leading) {
                                    if wifiPassword.isEmpty { // Sprawdzanie, czy pole jest puste, aby wyświetlić placeholder
                                        Text("WiFi Password")
                                            .padding(.leading, 17) // Opcjonalne odsunięcie tekstu placeholdera
                                            .font(Font.custom("RobotoMono-Bold", size: 14))
                                            .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                                    }
                                    SecureField("", text: $wifiPassword)
                                        .padding()
                                        .background(Color(red: 0.87, green: 0.85, blue: 0.89, opacity: 0.75))
                                        .cornerRadius(40)
                                        .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                                        .autocapitalization(.none)
                                        .font(Font.custom("RobotoMono-Bold", size: 14))
                                }
                                .frame(width: 200, height: 22)
                                
                                Button(action: {
                                    bleManager.sendWiFiCredentials(ssid: wifiSSID, password: wifiPassword)
                                    wifiSSID = ""
                                    wifiPassword = ""
                                    showWifiFields = false
                                }) {
                                    Text("Send")
                                        .font(Font.custom("RobotoMono-Bold", size: 14))
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(width: 100, height: 42)
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
                            .padding()
                        }
                        
                        Button(action: {
                            if bleManager.isConnected && bleManager.timeSyncCharacteristic != nil {
                                bleManager.sendTimeSync()
                            } else {
                                print("Nie znaleziono charakterystyki lub urządzenia.")
                            }
                        }) {
                            Text("Sync time")
                                .font(Font.custom("RobotoMono-Bold", size: 14))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 249, height: 42)
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
                        
                        
                        Button(action: {
                            showBandInfoNotification = true
                        }) {
                            Text("Band info")
                                .font(Font.custom("RobotoMono-Bold", size: 14))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 249, height: 42)
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


                }
                .overlay(
                    Group {
                        if showBandInfoNotification {
                            BandInfoView {
                                showBandInfoNotification = false
                            }
                            .frame(width: 370, height: 420)
                            .background(Color.white)
                            .cornerRadius(40)
                            .shadow(radius: 90)
                            .transition(.opacity)
                        }
                    }
                )
            }
            .padding(.bottom, 35)
            
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
    
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
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
