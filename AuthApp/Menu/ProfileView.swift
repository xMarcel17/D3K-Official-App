import SwiftUI

struct ProfileView: View {
    var username: String
    
    @EnvironmentObject var webSocketManager: WebSocketManager
    @EnvironmentObject var languageManager: LocalizationManager
    
    @Binding var isLoggedIn: Bool
    @Binding var showWelcomeAlert: Bool
    @Binding var usernameField: String
    @Binding var passwordField: String
    @Binding var rememberMe: Bool
    
    @State private var avatarURL: URL? // URL pobranego zdjęcia
    @State private var isAvatarLoaded = false // Czy udało się pobrać zdjęcie?

    // Dodane zmienne @State do przechowywania danych użytkownika
    @State private var gender: String = "Loading..."
    @State private var age: String = "Loading..."
    @State private var weight: String = "Loading..."
    @State private var height: String = "Loading..."
    @State private var bmr: String = "Loading..."
    @State private var tdee: String = "Loading..."
    @State private var isLoading = true

    @AppStorage("appTheme") private var currentTheme: String = "Theme1"
    
    var body: some View {
        ZStack {
            // Duży ZStack (niezmieniony)
            ZStack {
                VStack(spacing: 20) {
        
                    ZStack{
                        Circle()
                            .fill(Color.white)
                            .frame(width: 237, height: 237)
                            .shadow(radius: 10)
                        
                        if isAvatarLoaded, let url = avatarURL {
                            AsyncImage(url: url) { phase in
                                if let image = phase.image {
                                    image.resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 209, height: 209)
                                        .clipShape(Circle())
                                } else {
                                    Image("BasicProfilePicture")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 209, height: 209)
                                        .clipShape(Circle())
                                }
                            }
                        } else {
                            Image("BasicProfilePicture")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 209, height: 209)
                                .clipShape(Circle())
                        }
                    }

                    Text(username)
                        .font(
                            Font.custom("Roboto Mono", size: 40)
                                .weight(.bold)
                        )
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                        .frame(width: 500, height: 38, alignment: .center)
                    
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 321, height: 4)
                        .background(Color(red: 0.27, green: 0.43, blue: 0.69))
                        .cornerRadius(50)
                        .shadow(radius: 5)
                    
                    HStack (spacing: 125){
                        VStack (alignment: .leading, spacing: 10){
                            Text(languageManager.localizedString(forKey: "sex:"))
                              .font(
                                Font.custom("Roboto Mono", size: 24)
                                  .weight(.bold)
                              )
                              .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                            
                            
                            Text(languageManager.localizedString(forKey: "age:"))
                              .font(
                                Font.custom("Roboto Mono", size: 24)
                                  .weight(.bold)
                              )
                              .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                            
                            
                            Text(languageManager.localizedString(forKey: "weight"))
                              .font(
                                Font.custom("Roboto Mono", size: 24)
                                  .weight(.bold)
                              )
                              .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                 
                            
                            Text(languageManager.localizedString(forKey: "height"))
                              .font(
                                Font.custom("Roboto Mono", size: 24)
                                  .weight(.bold)
                              )
                              .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                             
                            
                            Text("BMR:")
                              .font(
                                Font.custom("Roboto Mono", size: 24)
                                  .weight(.bold)
                              )
                              .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                              
                            
                            Text("TDEE:")
                              .font(
                                Font.custom("Roboto Mono", size: 24)
                                  .weight(.bold)
                              )
                              .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                            
                        }
                        
                        
                        VStack (alignment: .trailing, spacing: 10){
                            Text(gender)
                              .font(
                                Font.custom("Roboto Mono", size: 24)
                                  .weight(.bold)
                              )
                              .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                            
                            
                            Text(age)
                              .font(
                                Font.custom("Roboto Mono", size: 24)
                                  .weight(.bold)
                              )
                              .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                            
                            
                            Text(weight)
                              .font(
                                Font.custom("Roboto Mono", size: 24)
                                  .weight(.bold)
                              )
                              .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                 
                            
                            Text(height)
                              .font(
                                Font.custom("Roboto Mono", size: 24)
                                  .weight(.bold)
                              )
                              .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                             
                            
                            Text(bmr)
                              .font(
                                Font.custom("Roboto Mono", size: 24)
                                  .weight(.bold)
                              )
                              .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                              
                            
                            Text(tdee)
                              .font(
                                Font.custom("Roboto Mono", size: 24)
                                  .weight(.bold)
                              )
                              .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                            
                        }
                    }
                    
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 321, height: 4)
                        .background(Color(red: 0.27, green: 0.43, blue: 0.69))
                        .cornerRadius(50)
                        .shadow(radius: 5)
                    
                    Button(action: {
                        logout()
                    }) {
                        Text(languageManager.localizedString(forKey: "logout"))
                            .font(Font.custom("RobotoMono-Bold", size: 23))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 231, height: 63)
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
                    .padding(.bottom, 6)
                }
                .padding(.bottom, 10)
            }
            .padding(.bottom, 10)
            
            ZStack {
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
            // Przy pojawieniu się widoku wczytujemy wartość z UserDefaults
            .onAppear {
                let userTheme = UserDefaults.standard.string(forKey: "appTheme") ?? "Theme1"
                self.currentTheme = userTheme
            }
        }
        .onAppear {
            fetchUserData()
            fetchAvatar()
        }
        .background(.white)
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
    
    func fetchUserData() {
        guard let userId = UserDefaults.standard.string(forKey: "user_id"),
              let sessionId = UserDefaults.standard.string(forKey: "session_id"),
              let url = URL(string: "http://192.168.1.22:8000/health/users/?userId=\(userId)") else {
            print("Invalid userId or sessionId")
            return
        }

        // Logowanie wartości userId i sessionId
        print("Fetching user data with the following details:")
        print("User ID: \(userId)")
        print("Session ID: \(sessionId)")
        print("Request URL: \(url)")

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(sessionId, forHTTPHeaderField: "session-id") // Dodanie wymaganego nagłówka

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                return
            }

            if let response = response as? HTTPURLResponse {
                print("HTTP Status Code: \(response.statusCode)")
                if response.statusCode != 200 {
                    print("Unexpected response code: \(response.statusCode)")
                    return
                }
            }

            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let userData = json["user"] as? [String: Any] {
                        DispatchQueue.main.async {
                            self.gender = userData["gender"] as? String ?? "N/A"
                            self.age = String(userData["age"] as? Int ?? 0)
                            self.weight = String(userData["weight"] as? Int ?? 0)
                            self.height = String(userData["height"] as? Int ?? 0)
                            self.bmr = String(userData["bmr"] as? Int ?? 0)
                            self.tdee = String(userData["tdee"] as? Int ?? 0)
                            self.isLoading = false
                        }
                    } else {
                        print("Failed to parse 'user' key in JSON response.")
                    }
                } catch {
                    print("JSON decoding error: \(error.localizedDescription)")
                }
            }
        }.resume()
    }

    
    func logout() {
        // Sprawdzenie, czy mamy zapisany session_id
        if let sessionId = UserDefaults.standard.string(forKey: "session_id") {
            // Wywołanie żądania do endpointa wylogowania
            guard let url = URL(string: "http://192.168.1.22:8000/auth/logout") else {
                print("Invalid logout URL")
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue(sessionId, forHTTPHeaderField: "session-id") // Ustawienie session-id w nagłówku

            // Wykonanie żądania
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Logout failed with error: \(error.localizedDescription)")
                    return
                }

                if let httpResponse = response as? HTTPURLResponse {
                    print("Logout HTTP response status: \(httpResponse.statusCode)")
                    
                    if httpResponse.statusCode == 204 {
                        print("Logout successful")
                        clearSessionData()
                    } else {
                        print("Logout failed with status code: \(httpResponse.statusCode)")
                    }
                }
            }.resume()
        } else {
            print("No session ID found; skipping logout request")
        }
    }
    
    // Funkcja pomocnicza do czyszczenia danych sesji
    func clearSessionData() {
        // Czyszczenie danych po wylogowaniu
        usernameField = ""
        passwordField = ""
        isLoggedIn = false
        showWelcomeAlert = false

        rememberMe = false
        UserDefaults.standard.set(false, forKey: "isRemembered")

        UserDefaults.standard.removeObject(forKey: "session_id")
        UserDefaults.standard.removeObject(forKey: "user_id")

        print("Session ID and User ID cleared, Remember Me unchecked.")
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

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(
            username: "TestUser",                      // Przykładowa nazwa użytkownika
            isLoggedIn: .constant(true),               // Binding z przykładową wartością "true"
            showWelcomeAlert: .constant(false),        // Binding z przykładową wartością "false"
            usernameField: .constant("TestUser"),      // Binding do pola nazwy użytkownika
            passwordField: .constant("password123"),   // Binding do pola hasła
            rememberMe: .constant(true)                // Binding do pola "Remember me"
        )
        .environmentObject(WebSocketManager())        // Dodaj obiekt WebSocketManager
        .environmentObject(LocalizationManager())     // Dodaj obiekt LocalizationManager
        .previewDisplayName("ProfileView Preview")
    }
}
