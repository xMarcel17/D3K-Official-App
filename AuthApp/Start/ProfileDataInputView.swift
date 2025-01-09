import SwiftUI

struct ProfileDataInputView: View {
    @State private var gender: String = ""
    @State private var age: String = ""
    @State private var weight: String = ""
    @State private var height: String = ""
    @State private var bmr: String = ""
    @State private var tdee: String = ""
    
    // Przechowujemy userId i sessionId uzyskane po logowaniu/rejestracji
    let userId: String
    let sessionId: String
    
    @State private var showAlert = false
    @State private var alertMessage = ""

    // Dodajemy bindowane właściwości przekazane z LoginView
    @Binding var loggedInUsername: String?
    @Binding var isLoggedIn: Bool
    @Binding var showWelcomeAlert: Bool
    @Binding var username: String
    @Binding var password: String
    @Binding var rememberMe: Bool

    // Nowa zmienna do obsługi nawigacji
    @State private var showWelcomeView = false
    
    @EnvironmentObject var webSocketManager: WebSocketManager
    @EnvironmentObject var languageManager: LocalizationManager

    var body: some View {
        if showWelcomeView {
            MenuView(   //WelcomeView
                username: loggedInUsername ?? "",
                isLoggedIn: $isLoggedIn,
                showWelcomeAlert: $showWelcomeAlert,
                usernameField: $username,
                passwordField: $password,
                rememberMe: $rememberMe
            )
        } else {
            ZStack {
                backgroundView
                
                contentView
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
        }
    }

    var contentView: some View {
        ZStack {
            VStack(spacing: 20) {
                Text("Enter your data")
                    .font(Font.custom("RobotoMono-Bold", size: 32))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .offset(y: -15)
                    .shadow(radius: 10)

                Group {
                    ZStack(alignment: .leading) {
                        if gender.isEmpty { // Sprawdzamy, czy pole tekstowe jest puste
                            Text(languageManager.localizedString(forKey: "gender_placeholder"))
                                .padding(.leading, 17) // Opcjonalne odsunięcie tekstu
                                .font(.system(size: 16, weight: .light, design: .monospaced))
                                .foregroundColor(.white)
                        }
                        TextField("", text: $gender)
                        .padding()
                    }
                    
                    ZStack(alignment: .leading) {
                        if age.isEmpty { // Sprawdzamy, czy pole tekstowe jest puste
                            Text(languageManager.localizedString(forKey: "age_placeholder"))
                                .padding(.leading, 17) // Opcjonalne odsunięcie tekstu
                                .font(.system(size: 16, weight: .light, design: .monospaced))
                                .foregroundColor(.white)
                        }
                        TextField("", text: $age)
                        .padding()
                        .keyboardType(.numberPad)
                    }

                    ZStack(alignment: .leading) {
                        if weight.isEmpty { // Sprawdzamy, czy pole tekstowe jest puste
                            Text(languageManager.localizedString(forKey: "weight_placeholder"))
                                .padding(.leading, 17) // Opcjonalne odsunięcie tekstu
                                .font(.system(size: 16, weight: .light, design: .monospaced))
                                .foregroundColor(.white)
                        }
                        TextField("", text: $weight)
                        .padding()
                        .keyboardType(.numberPad)
                    }

                    ZStack(alignment: .leading) {
                        if height.isEmpty { // Sprawdzamy, czy pole tekstowe jest puste
                            Text(languageManager.localizedString(forKey: "height_placeholder"))
                                .padding(.leading, 17) // Opcjonalne odsunięcie tekstu
                                .font(.system(size: 16, weight: .light, design: .monospaced))
                                .foregroundColor(.white)
                        }
                        TextField("", text: $height)
                        .padding()
                        .keyboardType(.numberPad)
                    }
                    
                    ZStack(alignment: .leading) {
                        if bmr.isEmpty { // Sprawdzamy, czy pole tekstowe jest puste
                            Text("BMR")
                                .padding(.leading, 17) // Opcjonalne odsunięcie tekstu
                                .font(.system(size: 16, weight: .light, design: .monospaced))
                                .foregroundColor(.white)
                        }
                        TextField("", text: $bmr)
                        .padding()
                        .keyboardType(.numberPad)
                    }

                    ZStack(alignment: .leading) {
                        if tdee.isEmpty { // Sprawdzamy, czy pole tekstowe jest puste
                            Text("TDEE")
                                .padding(.leading, 17) // Opcjonalne odsunięcie tekstu
                                .font(.system(size: 16, weight: .light, design: .monospaced))
                                .foregroundColor(.white)
                        }
                        TextField("", text: $tdee)
                        .padding()
                        .keyboardType(.numberPad)
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
                    sendDataToServer()
                }) {
                    Text("Potwierdź dane")
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
            .padding()
            .onTapGesture {
                dismissKeyboard()
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Błąd"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    private func sendDataToServer() {
        guard !gender.isEmpty,
                  !age.isEmpty, Int(age) != nil,
                  !weight.isEmpty, Int(weight) != nil,
                  !height.isEmpty, Int(height) != nil,
                  !bmr.isEmpty, Int(bmr) != nil,
                  !tdee.isEmpty, Int(tdee) != nil else {
                alertMessage = "Wszystkie pola muszą być poprawnie wypełnione."
                showAlert = true
                return
            }
        
        guard let url = URL(string: "http://192.168.1.20:8000/health/users") else {
            print("Nieprawidłowy URL")
            return
        }

        // Przygotowanie ciała żądania z danymi użytkownika
        let body: [String: Any] = [
            "userId": userId,
            "gender": gender,
            "age": Int(age) ?? 0,
            "weight": Int(weight) ?? 0,
            "height": Int(height) ?? 0,
            "bmr": Int(bmr) ?? 0,
            "tdee": Int(tdee) ?? 0
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(sessionId, forHTTPHeaderField: "session-id")

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
            request.httpBody = jsonData
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("Wysyłanie danych na serwer: \(jsonString)")
            }
        } catch {
            print("Błąd przy kodowaniu danych: \(error.localizedDescription)")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Błąd przy wysyłaniu danych: \(error.localizedDescription)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("Odpowiedź serwera, kod statusu: \(httpResponse.statusCode)")

                if httpResponse.statusCode == 201 || httpResponse.statusCode == 200 {
                    print("Dane zostały pomyślnie przesłane.")
                    
                    // Przejdź do WelcomeView po pomyślnym wysłaniu danych
                    DispatchQueue.main.async {
                        self.showWelcomeView = true
                    }
                } else {
                    print("Wystąpił błąd przy przesyłaniu danych, kod: \(httpResponse.statusCode)")
                }
            }

            if let data = data,
               let responseString = String(data: data, encoding: .utf8) {
                print("Odpowiedź serwera: \(responseString)")
            }
        }.resume()
    }
}

struct ProfilDataInputView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileDataInputView(
            userId: .StringLiteralType(""),
            sessionId: .StringLiteralType(""),
            loggedInUsername: .constant(nil),
            isLoggedIn: .constant(false),
            showWelcomeAlert: .constant(false),
            username: .constant(""),
            password: .constant(""),
            rememberMe: .constant(false)
        )
        .environmentObject(WebSocketManager()) // Jeśli wymaga `WebSocketManager`
        .environmentObject(LocalizationManager())
    }
}

