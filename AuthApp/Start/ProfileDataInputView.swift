import SwiftUI

struct ProfileDataInputView: View {
    @State private var gender: String = ""
    @State private var age: String = ""
    @State private var weight: String = ""
    @State private var height: String = ""
    @State private var selectedActivityIndex: Int = 0
    
    let userId: String
    let sessionId: String
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @Binding var loggedInUsername: String?
    @Binding var isLoggedIn: Bool
    @Binding var showWelcomeAlert: Bool
    @Binding var username: String
    @Binding var password: String
    @Binding var rememberMe: Bool
    
    @State private var showWelcomeView = false
    
    @EnvironmentObject var webSocketManager: WebSocketManager
    @EnvironmentObject var languageManager: LocalizationManager
    
    @AppStorage("appTheme") private var currentTheme: String = "Theme1"
    
    let activityLevels: [(String, Float)] = [
        ("Very low (0-1 trainings/week)", 1.3),
        ("Low (2-3 trainings/week)", 1.4),
        ("Medium (4-5 trainings/week)", 1.6),
        ("High (6-7 trainings/week)", 1.75),
        ("Very high activity", 2.0)
    ]
    
    var body: some View {
        if showWelcomeView {
            MenuView(
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
            // Tło – korzystamy ze zmiennych, które zależą od currentTheme
            let (topColor, bottomColor) = colorsForTheme(currentTheme)
            
            // Gradientowe tło
            LinearGradient(
                gradient: Gradient(colors: [topColor, bottomColor]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            Image("RunningMan")
                .resizable()
                .scaledToFit()
                .frame(width: 600, height: 600)
                .offset(x: -35)
        }

    }
    
    var contentView: some View {
        VStack(spacing: 20) {
            Text(languageManager.localizedString(forKey: "enter_data_title"))
                .font(Font.custom("RobotoMono-Bold", size: 32))
                .foregroundColor(.white)
                .shadow(radius: 10)
            
            Group {
                ZStack(alignment: .leading) {
                    if gender.isEmpty {
                        Text(languageManager.localizedString(forKey: "gender_placeholder"))
                            .padding(.leading, 17)
                            .font(.system(size: 16, weight: .light, design: .monospaced))
                            .foregroundColor(.white)
                    }
                    TextField("", text: $gender)
                        .padding()
                }
                ZStack(alignment: .leading) {
                    if age.isEmpty {
                        Text(languageManager.localizedString(forKey: "age_placeholder"))
                            .padding(.leading, 17)
                            .font(.system(size: 16, weight: .light, design: .monospaced))
                            .foregroundColor(.white)
                    }
                    TextField("", text: $age)
                        .padding()
                        .keyboardType(.numberPad)
                }
                ZStack(alignment: .leading) {
                    if weight.isEmpty {
                        Text(languageManager.localizedString(forKey: "weight_placeholder"))
                            .padding(.leading, 17)
                            .font(.system(size: 16, weight: .light, design: .monospaced))
                            .foregroundColor(.white)
                    }
                    TextField("", text: $weight)
                        .padding()
                        .keyboardType(.numberPad)
                }
                ZStack(alignment: .leading) {
                    if height.isEmpty {
                        Text(languageManager.localizedString(forKey: "height_placeholder"))
                            .padding(.leading, 17)
                            .font(.system(size: 16, weight: .light, design: .monospaced))
                            .foregroundColor(.white)
                    }
                    TextField("", text: $height)
                        .padding()
                        .keyboardType(.numberPad)
                }
                
                Picker(languageManager.localizedString(forKey: "activity_placeholder"), selection: $selectedActivityIndex) {
                    ForEach(0..<activityLevels.count, id: \..self) { index in
                        Text(activityLevels[index].0).tag(index)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .frame(width: 323, height: 60)
                .cornerRadius(100)
                .foregroundColor(.white)
                .padding()
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
                Text(languageManager.localizedString(forKey: "confirm_data_button"))
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
            Alert(title: Text(languageManager.localizedString(forKey: "failure_message")), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    private func sendDataToServer() {
        guard !gender.isEmpty, let ageInt = Int(age), let weightInt = Int(weight), let heightInt = Int(height) else {
            alertMessage = languageManager.localizedString(forKey: "data_input_message")
            showAlert = true
            return
        }
        
        guard let url = URL(string: "http://192.168.1.22:8000/health/users") else {
            print("Invalid URL")
            return
        }
        
        let activityValue = activityLevels[selectedActivityIndex].1
        let body: [String: Any] = [
            "userId": userId,
            "gender": gender,
            "age": ageInt,
            "weight": weightInt,
            "height": heightInt,
            "activity": activityValue
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(sessionId, forHTTPHeaderField: "session-id")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("Data encoding error: \(error.localizedDescription)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Data encoding error: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
                DispatchQueue.main.async {
                    self.showWelcomeView = true
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

