import SwiftUI

struct SmartbandView: View {
    var username: String
    
    @EnvironmentObject var bleManager: BLEManager
    @EnvironmentObject var webSocketManager: WebSocketManager
    @EnvironmentObject var languageManager: LocalizationManager

    @State private var selectTrainingType = false
    @State private var showBandInfoNotification = false
    @State private var showWifiFields = false
    @State private var wifiSSID = ""
    @State private var wifiPassword = ""
    @State private var showAlert = false
    
    @State private var showDataFetchedAlert = false
    
    @AppStorage("appTheme") private var currentTheme: String = "Theme1"

    var body: some View {
        ZStack {
            ZStack{
                VStack (spacing: 15){
                    VStack (spacing: 5){
                        if currentTheme == "Theme1" {
                            Image("Smartband")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 167, height: 167)
                        }
                        else if currentTheme == "Theme2" {
                            Image("Smartband2")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 167, height: 167)
                        }
                        else {
                            Image("Smartband")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 167, height: 167)
                        }
                        
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
                            Text(languageManager.localizedString(forKey: "connected"))
                              .font(
                                Font.custom("Roboto Mono", size: 20)
                                  .weight(.bold)
                              )
                              .multilineTextAlignment(.center)
                              .foregroundColor(Color(red: 0.13, green: 0.7, blue: 0.23))
                        } else {
                            Text(languageManager.localizedString(forKey: "disconnected"))
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
                            Text(languageManager.localizedString(forKey: "connect"))
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
                            Text(languageManager.localizedString(forKey: "disconnect"))
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
                                print("Subscription started.")
                            } else {
                                print("Characteristic or device not found.")
                            }
                        }) {
                            Text(languageManager.localizedString(forKey: "receivedata"))
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
                            selectTrainingType = true
                        }) {
                            Text(languageManager.localizedString(forKey: "sendtoserver"))
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
                            Text(languageManager.localizedString(forKey: "sendwifi"))
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
                                        Text(languageManager.localizedString(forKey: "wifipassword"))
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
                                    Text(languageManager.localizedString(forKey: "send"))
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
                                print("Characteristic or device not found.")
                            }
                        }) {
                            Text(languageManager.localizedString(forKey: "synctime"))
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
                            Text(languageManager.localizedString(forKey: "bandinfo"))
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
                            .environmentObject(bleManager) // Przykładowe środowisko BLEManager
                            .environmentObject(webSocketManager) // Przykładowe środowisko WebSocketManager
                        }
                    }
                )
                .overlay(
                    Group {
                        if selectTrainingType {
                            TrainingTypeView {
                                selectTrainingType = false
                            }
                            .frame(width: 370, height: 320)
                            .background(Color.white)
                            .cornerRadius(40)
                            .shadow(radius: 90)
                            .transition(.opacity)
                            .environmentObject(BLEManager()) // Przykładowe środowisko BLEManager
                            .environmentObject(WebSocketManager()) // Przykładowe środowisko WebSocketManager
                        }
                    }
                )
            }
            .padding(.bottom, 35)
            .onReceive(bleManager.$isDataFetched) { isFetched in
                print("isDataFetched changed to: \(isFetched)")
                DispatchQueue.main.async {
                    if isFetched {
                        showDataFetchedAlert = true
                        bleManager.isDataFetched = false
                    }
                }
            }
            .alert(isPresented: $showDataFetchedAlert) {
                Alert(
                    title: Text(languageManager.localizedString(forKey: "downloaded")),
                    message: Text(languageManager.localizedString(forKey: "downloadedtext")),
                    dismissButton: .default(Text("OK"))
                )
            }
            
            ZStack{
                // Tło – korzystamy ze zmiennych, które zależą od currentTheme
                let (topColor, bottomColor) = colorsForTheme(currentTheme)

                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: abs(500), height: abs(100))
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [topColor, bottomColor]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(width: abs(500), height: abs(100))
                        .shadow(radius: 5)
                    )
            }
            .padding(.top, 800)
            .onReceive(webSocketManager.$showTrainingAlert) { show in
                if show {
                    showAlert = true
                    webSocketManager.showTrainingAlert = false
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(languageManager.localizedString(forKey: "trainingprocessed")),
                    message: Text(languageManager.localizedString(forKey: "trainingtext")),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .background(.white)


    }
    
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    // Funkcja zwraca parę kolorów (górny i dolny) dla danego motywu
    private func colorsForTheme(_ theme: String) -> (Color, Color) {
        switch theme {
        case "Theme2":
            // Przykładowy drugi motyw
            return (
                Color(red: 0.65, green: 0.83, blue: 0.95),
                Color(red: 0.19, green: 0.30, blue: 0.38)
            )
        default:
            // Domyślny motyw (Theme1)
            return (
                Color(red: 0.75, green: 0.73, blue: 0.87),
                Color(red: 0.5, green: 0.63, blue: 0.83)
            )
        }
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
        SmartbandView(username: "TestUser") // Przykładowy username
            .environmentObject(BLEManager()) // Przykładowe środowisko BLEManager
            .environmentObject(WebSocketManager()) // Przykładowe środowisko WebSocketManager
            .environmentObject(LocalizationManager()) // Przykładowe środowisko LocalizationManager
            .preferredColorScheme(.light) // Opcjonalnie tryb jasny
    }
}
