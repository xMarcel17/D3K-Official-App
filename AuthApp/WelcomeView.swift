import SwiftUI

struct WelcomeView: View {
    var username: String
    @Binding var isLoggedIn: Bool
    @Binding var showWelcomeAlert: Bool
    @Binding var usernameField: String
    @Binding var passwordField: String
    @Binding var rememberMe: Bool
    @EnvironmentObject var bleManager: BLEManager // Pobieramy BLEManager z EnvironmentObject

    var body: some View {
        VStack(spacing: 20) {
            Text("Witaj, \(username)!")
                .font(.largeTitle)
                .fontWeight(.bold)

            NavigationLink(destination: BandView().environmentObject(bleManager)) {
                Text("Opaska")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(Color.blue)
                    .cornerRadius(15.0)
            }

            NavigationLink(destination: DataView().environmentObject(bleManager)) {
                Text("Dane")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(Color.green)
                    .cornerRadius(15.0)
            }

            Button(action: {
                logout()
            }) {
                Text("Wyloguj się")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(Color.red)
                    .cornerRadius(15.0)
            }
        }
        .padding()
        .alert(isPresented: $showWelcomeAlert) {
            Alert(title: Text("Notification"), message: Text("Login successful!"), dismissButton: .default(Text("OK")))
        }
    }

    func logout() {
        // Sprawdzenie, czy mamy zapisany session_id
        if let sessionId = UserDefaults.standard.string(forKey: "session_id") {
            // Wywołanie żądania do endpointa wylogowania
            guard let url = URL(string: "http://192.168.1.20:8000/auth/logout") else {
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
}
