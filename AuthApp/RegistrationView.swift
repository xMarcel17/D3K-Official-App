import SwiftUI

struct RegistrationView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var passwordSecond = ""
    @State private var errorMessage: String?
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showResetCodeAlert = false
    @State private var resetCode = ""
    @State private var isUserExisting = false

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var isLoggedIn: Bool
    @Binding var loggedInUsername: String?
    @Binding var showRegistrationSuccessAlert: Bool
    
    @EnvironmentObject var webSocketManager: WebSocketManager
    @EnvironmentObject var languageManager: LocalizationManager

    var body: some View {
        ZStack {
            // Tło: Gradient i RunningMan
            backgroundView
            
            // Zawartość: Prostokąt i komponenty
            contentView
            
            // Custom back button in the top-left corner
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
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
        .navigationBarHidden(true)
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
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
                Text("Registration")
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
                }
                
                ZStack(alignment: .leading) {
                    if passwordSecond.isEmpty { // Sprawdzamy, czy pole tekstowe jest puste
                        Text(languageManager.localizedString(forKey: "password_placeholder"))
                            .padding(.leading, 17) // Opcjonalne odsunięcie tekstu
                            .font(.system(size: 16, weight: .semibold, design: .monospaced))
                            .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                    }
                    SecureField("", text: $passwordSecond)
                        .padding()
                        .background(Color(red: 0.87, green: 0.85, blue: 0.89, opacity: 0.75))
                        .cornerRadius(10)
                        .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                        .autocapitalization(.none)
                        .textContentType(.password)
                        .font(.system(size: 16, weight: .semibold, design: .monospaced))
                }

                Button(action: {
                    validateAndRegister()
                }) {
                    Text("Register")
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
            
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Notification"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }

            if showResetCodeAlert {
                CustomResetCodeAlert(
                    resetCode: resetCode,
                    onDismiss: {
                        self.loginAfterRegistration()
                    },
                    customMessage: "Oto twój kod do resetowania hasła. Zapisz go w bezpiecznym miejscu. Ta wiadomość wyświetlana jest jednorazowo."
                )
            }
        }
        .offset(y: 110)
    }
    
    func validateAndRegister() {
        if password != passwordSecond {
            alertMessage = "Hasła nie są identyczne. Spróbuj ponownie."
            showAlert = true
            return
        }
        register()
    }
    
    func register() {
        print("Register button tapped")
        
        guard let url = URL(string: "http://192.168.1.20:8000/auth/register") else {
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
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("Request body: \(jsonString)")
            }
        } catch {
            print("Failed to encode body: \(error.localizedDescription)")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.alertMessage = "Registration failed: \(error.localizedDescription)"
                    self.showAlert = true
                }
                print("Registration failed with error: \(error.localizedDescription)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("Received HTTP response: \(httpResponse.statusCode)")
                
                if httpResponse.statusCode == 403 {
                    DispatchQueue.main.async {
                        self.alertMessage = "An account with this username already exists. Please try again."
                        self.showAlert = true
                    }
                } else if httpResponse.statusCode == 201 {
                    DispatchQueue.main.async {
                        if let data = data,
                           let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let resetCode = json["password_reset_code"] as? String {
                            self.resetCode = resetCode
                            self.showResetCodeAlert = true
                        }
                        // Usunięto wywołanie loginAfterRegistration() z tego miejsca
                    }
                } else {
                    DispatchQueue.main.async {
                        self.alertMessage = "Registration failed with status code \(httpResponse.statusCode)"
                        self.showAlert = true
                    }
                }
            } else {
                print("No valid HTTP response received")
            }
        }.resume()
    }

    func loginAfterRegistration() {
        print("Logging in after registration")

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
                print("Login after registration failed with error: \(error.localizedDescription)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("Received HTTP response after login: \(httpResponse.statusCode)")
                
                if httpResponse.statusCode == 200 {
                    if let sessionId = httpResponse.value(forHTTPHeaderField: "session_id") {
                        UserDefaults.standard.set(sessionId, forKey: "session_id")
                        print("Session ID saved after login: \(sessionId)")
                    }
                    
                    if let data = data,
                       let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let userId = json["user_id"] as? String {
                        UserDefaults.standard.set(userId, forKey: "user_id")
                        print("User ID saved after login: \(userId)")
                        
                        if let sessionId = httpResponse.value(forHTTPHeaderField: "session_id") {
                            UserDefaults.standard.set(sessionId, forKey: "session_id")
                            print("Session ID saved after login: \(sessionId)")
                            
                            DispatchQueue.main.async {
                                webSocketManager.connect(withUserId: userId, sessionId: sessionId) // Połącz z WebSocket
                            }
                        }
                    }

                    

                    DispatchQueue.main.async {
                        self.verifyUser()
                        self.isLoggedIn = true
                        self.loggedInUsername = self.username
                        self.showRegistrationSuccessAlert = true
                    }
                }
            } else {
                print("No valid HTTP response received after registration")
            }
        }.resume()
    }
    
    func verifyUser() {
        guard let userId = UserDefaults.standard.string(forKey: "user_id"),
              let url = URL(string: "http://192.168.1.20:8000/health/users?userId=\(userId)") else {
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
                    if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
                        self.isUserExisting = true
                        print("User exists in the system.")
                    } else {
                        self.isUserExisting = false
                        print("User does not exist in the system.")
                    }
                }
            }
        }.resume()
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(
            isLoggedIn: .constant(false),
            loggedInUsername: .constant(nil),
            showRegistrationSuccessAlert: .constant(false)
        )
        .environmentObject(WebSocketManager()) // Jeśli wymaga `WebSocketManager`
        .environmentObject(LocalizationManager())
    }
}
