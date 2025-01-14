import SwiftUI

struct ChangePasswordView: View {
    var username: String
    @State private var resetCode = ""
    @State private var newPassword = ""
    @State private var confirmPassword = "" // Pole na potwierdzenie hasła
    @State private var showResetCodeAlert = false
    @State private var newResetCode = ""
    @State private var showMismatchAlert = false // Alert w przypadku różnicy haseł
    @Binding var isLoggedIn: Bool
    
    @Environment(\.presentationMode) var presentationMode // Obsługa cofania
    @EnvironmentObject var webSocketManager: WebSocketManager
    @EnvironmentObject var languageManager: LocalizationManager

    var body: some View {
        ZStack{
            backgroundView
            
            contenView
            
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
    
    var contenView: some View {
        VStack(spacing: 20) {
            Text("Password change \nfor \n\(username)")
                .font(
                Font.custom("Roboto Mono", size: 32)
                .weight(.bold)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding()
                .shadow(radius: 10)
            
            Group{
                ZStack(alignment: .leading) {
                    if resetCode.isEmpty { // Sprawdzamy, czy pole tekstowe jest puste
                        Text("Reset code")
                            .padding(.leading, 17) // Opcjonalne odsunięcie tekstu
                            .font(.system(size: 16, weight: .light, design: .monospaced))
                            .foregroundColor(.white)
                    }
                    TextField("", text: $resetCode)
                    .padding()
                    .keyboardType(.numberPad)
                }
                
                ZStack(alignment: .leading) {
                    if newPassword.isEmpty { // Sprawdzamy, czy pole tekstowe jest puste
                        Text("New password")
                            .padding(.leading, 17) // Opcjonalne odsunięcie tekstu
                            .font(.system(size: 16, weight: .light, design: .monospaced))
                            .foregroundColor(.white)
                    }
                    SecureField("", text: $newPassword)
                    .padding()
                }
                
                ZStack(alignment: .leading) {
                    if confirmPassword.isEmpty { // Sprawdzamy, czy pole tekstowe jest puste
                        Text("Repeat new password")
                            .padding(.leading, 17) // Opcjonalne odsunięcie tekstu
                            .font(.system(size: 16, weight: .light, design: .monospaced))
                            .foregroundColor(.white)
                    }
                    SecureField("", text: $confirmPassword)
                    .padding()
                }

            }
            .padding()
            .foregroundColor(.white)
            .font(.system(size: 16, weight: .semibold, design: .monospaced))
            .autocapitalization(.none)
            .background(.black.opacity(0.4))
            .frame(maxWidth: 323, maxHeight: 60)
            .disableAutocorrection(true)
            .cornerRadius(100)

            Button(action: {
                if newPassword == confirmPassword {
                    changePassword()
                } else {
                    showMismatchAlert = true
                }
            }) {
                Text("Change password")
                    .font(Font.custom("RobotoMono-Bold", size: 17))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                    .padding()
                    .frame(width: 231, height: 58)
                    .background(Color.white)
                    .cornerRadius(100)
                    .offset(y: 20)
                    .shadow(radius: 10)
            }
        }
        .padding(.bottom, 100)
        .onTapGesture {
            dismissKeyboard()
        }
        .overlay(
            Group {
                if showResetCodeAlert {
                    CustomResetCodeAlert(
                        resetCode: newResetCode,
                        onDismiss: {
                            isLoggedIn = false
                            resetLoginData()
                        },
                        customMessage: "You have managed to succesfully change your password. Save the code in a safe place. This message is displayed once."
                    )
                    .frame(width: 325, height: 392)
                    .background(Color.white)
                    .cornerRadius(40)
                    .shadow(radius: 90)
                    .transition(.opacity)
                    .padding(.bottom, 150)
                }
            }
        )
        .alert(isPresented: $showMismatchAlert) {
            Alert(title: Text("Błąd"),
                  message: Text("Hasła nie są zgodne. Spróbuj ponownie."),
                  dismissButton: .default(Text("OK")))
        }
    }

    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func changePassword() {
        guard let url = URL(string:"http://192.168.1.20:8000/auth/reset_password") else {
            print("Invalid URL")
            return
        }

        let body: [String: Any] = [
            "username": username,
            "password_reset_code": resetCode,
            "new_password": newPassword
        ]
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
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
                print("Password change failed: \(error.localizedDescription)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("Received HTTP response: \(httpResponse.statusCode)")
                
                if httpResponse.statusCode == 200 {
                    DispatchQueue.main.async {
                        if let data = data,
                           let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let resetCode = json["password_reset_code"] as? String {
                            self.newResetCode = resetCode
                            self.showResetCodeAlert = true
                        }
                    }
                } else {
                    print("Password change failed with status code: \(httpResponse.statusCode)")
                }
            } else {
                print("No valid HTTP response received")
            }
        }.resume()
    }

    func resetLoginData() {
        let loginView = LoginView()
        loginView.resetLoginData()
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    @State static private var isLoggedIn = true

    static var previews: some View {
        ChangePasswordView(
            username: "TestBart",
            isLoggedIn: $isLoggedIn
        )
    }
}
