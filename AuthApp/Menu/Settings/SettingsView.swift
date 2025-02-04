import SwiftUI

struct SettingsView: View {
    
    var username: String
    @EnvironmentObject var webSocketManager: WebSocketManager
    @EnvironmentObject var languageManager: LocalizationManager
    
    @State private var showChangeUserData = false // Zmienna kontrolująca pełnoekranowe przejście
    @State private var showChangeProfilePicture = false // Zmienna kontrolująca pełnoekranowe przejście
    @State private var showChangePassword = false // Zmienna kontrolująca pełnoekranowe przejście
    @State private var showChangeLanguage = false // Zmienna kontrolująca pełnoekranowe przejście
    @State private var showChangeTheme = false // Zmienna kontrolująca pełnoekranowe przejście
    @State private var showAppInformation = false // Zmienna kontrolująca pełnoekranowe przejście
    @State private var showContactUs = false // Zmienna kontrolująca pełnoekranowe przejście
    
    @Binding var isLoggedIn: Bool
    
    @AppStorage("appTheme") private var currentTheme: String = "Theme1"
    
    var body: some View {
        ZStack {
            ZStack{
                Image("Gears")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 565, height: 586)
                    .opacity(0.37)
                
                VStack(spacing: 40){
                    Text(languageManager.localizedString(forKey: "settingstitle"))
                      .font(
                        Font.custom("Roboto Mono", size: 40)
                          .weight(.bold)
                      )
                      .multilineTextAlignment(.center)
                      .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                    
                    
                    VStack(spacing: 27){
                        VStack{
                            Button{
                                showChangeUserData = true
                            } label: {
                                HStack{
                                    Text(languageManager.localizedString(forKey: "changeuserdata"))
                                        .font(Font.custom("RobotoMono-Bold", size: 17))
                                        .multilineTextAlignment(.leading)
                                        .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                                        .frame(width: 235, alignment: .leading)
                                    
                                    Image("SingleRightBlue")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                }
                            }
                            Rectangle()
                              .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                              .frame(width: 301, height: 1)
                        }
                        .fullScreenCover(isPresented: $showChangeUserData) {
                            ProfileDataUpdateView()
                                .environmentObject(webSocketManager)
                                .environmentObject(languageManager)
                        }
                        
                        VStack{
                            Button{
                                showChangeProfilePicture = true
                            } label: {
                                HStack{
                                    Text(languageManager.localizedString(forKey: "changeprofilepicture"))
                                        .font(Font.custom("RobotoMono-Bold", size: 17))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                                        .frame(width: 235, alignment: .leading)
                                    
                                    Image("SingleRightBlue")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                }
                            }
                            Rectangle()
                              .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                              .frame(width: 301, height: 1)
                        }
                        .fullScreenCover(isPresented: $showChangeProfilePicture) {
                            ChangeProfilePicture()
                                .environmentObject(webSocketManager)
                                .environmentObject(languageManager)
                        }
                        
                        VStack{
                            Button{
                                showChangePassword = true
                            } label: {
                                HStack{
                                    Text(languageManager.localizedString(forKey: "changepassword"))
                                        .font(Font.custom("RobotoMono-Bold", size: 17))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                                        .frame(width: 235, alignment: .leading)
                                    
                                    Image("SingleRightBlue")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                }
                            }
                            Rectangle()
                              .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                              .frame(width: 301, height: 1)
                        }
                        .fullScreenCover(isPresented: $showChangePassword) {
                            ChangePasswordView(
                                username: username,
                                isLoggedIn: $isLoggedIn
                            )
                                .environmentObject(webSocketManager)
                                .environmentObject(languageManager)
                        }
                        
                        VStack{
                            Button{
                                showChangeLanguage = true
                            } label: {
                                HStack{
                                    Text(languageManager.localizedString(forKey: "change_language"))
                                        .font(Font.custom("RobotoMono-Bold", size: 17))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                                        .frame(width: 235, alignment: .leading)
                                    
                                    Image("SingleRightBlue")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                }
                            }
                            Rectangle()
                              .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                              .frame(width: 301, height: 1)
                        }
                        .fullScreenCover(isPresented: $showChangeLanguage) {
                            LanguageSelectionView()
                                .environmentObject(webSocketManager)
                                .environmentObject(languageManager)
                        }
                        
                        VStack{
                            Button{
                                showChangeTheme = true
                            } label: {
                                HStack{
                                    Text(languageManager.localizedString(forKey: "changetheme"))
                                        .font(Font.custom("RobotoMono-Bold", size: 17))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                                        .frame(width: 235, alignment: .leading)
                                    
                                    Image("SingleRightBlue")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                }
                            }
                            Rectangle()
                              .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                              .frame(width: 301, height: 1)
                        }
                        .fullScreenCover(isPresented: $showChangeTheme) {
                            ChangeTheme()
                                .environmentObject(webSocketManager)
                                .environmentObject(languageManager)
                        }
                        
                        VStack{
                            Button{
                                showAppInformation = true
                            } label: {
                                HStack{
                                    Text(languageManager.localizedString(forKey: "appinfo"))
                                        .font(Font.custom("RobotoMono-Bold", size: 17))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                                        .frame(width: 235, alignment: .leading)
                                    
                                    Image("SingleRightBlue")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                }
                            }
                            Rectangle()
                              .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                              .frame(width: 301, height: 1)
                        }
                        .fullScreenCover(isPresented: $showAppInformation) {
                            AppInformation()
                                .environmentObject(webSocketManager)
                                .environmentObject(languageManager)
                        }
                        
                        VStack{
                            Button{
                                showContactUs = true
                            } label: {
                                HStack{
                                    Text(languageManager.localizedString(forKey: "contactus"))
                                        .font(Font.custom("RobotoMono-Bold", size: 17))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                                        .frame(width: 235, alignment: .leading)
                                    
                                    Image("SingleRightBlue")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                }
                                
                            }
                            Rectangle()
                              .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                              .frame(width: 301, height: 1)
                        }
                        .fullScreenCover(isPresented: $showContactUs) {
                            ContactUs()
                                .environmentObject(webSocketManager)
                                .environmentObject(languageManager)
                        }
                    }
                }
                .padding(.bottom, 100)
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
        }
        .background(.white)
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

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        // Możesz użyć Group, by pokazać różne warianty (np. Light/Dark Mode)
        Group {
            SettingsView(
                username: "PreviewUser",
                isLoggedIn: .constant(true)
            )
            .environmentObject(WebSocketManager())    // Obiekt środowiskowy
            .environmentObject(LocalizationManager()) // Obiekt środowiskowy
            .previewDisplayName("Light Mode")

            SettingsView(
                username: "PreviewUser",
                isLoggedIn: .constant(true)
            )
            .environmentObject(WebSocketManager())
            .environmentObject(LocalizationManager())
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode")
        }
    }
}
