import SwiftUI

struct MenuView: View {
    var username: String // Zmienna jako wartość, a nie Binding

    @EnvironmentObject var webSocketManager: WebSocketManager
    @EnvironmentObject var bleManager: BLEManager
    @EnvironmentObject var languageManager: LocalizationManager

    @Binding var isLoggedIn: Bool
    @Binding var showWelcomeAlert: Bool
    @Binding var usernameField: String
    @Binding var passwordField: String
    @Binding var rememberMe: Bool

    var body: some View {
        TabView {
            // MainView
            MainView(
                username: username
            )
            .environmentObject(webSocketManager)
            .environmentObject(languageManager)
            .tabItem {
                Image(systemName: "house.fill")
                Text(languageManager.localizedString(forKey: "home"))
            }

            // SmartbandView
            SmartbandView(
                username: username
            )
            .environmentObject(bleManager)
            .environmentObject(webSocketManager)
            .environmentObject(languageManager)
            .tabItem {
                Image(systemName: "applewatch")
                Text(languageManager.localizedString(forKey: "band"))
            }

            // ProfileView
            ProfileView(
                username: username,
                isLoggedIn: $isLoggedIn,
                showWelcomeAlert: $showWelcomeAlert,
                usernameField: $usernameField,
                passwordField: $passwordField,
                rememberMe: $rememberMe
            )
            .environmentObject(webSocketManager)
            .environmentObject(languageManager)
            .tabItem {
                Image(systemName: "person.crop.circle.fill")
                Text(languageManager.localizedString(forKey: "profile"))
            }

            // SettingsView
            SettingsView(
                username: username,
                isLoggedIn: $isLoggedIn
            )
            .environmentObject(webSocketManager)
            .environmentObject(languageManager)
            .tabItem {
                Image(systemName: "gearshape.fill")
                Text(languageManager.localizedString(forKey: "settings"))
            }
        }
        .alert(isPresented: $showWelcomeAlert) {
            Alert(
                title: Text(languageManager.localizedString(forKey: "login_successful")),
                message: Text(languageManager.localizedString(forKey: "login_successful_message")),
                dismissButton: .default(Text("OK"))
            )

        }
        .onAppear {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                for window in windowScene.windows {
                    window.overrideUserInterfaceStyle = .light
                }
            }
        }
    }
}




struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(
            username: "TestUser", // Przykładowe dane dla Binding
            isLoggedIn: .constant(true),
            showWelcomeAlert: .constant(false),
            usernameField: .constant("TestUser"),
            passwordField: .constant("password123"),
            rememberMe: .constant(true)
        )
        .environmentObject(BLEManager())
        .environmentObject(WebSocketManager())
        .environmentObject(LocalizationManager())
        .preferredColorScheme(.light)
    }
}

