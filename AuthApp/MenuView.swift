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
                Text("HOME")
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
                Text("BAND")
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
                Text("PROFILE")
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
                Text("SETTINGS")
            }
        }
        .alert(isPresented: $showWelcomeAlert) {
            Alert(
                title: Text("Notification"),
                message: Text("Login successful!"),
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

