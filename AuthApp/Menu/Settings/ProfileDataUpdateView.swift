import SwiftUI

struct ProfileDataUpdateView: View {
    @State private var gender: String = ""
    @State private var age: String = ""
    @State private var weight: String = ""
    @State private var height: String = ""
    @State private var selectedActivityIndex: Int = 0
    
    @Environment(\.presentationMode) var presentationMode // Obsługa cofania
    @EnvironmentObject var webSocketManager: WebSocketManager
    @EnvironmentObject var languageManager: LocalizationManager
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @State private var showSuccessAlert = false // Dodanie zmiennej stanu dla alertu
    
    @AppStorage("appTheme") private var currentTheme: String = "Theme1"
    
    let activityLevels: [(String, Float?)] = [
        ("Choose your activity", nil), // Opcja domyślna, nie wysyłana na serwer
        ("Very low (0-1 trainings/week)", 1.3),
        ("Low (2-3 trainings/week)", 1.4),
        ("Medium (4-5 trainings/week)", 1.6),
        ("High (6-7 trainings/week)", 1.75),
        ("Very high activity", 2.0)
    ]

    var body: some View {
        ZStack {
            backgroundView
            
            contentView
            
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
            // Tło – korzystamy ze zmiennych, które zależą od currentTheme
            let (topColor, bottomColor) = colorsForTheme(currentTheme)
            
            // Gradientowe tło
            LinearGradient(
                gradient: Gradient(colors: [topColor, bottomColor]),
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
                VStack{
                    Text(languageManager.localizedString(forKey: "edityourdata"))
                        .font(Font.custom("RobotoMono-Bold", size: 32))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .offset(y: -15)
                        .shadow(radius: 10)
                    
                    Text(languageManager.localizedString(forKey: "edityourdatatext"))
                        .font(Font.custom("RobotoMono-Bold", size: 20))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .offset(y: -15)
                        .shadow(radius: 10)
                }

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
                    
                    Picker(languageManager.localizedString(forKey: "activity_placeholder"), selection: $selectedActivityIndex) {
                        ForEach(0..<activityLevels.count, id: \.self) { index in
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
                    updateDataToServer()
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
        }
        .alert(isPresented: $showSuccessAlert) {
            Alert(
                title: Text(languageManager.localizedString(forKey: "success")),
                message: Text(languageManager.localizedString(forKey: "successtext")),
                dismissButton: .default(Text("OK")) {
                    presentationMode.wrappedValue.dismiss() // Zamknięcie widoku po zatwierdzeniu
                }
            )
        }

    }
    
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    private func updateDataToServer() {
        guard let userId = UserDefaults.standard.string(forKey: "user_id"),
              let sessionId = UserDefaults.standard.string(forKey: "session_id") else {
            print("Required data (user_id or session_id) is missing in UserDefaults")
            return
        }
        
        var userData: [String: Any] = ["userId": userId]
        
        if !gender.isEmpty {
            userData["gender"] = gender
        }
        if let ageInt = Int(age), !age.isEmpty {
            userData["age"] = ageInt
        }
        if let weightInt = Int(weight), !weight.isEmpty {
            userData["weight"] = weightInt
        }
        if let heightInt = Int(height), !height.isEmpty {
            userData["height"] = heightInt
        }
        
        // Wysyłanie aktywności tylko jeśli użytkownik nie wybrał "Choose your activity"
        if selectedActivityIndex > 0 && selectedActivityIndex < activityLevels.count {
            userData["activity"] = activityLevels[selectedActivityIndex].1
        }
        
        if userData.keys.count == 1 { // Jeśli zawiera tylko "userId"
            print("No data to update")
            alertMessage = languageManager.localizedString(forKey: "updatealert")
            showAlert = true
            return
        }
        
        var urlComponents = URLComponents(string: "http://192.168.1.22:8000/health/users")
        urlComponents?.queryItems = [URLQueryItem(name: "userId", value: userId)]
        
        guard let url = urlComponents?.url else {
            print("Invalid URL")
            return
        }
        
        let body: [String: Any] = ["user": userData]
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(sessionId, forHTTPHeaderField: "session-id")
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
            request.httpBody = jsonData
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("Data sent to the server: \(jsonString)")
            }
        } catch {
            print("Data encoding error: \(error.localizedDescription)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error while sending data: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Server response - Status code: \(httpResponse.statusCode)")
            }
            
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("Server response: \(responseString)")
            } else {
                print("No data in server response")
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                DispatchQueue.main.async {
                    self.showSuccessAlert = true
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

struct ProfilDataUpdateView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileDataUpdateView(
        )
        .environmentObject(WebSocketManager()) // Jeśli wymaga `WebSocketManager`
        .environmentObject(LocalizationManager())
    }
}

