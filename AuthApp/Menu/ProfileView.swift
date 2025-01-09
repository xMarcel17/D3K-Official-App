import SwiftUI

struct ProfileView: View {
    var username: String
    @Binding var isLoggedIn: Bool
    @Binding var showWelcomeAlert: Bool
    @Binding var usernameField: String
    @Binding var passwordField: String
    @Binding var rememberMe: Bool
    @EnvironmentObject var bleManager: BLEManager // Pobieramy BLEManager z EnvironmentObject
    
    var body: some View {
        ZStack {
            ZStack{
                VStack (spacing: 20){
                    Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 209, height: 209)
                    .background(
                    Image("lamiine")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 209, height: 209)
                    .clipped()
                    )
                    .cornerRadius(209)
                    
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
                    
                    VStack (alignment: .leading, spacing: 10){
                        Text("Gender:")
                          .font(
                            Font.custom("Roboto Mono", size: 24)
                              .weight(.bold)
                          )
                          .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                        
                        
                        Text("Age:")
                          .font(
                            Font.custom("Roboto Mono", size: 24)
                              .weight(.bold)
                          )
                          .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                        
                        
                        Text("Weight:")
                          .font(
                            Font.custom("Roboto Mono", size: 24)
                              .weight(.bold)
                          )
                          .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
             
                        
                        Text("Height:")
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
                    .padding(.trailing, 180)
                   
                    Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 321, height: 4)
                    .background(Color(red: 0.27, green: 0.43, blue: 0.69))
                    .cornerRadius(50)
                    .shadow(radius: 5)
                    
                    
                    Button(action: {
                        logout()
                    }) {
                        Text("Logout")
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
                    .padding(.top, 8)
                    
                }
                .padding(.bottom, 10)
                
            }
            .padding(.bottom, 10)
            
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

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(username: "TestBart",
                    isLoggedIn: .constant(false),
                    showWelcomeAlert: .constant(false),
                    usernameField: .constant(""),
                    passwordField: .constant(""),
                    rememberMe: .constant(false)
        )
        .environmentObject(BLEManager())             // Przykładowe środowisko BLEManager
        //.preferredColorScheme(.light)                 // Dodatkowe zabezpieczenie dla podglądu
    }
}
