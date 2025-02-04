import SwiftUI

struct ChangeTheme: View {
    @Environment(\.presentationMode) var presentationMode // Obsługa cofania
    @EnvironmentObject var webSocketManager: WebSocketManager
    @EnvironmentObject var languageManager: LocalizationManager
    
    @AppStorage("appTheme") private var currentTheme: String = "Theme1"
    
    var body: some View {

            ZStack {
                backgroundView
                
                contentView
                
                // Custom back button in the top-left corner
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss() // Cofanie do poprzedniego widoku
                    }) {
                        Image("DoubleLeftWhite")
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
        }
    
    var backgroundView: some View {
        ZStack {
            // Tło – korzystamy ze zmiennych, które zależą od currentTheme
            let (topColor, bottomColor) = colorsForTheme(currentTheme)
            
            // Gradientowe tło
            LinearGradient(
                gradient: Gradient(colors: [topColor, bottomColor]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)

            // Tło RunningMan w trybie wyblakłym
            Image("RunningMan")
                .resizable()
                .scaledToFit()
                .frame(width: 600, height: 600)
                .offset(x: -35)
        }
        // Przy pojawieniu się widoku wczytujemy wartość z UserDefaults
//        .onAppear {
//            let userTheme = UserDefaults.standard.string(forKey: "appTheme") ?? "Theme1"
//            self.currentTheme = userTheme
//        }
    }

    var contentView: some View {
        VStack (spacing: 40){
            Text(languageManager.localizedString(forKey: "changetheme"))
              .font(
                Font.custom("Roboto Mono", size: 32)
                  .weight(.bold)
              )
              .multilineTextAlignment(.center)
              .foregroundColor(.white)
              .shadow(radius: 10)
            
            HStack (spacing: 25){
                
                Button(action: {
                    UserDefaults.standard.set("Theme1", forKey: "appTheme")
                }) {
                    VStack (spacing: -10){
                        ZStack{
                            Circle()
                                .fill(Color.white)
                                .frame(width: 134, height: 134)
                                .shadow(radius: 10)
                            
                            
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 114, height: 114)
                                .background(
                                    Image("MiamiVice")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 114, height: 114)
                                        .clipped()
                                )
                                .cornerRadius(197)
                        }

                        Text(languageManager.localizedString(forKey: "miamivice"))
                            .font(Font.custom("RobotoMono-Bold", size: 20))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                            .padding()
                            .frame(width: 165, height: 38)
                            .background(Color.white)
                            .cornerRadius(100)
                            .offset(y: 20)
                            .shadow(radius: 10)
                    }
                }
                
                Button(action: {
                    UserDefaults.standard.set("Theme2", forKey: "appTheme")
                }) {
                    VStack (spacing: -10){
                        ZStack{
                            Circle()
                                .fill(Color.white)
                                .frame(width: 134, height: 134)
                                .shadow(radius: 10)
                            
                            
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 114, height: 114)
                                .background(
                                    Image("SeaBreeze")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 114, height: 114)
                                        .clipped()
                                )
                                .cornerRadius(197)
                        }

                        Text(languageManager.localizedString(forKey: "seabreeze"))
                            .font(Font.custom("RobotoMono-Bold", size: 20))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                            .padding()
                            .frame(width: 165, height: 38)
                            .background(Color.white)
                            .cornerRadius(100)
                            .offset(y: 20)
                            .shadow(radius: 10)
                    }
                }
            }
        }
        .padding(.bottom, 100)

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

struct ChangeTheme_Previews: PreviewProvider {
    static var previews: some View {
        ChangeTheme(
        )
        .environmentObject(WebSocketManager()) // Jeśli wymaga `WebSocketManager`
        .environmentObject(LocalizationManager())
    }
}

