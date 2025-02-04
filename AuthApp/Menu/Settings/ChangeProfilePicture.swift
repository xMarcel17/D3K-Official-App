import SwiftUI
import PhotosUI

struct ChangeProfilePicture: View {
    @EnvironmentObject var languageManager: LocalizationManager
    
    @Environment(\.presentationMode) var presentationMode // Obsługa cofania
    @State private var selectedImage: UIImage?
    @State private var avatarURL: URL?
    @State private var isImagePickerPresented = false
    @State private var isUploading = false
    @State private var uploadMessage: String?
    
    @AppStorage("appTheme") private var currentTheme: String = "Theme1"

    var body: some View {
        ZStack {
            backgroundView
            
            VStack {
                Text(languageManager.localizedString(forKey: "changepicturetitle"))
                    .font(.system(size: 32, weight: .bold, design: .monospaced))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .shadow(radius: 10)
                
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 225, height: 225)
                        .shadow(radius: 10)

                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 197, height: 197)
                            .clipShape(Circle())
                    } else if let url = avatarURL {
                        AsyncImage(url: url) { phase in
                            if let image = phase.image {
                                image.resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 197, height: 197)
                                    .clipShape(Circle())
                            } else {
                                Image("BasicProfilePicture")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 197, height: 197)
                                    .clipShape(Circle())
                            }
                        }
                    } else {
                        Image("BasicProfilePicture")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 197, height: 197)
                            .clipShape(Circle())
                    }
                }
                .onAppear {
                    fetchAvatar()
                }

                Button(action: {
                    isImagePickerPresented.toggle()
                    uploadMessage = nil // Resetowanie uploadMessage
                }) {
                    Text(languageManager.localizedString(forKey: "uploadnewpicture"))
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                        .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                        .padding()
                        .frame(width: 273, height: 58)
                        .background(Color.white)
                        .cornerRadius(100)
                        .shadow(radius: 10)
                }
                .padding(.top, 20)
                .sheet(isPresented: $isImagePickerPresented) {
                    ImagePicker(selectedImage: $selectedImage)
                }
            }
            .padding(.bottom, 100)
        
            ZStack{
                if selectedImage != nil {
                    Button(action: {
                        uploadProfilePicture()
                    }) {
                        Text(languageManager.localizedString(forKey: "changeprofilepicture"))
                            .font(.system(size: 16, weight: .bold, design: .monospaced))
                            .foregroundColor(Color.white)
                            .padding()
                            .frame(width: 273, height: 58)
                            .background(Color(red: 0.27, green: 0.43, blue: 0.69))
                            .cornerRadius(100)
                            .shadow(radius: 10)
                    }
                    .padding(.top, 10)
                }
                
                if let message = uploadMessage {
                    Text(message)
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 273, height: 58)
                        .background(isUploading ? Color.gray : Color.green)
                        .cornerRadius(100)
                        .shadow(radius: 10)
                        .padding(.top, 10)
                }
            }
            .padding(.top, 400)

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
                Spacer()
            }
            .padding(.horizontal)
            .padding(20)
            .padding(.top, -400)
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

    func fetchAvatar() {
        let userId = UserDefaults.standard.string(forKey: "user_id") ?? ""
        let sessionId = UserDefaults.standard.string(forKey: "session_id") ?? ""

        if userId.isEmpty || sessionId.isEmpty {
            print("Error: User ID or Session ID is empty!")
            return
        }

        let url = URL(string: "http://192.168.1.22:8000/auth/avatar?user_id=\(userId)")!
        var request = URLRequest(url: url)
        request.setValue(sessionId, forHTTPHeaderField: "session-id")

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Avatar download error:", error.localizedDescription)
                    return
                }

                guard let data = data,
                      let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200,
                      let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                      let avatarLink = jsonResponse["avatar_link"] as? String else {
                    print("Error: Invalid server response or missing avatar link")
                    return
                }

                // Zamiana "localhost" na "192.168.1.22"
                let fixedAvatarLink = avatarLink.replacingOccurrences(of: "localhost", with: "192.168.1.22")

                if let avatarURL = URL(string: fixedAvatarLink) {
                    self.avatarURL = avatarURL
                } else {
                    print("Error: Invalid URL after replacement")
                }
            }
        }.resume()
    }

    
    func uploadProfilePicture() {
        guard let image = selectedImage,
              let imageData = image.jpegData(compressionQuality: 0.8) else {
            uploadMessage = languageManager.localizedString(forKey: "picturefirst")
            return
        }

        let userId = UserDefaults.standard.string(forKey: "user_id") ?? ""
        let sessionId = UserDefaults.standard.string(forKey: "session_id") ?? ""

        if userId.isEmpty || sessionId.isEmpty {
            uploadMessage = languageManager.localizedString(forKey: "picturesecond")
            print("Error: User ID or Session ID is empty!")
            return
        }

        let url = URL(string: "http://192.168.1.22:8000/forum-write/user-avatar")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(sessionId, forHTTPHeaderField: "session-id") // Zmienione na "session-id"

        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()

        // Dodanie user_id jako RequestBody
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"user_id\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(userId)\r\n".data(using: .utf8)!)

        // Dodanie obrazu
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"avatar\"; filename=\"profile.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        // Wysłanie żądania
        isUploading = true
        uploadMessage = languageManager.localizedString(forKey: "picturethird")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isUploading = false
                if let error = error {
                    uploadMessage = "Błąd: \(error.localizedDescription)"
                    print("Upload error:", error)
                    return
                }

                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 201 {
                        uploadMessage = languageManager.localizedString(forKey: "picturefourth")
                        print("Upload successful")
                    } else {
                        uploadMessage = "Błąd serwera: \(httpResponse.statusCode)"
                        print("Server error:", httpResponse.statusCode)
                    }
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

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else {
                return
            }

            provider.loadObject(ofClass: UIImage.self) { image, _ in
                DispatchQueue.main.async {
                    self.parent.selectedImage = image as? UIImage
                }
            }
        }
    }
}

struct ChangeProfilePicture_Previews: PreviewProvider {
    static var previews: some View {
        // Możesz użyć Group, by wyświetlić kilka wariantów, np. Light/Dark mode.
        Group {
            NavigationView {
                ChangeProfilePicture()
            }
            .previewDisplayName("Light Mode")

            NavigationView {
                ChangeProfilePicture()
            }
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode")
        }
    }
}

