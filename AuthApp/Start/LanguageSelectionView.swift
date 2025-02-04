import SwiftUI

struct LanguageSelectionView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    @Environment(\.presentationMode) var presentationMode // Obsługa cofania
    @EnvironmentObject var webSocketManager: WebSocketManager
    @EnvironmentObject var languageManager: LocalizationManager
    
    @AppStorage("appTheme") private var currentTheme: String = "Theme1"

    var body: some View {
        NavigationView {
            ZStack {

                backgroundView
                
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
                    Spacer() // Przesuwa zawartość w prawo
                }
                .padding(.horizontal)
                .padding(20) // Dostosuj padding według potrzeb
                .padding(.top, -400) // Dostosuj padding według potrzeb
                .accessibilityIdentifier("languageSelectionBackButton")
                
                VStack(spacing: 25) {
                    Text(languageManager.localizedString(forKey: "select_language_title"))
                        .font(Font.custom("RobotoMono-Bold", size: 32))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .offset(y: -30)
                        .shadow(radius: 10)
                    
                    CustomButton(title: "Polski", imageName: "Polish") {
                        localizationManager.currentLanguage = "pl"
                        presentationMode.wrappedValue.dismiss() // Cofanie do poprzedniego widoku
                    }
                    
                    CustomButton(title: "English", imageName: "English") {
                        localizationManager.currentLanguage = "en"
                        presentationMode.wrappedValue.dismiss() // Cofanie do poprzedniego widoku
                    }
                    
                    CustomButton(title: "Deutsch", imageName: "German") {
                        localizationManager.currentLanguage = "de"
                        presentationMode.wrappedValue.dismiss() // Cofanie do poprzedniego widoku
                    }
                    
                    CustomButton(title: "Español", imageName: "Spanish") {
                        localizationManager.currentLanguage = "es"
                        presentationMode.wrappedValue.dismiss() // Cofanie do poprzedniego widoku
                    }
                }
            }
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

struct CustomButton: View {
    var title: String
    var imageName: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                HStack {
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 46, height: 46)
                        .padding(.leading, 16)

                    Spacer() // Pozostaw miejsce dla obrazu
                }

                // Tekst zawsze na środku
                Text(title)
                    .font(Font.custom("RobotoMono-Bold", size: 20))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                    .offset(x: 6)
            }
            .frame(width: 323, height: 74)
            .background(Color.white)
            .cornerRadius(100)
            .shadow(radius: 10)
        }
    }
}


struct LanguageSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        LanguageSelectionView()
        .environmentObject(LocalizationManager())
    }
}
