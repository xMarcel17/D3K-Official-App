import SwiftUI

struct ChangePasswordView: View {
    let username: String
    @State private var resetCode = ""
    @State private var newPassword = ""
    @State private var showResetCodeAlert = false
    @State private var newResetCode = ""
    @Binding var isLoggedIn: Bool

    var body: some View {
        VStack(spacing: 20) {
            Text("Zmiana hasła dla \(username)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            TextField("Kod resetujący", text: $resetCode)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5.0)
                .autocapitalization(.none)
            
            SecureField("Nowe hasło", text: $newPassword)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5.0)
            
            Button(action: {
                changePassword()
            }) {
                Text("Zmień hasło")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(Color.green)
                    .cornerRadius(15.0)
            }
        }
        .padding()
        .overlay(
            // Wyświetlamy niestandardowy alert w stylu `CustomResetCodeAlert`
            Group {
                if showResetCodeAlert {
                    CustomResetCodeAlert(
                        resetCode: newResetCode,
                        onDismiss: {
                            isLoggedIn = false // Wylogowanie po potwierdzeniu
                            resetLoginData() // Reset danych logowania
                        },
                        customMessage: "Pomyślnie zmieniono hasło. Oto twój nowy kod do resetowania hasła. Zapisz go w bezpiecznym miejscu. Ta wiadomość wyświetlana jest jednorazowo. Po potwierdzeniu wyloguje cię z konta."
                    )
                }
            }
        )
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
                        // Pobierz nowy kod resetu hasła z odpowiedzi serwera
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
    
    // Funkcja resetująca dane logowania
    func resetLoginData() {
        // Tworzymy instancję LoginView i resetujemy dane
        let loginView = LoginView()
        loginView.resetLoginData()
    }
}
