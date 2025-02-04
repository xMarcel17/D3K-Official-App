import SwiftUI

struct BMIKCALCalc: View {
    @Environment(\.presentationMode) var presentationMode // Obsługa cofania
    @EnvironmentObject var webSocketManager: WebSocketManager // Obsługa WebSocket
    @EnvironmentObject var languageManager: LocalizationManager // Obsługa lokalizacji

    @State private var showBMICalcView = false // Flaga do wyświetlania BMICalcView
    @State private var showKCALCalcView = false // Flaga do wyświetlania BMICalcView
    
    @AppStorage("appTheme") private var currentTheme: String = "Theme1"
    
    var body: some View {
        ZStack {
            // Tło – korzystamy ze zmiennych, które zależą od currentTheme
            let (topColor, bottomColor) = colorsForTheme(currentTheme)
            
            backgroundView
            
            VStack(spacing: 70) {
                Button(action: {
                    showBMICalcView = true
                }) {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 315, height: 240)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [topColor, bottomColor]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .cornerRadius(40)
                        
                        Image("Meter")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 257, height: 135)
                            .opacity(0.15)
                        
                        Text(languageManager.localizedString(forKey: "bmicalc"))
                            .font(
                                Font.custom("Roboto Mono", size: 40)
                                    .weight(.bold)
                            )
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .frame(width: 249, height: 114, alignment: .center)
                    }
                }
                .shadow(radius: 10)
                
                Button(action: {
                    showKCALCalcView = true
                }) {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 315, height: 240)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [topColor, bottomColor]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .cornerRadius(40)
                        
                        Image("Flame")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150, height: 194)
                            .opacity(0.15)
                        
                        Text(languageManager.localizedString(forKey: "kcalcalc"))
                            .font(
                                Font.custom("Roboto Mono", size: 40)
                                    .weight(.bold)
                            )
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .frame(width: 249, height: 114, alignment: .center)
                    }
                }
            }
            .shadow(radius: 10)
            // Przy pojawieniu się widoku wczytujemy wartość z UserDefaults
            .onAppear {
                let userTheme = UserDefaults.standard.string(forKey: "appTheme") ?? "Theme1"
                self.currentTheme = userTheme
            }
            
            // Custom back button in the top-left corner
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss() // Cofanie do poprzedniego widoku
                }) {
                    Image("DoubleLeftBlue")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 230, height: 40)
                        .shadow(radius: 10)
                }
                Spacer() // Push content to the right
            }
            .padding(.horizontal)
            .padding(20) // Adjust padding as needed
            .padding(.top, -400) // Adjust padding as needed
        }
        .fullScreenCover(isPresented: $showBMICalcView) {
            BMICalcView()
                .environmentObject(webSocketManager) // Przekazanie instancji
                .environmentObject(languageManager)
        }
        .fullScreenCover(isPresented: $showKCALCalcView) {
            KCALCalcView()
                .environmentObject(webSocketManager) // Przekazanie instancji
                .environmentObject(languageManager)
        }
    }
    
    var backgroundView: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            Image("RunningMan2")
                .resizable()
                .scaledToFit()
                .frame(width: 600, height: 600)
                .opacity(0.37)
                .offset(x: -35)
        }
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

struct BMIKCALCalc_Previews: PreviewProvider {
    static var previews: some View {
        BMIKCALCalc()
            .environmentObject(WebSocketManager()) // Dodano dla podglądu
            .environmentObject(LocalizationManager()) // Dodano dla podglądu
    }
}
