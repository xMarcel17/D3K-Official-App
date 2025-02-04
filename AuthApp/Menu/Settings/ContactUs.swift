import SwiftUI

struct ContactUs: View {
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

    }

    var contentView: some View {
        VStack (spacing: 10){
            Text(languageManager.localizedString(forKey: "contact"))
                .font(
                    Font.custom("Roboto Mono", size: 40)
                        .weight(.bold)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
            
            Text(languageManager.localizedString(forKey: "contacttext"))
                .font(
                    Font.custom("Roboto Mono", size: 20)
                        .weight(.medium)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .frame(width: 341, height: 160, alignment: .center)
            
            HStack{
                Image("Mail")
                  .resizable()
                  .scaledToFit()
                  .frame(width: 32, height: 32)
                  .padding(.top, 4)
                
                Text("d3kapp.official@gmail.com")
                  .font(
                    Font.custom("Roboto Mono", size: 20)
                      .weight(.bold)
                  )
                  .multilineTextAlignment(.center)
                  .foregroundColor(.white)
                  .frame(width: 304, height: 21, alignment: .center)
                
            }
            .padding(.top, 30)
    
        }
        .padding(.bottom, 90)
        .shadow(radius: 10)
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

struct ContactUs_Previews: PreviewProvider {
    static var previews: some View {
        ContactUs(
        )
        .environmentObject(WebSocketManager()) // Jeśli wymaga `WebSocketManager`
        .environmentObject(LocalizationManager())
    }
}

