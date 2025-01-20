import SwiftUI

struct LoginView: View {
    @EnvironmentObject var languageManager: LocalizationManager
    @EnvironmentObject var webSocketManager: WebSocketManager

    @State internal var username = ""
    @State internal var password = ""
    @State internal var errorMessage: String?
    @State internal var isLoggedIn = false
    @State internal var loggedInUsername: String?
    @State internal var showAlert = false
    @State internal var alertMessage = ""
    @State internal var showWelcomeAlert = false
    @State internal var showLogoutAlert = false
    @State internal var showRegistrationSuccessAlert = false
    @State internal var rememberMe = false
    @State internal var showLanguageSelection = false
    @State internal var isUserExisting = false
    
    var body: some View {
        if isLoggedIn && isUserExisting {
            MenuView(   //WelcomeView
                username: loggedInUsername ?? "",
                isLoggedIn: $isLoggedIn,
                showWelcomeAlert: $showWelcomeAlert,
                usernameField: $username,
                passwordField: $password,
                rememberMe: $rememberMe
            )
            .onDisappear {
                if !isLoggedIn {
                    webSocketManager.disconnect()
                }
            }
        } else if isLoggedIn && !isUserExisting {
            ProfileDataInputView(
                userId: UserDefaults.standard.string(forKey: "user_id") ?? "",
                sessionId: UserDefaults.standard.string(forKey: "session_id") ?? "",
                loggedInUsername: $loggedInUsername,
                isLoggedIn: $isLoggedIn,
                showWelcomeAlert: $showWelcomeAlert,
                username: $username,
                password: $password,
                rememberMe: $rememberMe
            )
            .environmentObject(languageManager)
        } else {
            ZStack {
                // Tło: Gradient i RunningMan
                backgroundView
                
                // Zawartość: Prostokąt i komponenty
                contentView
            }
            
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Notification"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                
            }
            .alert(isPresented: $showLogoutAlert) {
                Alert(title: Text("Notification"), message: Text("Successfully logged out!"), dismissButton: .default(Text("OK")))
            }
            .onAppear {
                if !UserDefaults.standard.bool(forKey: "isRemembered") {
                    resetLoginData()
                } else {
                    loadRememberedCredentials()
                }
                print("WebSocketManager in LoginView: \(webSocketManager)")
            }
            .fullScreenCover(isPresented: $showLanguageSelection) {
                LanguageSelectionView()
                    .environmentObject(languageManager)
            }
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
    }
    
    var backgroundView: some View {
        ZStack {
            // Gradientowe tło
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.75, green: 0.73, blue: 0.87),
                    Color(red: 0.5, green: 0.63, blue: 0.83)
                ]),
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
            
            Image("AppIconTransparent")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 300, height: 300)
                .clipped()
                .padding(.bottom, 480)
        }
    }

    var contentView: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white)
                .frame(width: 321, height: 436)
                .cornerRadius(30)
                .shadow(radius: 10)
                

            VStack(spacing: 20) {
                Text("Login Account")
                    .font(Font.custom("RobotoMono-Bold", size: 28))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                

                ZStack(alignment: .leading) {
                    if username.isEmpty { // Sprawdzamy, czy pole tekstowe jest puste
                        Text(languageManager.localizedString(forKey: "username_placeholder"))
                            .padding(.leading, 17) // Opcjonalne odsunięcie tekstu
                            .font(.system(size: 16, weight: .semibold, design: .monospaced))
                            .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                    }
                    TextField("", text: $username)
                        .padding()
                        .background(Color(red: 0.87, green: 0.85, blue: 0.89, opacity: 0.75))
                        .cornerRadius(10)
                        .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                        .autocapitalization(.none)
                        .keyboardType(.default)
                        .textContentType(.username)
                        .font(.system(size: 16, weight: .semibold, design: .monospaced))
                        .accessibilityIdentifier("usernameTextField") // Dodano identyfikator
                }
                
                ZStack(alignment: .leading) {
                    if password.isEmpty { // Sprawdzamy, czy pole tekstowe jest puste
                        Text(languageManager.localizedString(forKey: "password_placeholder"))
                            .padding(.leading, 17) // Opcjonalne odsunięcie tekstu
                            .font(.system(size: 16, weight: .semibold, design: .monospaced))
                            .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                    }
                    SecureField("", text: $password)
                        .padding()
                        .background(Color(red: 0.87, green: 0.85, blue: 0.89, opacity: 0.75))
                        .cornerRadius(10)
                        .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                        .autocapitalization(.none)
                        .textContentType(.password)
                        .font(.system(size: 16, weight: .semibold, design: .monospaced))
                        .accessibilityIdentifier("passwordTextField") // Dodano identyfikator
                }

                Toggle(isOn: $rememberMe) {
                    Text(languageManager.localizedString(forKey: "remember_me"))
                        .font(Font.custom("RobotoMono-Regular", size: 15))
                        .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                }
                .padding()

                Button(action: {
                    login()
                }) {
                    Text(languageManager.localizedString(forKey: "login_button"))
                        .font(Font.custom("RobotoMono-Bold", size: 16))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 171, height: 46)
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
                    
                }
                .accessibilityIdentifier("loginButton") // Dodano identyfikator

                NavigationLink(
                    destination: RegistrationView(isLoggedIn: $isLoggedIn, loggedInUsername: $loggedInUsername, showRegistrationSuccessAlert: $showRegistrationSuccessAlert)
                        .environmentObject(webSocketManager)
                        .environmentObject(languageManager)
                ) {
                    Text(languageManager.localizedString(forKey: "register_button"))
                        .font(Font.custom("RobotoMono-Bold", size: 16))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 171, height: 46)
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
                }
            }
            .padding()
            .frame(maxWidth: 321, maxHeight: 436)
            
            Button(action: {
                showLanguageSelection = true
            }) {
                HStack {
                    Image("Globe")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .padding(.trailing, 8) // Odstęp między obrazkiem a tekstem

                    Text(languageManager.localizedString(forKey: "change_language"))
                        .font(
                            Font.custom("RobotoMono-Bold", size: 17)
                                .weight(.bold)
                        )
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                }
            }
            .padding()
            .offset(y: 250)
            .shadow(radius: 10)
        }
        .offset(y: 110)
    }
    
    func login() {
        print("Login button tapped")
        
        guard let url = URL(string: "http://192.168.1.20:8000/auth/login") else {
            print("Invalid URL")
            return
        }
        
        let body: [String: Any] = ["username": username, "password": password]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
            request.httpBody = jsonData
        } catch {
            print("Failed to encode body: \(error.localizedDescription)")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.alertMessage = "Login failed: \(error.localizedDescription)"
                    self.showAlert = true
                }
                print("Login failed with error: \(error.localizedDescription)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("Received HTTP response: \(httpResponse.statusCode)")
                
                if httpResponse.statusCode == 401 {
                    DispatchQueue.main.async {
                        self.alertMessage = "Incorrect login details. Please try again."
                        self.showAlert = true
                    }
                } else if httpResponse.statusCode == 200 {
                    if let sessionId = httpResponse.value(forHTTPHeaderField: "session_id") {
                        UserDefaults.standard.set(sessionId, forKey: "session_id")
                        print("Session ID saved: \(sessionId)")
                    }
                    
                    if let data = data,
                       let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let userId = json["user_id"] as? String {
                        UserDefaults.standard.set(userId, forKey: "user_id")
                        print("User ID saved: \(userId)")
                        
                        if let sessionId = httpResponse.value(forHTTPHeaderField: "session_id") {
                            UserDefaults.standard.set(sessionId, forKey: "session_id")
                            print("Session ID saved: \(sessionId)")
                            
                            DispatchQueue.main.async {
                                webSocketManager.connect(withUserId: userId, sessionId: sessionId) // Połącz z WebSocket
                            }
                        }
                    }
                    
                    if rememberMe {
                        UserDefaults.standard.set(username, forKey: "savedUsername")
                        UserDefaults.standard.set(password, forKey: "savedPassword")
                        UserDefaults.standard.set(true, forKey: "isRemembered")
                    } else {
                        UserDefaults.standard.removeObject(forKey: "savedUsername")
                        UserDefaults.standard.removeObject(forKey: "savedPassword")
                        UserDefaults.standard.set(false, forKey: "isRemembered")
                    }

                    DispatchQueue.main.async {
                        self.verifyUser {
                            self.errorMessage = nil
                            self.loggedInUsername = self.username
                            self.isLoggedIn = true
                            self.showWelcomeAlert = true
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.alertMessage = "Login failed with status code \(httpResponse.statusCode)"
                        self.showAlert = true
                    }
                }
            } else {
                print("No valid HTTP response received")
            }
        }.resume()
    }

    func loadRememberedCredentials() {
        if UserDefaults.standard.bool(forKey: "isRemembered") {
            self.username = UserDefaults.standard.string(forKey: "savedUsername") ?? ""
            self.password = UserDefaults.standard.string(forKey: "savedPassword") ?? ""
            self.rememberMe = true
        }
    }
    
    func resetLoginData() {
        UserDefaults.standard.removeObject(forKey: "savedUsername")
        UserDefaults.standard.removeObject(forKey: "savedPassword")
        UserDefaults.standard.set(false, forKey: "isRemembered")
        UserDefaults.standard.removeObject(forKey: "session_id")
        UserDefaults.standard.removeObject(forKey: "user_id")

        self.username = ""
        self.password = ""
        self.rememberMe = false
        self.isUserExisting = false
    }
    
    func verifyUser(completion: @escaping () -> Void) {
        guard let userId = UserDefaults.standard.string(forKey: "user_id"),
              let url = URL(string: "http://192.168.1.20:8000/health/users/?userId=\(userId)") else {
            print("Invalid URL or userId not available")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(UserDefaults.standard.string(forKey: "session_id") ?? "", forHTTPHeaderField: "session-id")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Request failed with error: \(error.localizedDescription)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                DispatchQueue.main.async {
                    self.isUserExisting = httpResponse.statusCode == 200 || httpResponse.statusCode == 201
                    print("User \(self.isUserExisting ? "exists" : "does not exist") in the system.")
                    completion()
                }
            }
        }.resume()
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            if shouldShow {
                placeholder()
            }
            self
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(
        )
        .environmentObject(WebSocketManager()) // Jeśli wymaga `WebSocketManager`
        .environmentObject(LocalizationManager())
    }
}
