import SwiftUI

struct MainView: View {
    var username: String
    
    @EnvironmentObject var webSocketManager: WebSocketManager
    @EnvironmentObject var languageManager: LocalizationManager

    @State private var showBMIKCALCalc = false // Zmienna kontrolująca pełnoekranowe przejście
    @State private var showTrainings = false // Zmienna kontrolująca pełnoekranowe przejście
    
    @State private var avatarURL: URL? // URL pobranego zdjęcia
    @State private var isAvatarLoaded = false // Czy udało się pobrać zdjęcie?

    @State private var showBadgesForumAlert = false
    
    @AppStorage("appTheme") private var currentTheme: String = "Theme1"
    
    var body: some View {
        ZStack {
            // Tło – korzystamy ze zmiennych, które zależą od currentTheme
            let (topColor, bottomColor) = colorsForTheme(currentTheme)
            
            ZStack {
                VStack(spacing: 15) {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 343, height: 78)
                            .background(
                                // Gradientowe tło
                                LinearGradient(
                                    gradient: Gradient(colors: [topColor, bottomColor]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .cornerRadius(50)
                            .shadow(radius: 5)
                        
                        Text(String(format: languageManager.localizedString(forKey: "welcome_user"),
                                    username))
                        //Text("Welcome, testestestestsetestes!")
                            .font(Font.custom("RobotoMono-Bold", size: 18))
                            .frame(width: 250, height: 58)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.white)
                            .padding(.trailing, 60)
                            .accessibilityIdentifier("welcomeIdentifier")
                        
                        ZStack{
                            Circle()
                                .fill(Color.white)
                                .frame(width: 60, height: 60)
                                .shadow(radius: 10)
                            
                            if isAvatarLoaded, let url = avatarURL {
                                AsyncImage(url: url) { phase in
                                    if let image = phase.image {
                                        image.resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 50, height: 50)
                                            .clipShape(Circle())
                                    } else {
                                        Image("BasicProfilePicture")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 50, height: 50)
                                            .clipShape(Circle())
                                    }
                                }
                            } else {
                                Image("BasicProfilePicture")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                            }
                        }
                        .padding(.leading, 260)
                        .onAppear {
                            fetchAvatar()
                        }
                            
                    }
                    .frame(width: 353, height: 78)
                    
                    Button {
                        showTrainings = true
                    } label: {
                        ZStack {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 343, height: 211)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [topColor, bottomColor]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .cornerRadius(40)
                                .shadow(radius: 5)
                            
                            Image("HeartrateRed")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(.bottom, 40)
                                .opacity(0.3)
                            
                            Image("RunningManSmall")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 109, height: 137)
                                .padding(.bottom, 40)
                                .padding(.trailing, 20)
                            
                            Text(languageManager.localizedString(forKey: "my_trainings"))
                                .font(Font.custom("RobotoMono-Bold", size: 28))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .padding(.top, 140)
                        }
                        .frame(width: 343, height: 211)
                    }
                    
                    HStack(spacing: 15) {
                        VStack(spacing: 15) {
                            Button {
                                showBadgesForumAlert = true
                            } label: {
                                ZStack {
                                    Rectangle()
                                        .foregroundColor(.clear)
                                        .frame(width: 165, height: 172)
                                        .background(
                                            LinearGradient(
                                                gradient: Gradient(colors: [topColor, bottomColor]),
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                        )
                                        .cornerRadius(40)
                                        .shadow(radius: 5)
                                    
                                    Image("MessageBlue")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 57, height: 57)
                                        .padding(.bottom, 80)
                                        .padding(.trailing, 71)
                                        .opacity(0.4)
                                    
                                    Image("ForumLogo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 76, height: 76)
                                        .padding(.bottom, 5)
                                        .padding(.leading, 40)
                                    
                                    Text(languageManager.localizedString(forKey: "forum"))
                                        .font(Font.custom("RobotoMono-Bold", size: 28))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.white)
                                        .padding(.top, 110)
                                }
                                .frame(width: 165, height: 172)
                            }
                            
                            Button {
                                showBadgesForumAlert = true
                            } label: {
                                ZStack {
                                    Rectangle()
                                        .foregroundColor(.clear)
                                        .frame(width: 165, height: 172)
                                        .background(
                                            LinearGradient(
                                                gradient: Gradient(colors: [topColor, bottomColor]),
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                        )
                                        .cornerRadius(40)
                                        .shadow(radius: 5)
                                    
                                    Image("Stars")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 74, height: 97)
                                        .padding(.bottom, 60)
                                        .padding(.leading, 60)
                                        .opacity(0.5)
                                    
                                    Image("Trophy")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 89, height: 80)
                                        .padding(.bottom, 12)
                                        .padding(.trailing, 45)
                                    
                                    Text(languageManager.localizedString(forKey: "badges"))
                                        .font(Font.custom("RobotoMono-Bold", size: 28))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.white)
                                        .padding(.top, 100)
                                }
                                .frame(width: 165, height: 172)
                            }
                        }
                        .frame(width: 165, height: 359)
                        
                        Button {
                            showBMIKCALCalc = true // Aktywacja pełnoekranowego przejścia
                        } label: {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 163, height: 359)
                                    .background(
                                        LinearGradient(
                                            gradient: Gradient(colors: [topColor, bottomColor]),
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                    .cornerRadius(40)
                                    .shadow(radius: 5)
                                
                                Image("Food")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 163, height: 163)
                                    .padding(.bottom, 150)
                                    .opacity(0.5)
                                
                                Image("Meter")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 139, height: 73)
                                    .padding(.top, 110)
                                
                                Text("BMI & KCAL")
                                    .font(Font.custom("RobotoMono-Bold", size: 23))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white)
                                    .padding(.top, 235)
                                
                                Text(languageManager.localizedString(forKey: "calculator"))
                                    .font(Font.custom("RobotoMono-Bold", size: 20))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white)
                                    .padding(.top, 290)
                            }
                            .frame(width: 163, height: 359)
                        }
                        .fullScreenCover(isPresented: $showBMIKCALCalc) {
                            BMIKCALCalc()
                                .environmentObject(webSocketManager)
                                .environmentObject(languageManager)
                        }
                        .fullScreenCover(isPresented: $showTrainings) {
                            TrainingsView()
                                .environmentObject(webSocketManager)
                                .environmentObject(languageManager)
                        }
                    }
                    .frame(width: 343, height: 359)
                }
                .padding(.bottom, 10)
                
                ZStack {
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
        .alert(isPresented: $showBadgesForumAlert) {
            Alert(
                title: Text(languageManager.localizedString(forKey: "coming_soon")),
                message: Text(languageManager.localizedString(forKey: "coming_soon_message")),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    func fetchAvatar() {
        guard let userId = UserDefaults.standard.string(forKey: "user_id"),
              let sessionId = UserDefaults.standard.string(forKey: "session_id") else {
            print("Error: Missing User ID or Session ID")
            return
        }

        let url = URL(string: "http://192.168.1.22:8000/auth/avatar?user_id=\(userId)")!
        var request = URLRequest(url: url)
        request.setValue(sessionId, forHTTPHeaderField: "session-id")

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Avatar download error:", error.localizedDescription)
                    self.isAvatarLoaded = false
                    return
                }

                guard let data = data,
                      let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200,
                      let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                      let avatarLink = jsonResponse["avatar_link"] as? String else {
                    print("Error: Invalid server response")
                    self.isAvatarLoaded = false
                    return
                }

                let fixedAvatarLink = avatarLink.replacingOccurrences(of: "localhost", with: "192.168.1.22")

                if let avatarURL = URL(string: fixedAvatarLink) {
                    self.avatarURL = avatarURL
                    self.isAvatarLoaded = true
                } else {
                    print("Error: Invalid URL after replacement")
                    self.isAvatarLoaded = false
                }
            }
        }.resume()
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

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MainView(username: "TestUser")
                .environmentObject(WebSocketManager())   // Jeżeli w projekcie tworzysz obiekt WebSocketManager
                .environmentObject(LocalizationManager()) // Jeżeli w projekcie tworzysz obiekt LocalizationManager
        }
        .preferredColorScheme(.light) // Podgląd w jasnym trybie (opcjonalnie)
    }
}

