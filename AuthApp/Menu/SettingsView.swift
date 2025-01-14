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
    
    var body: some View {
        ZStack {
            ZStack{
                Image("Gears")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 565, height: 586)
                    .opacity(0.37)
                
                VStack(spacing: 40){
                    Text("Settings")
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
                                    Text("Change user data")
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
                                    Text("Change profile picture")
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
                                    Text("Change password")
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
                                    Text("Change language")
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
                                    Text("Change theme")
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
                                    Text("App information")
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
                                    Text("Contact us")
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
}

//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsView(
//        )
//        .environmentObject(BLEManager())             // Przykładowe środowisko BLEManager
//        //.preferredColorScheme(.light)                 // Dodatkowe zabezpieczenie dla podglądu
//    }
//}
