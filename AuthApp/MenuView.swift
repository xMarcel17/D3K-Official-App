import SwiftUI

struct MenuView: View {
    var username: String
    @Binding var isLoggedIn: Bool
    @Binding var showWelcomeAlert: Bool
    @Binding var usernameField: String
    @Binding var passwordField: String
    @Binding var rememberMe: Bool
    @EnvironmentObject var bleManager: BLEManager // Pobieramy BLEManager z EnvironmentObject
    
    var body: some View {
        ZStack {
            // TabView
            TabView {
                MainView(username: "TestUser",                     // Przykładowa nazwa użytkownika
                     isLoggedIn: .constant(true),              // Ustawienie przykładowej wartości Binding
                     showWelcomeAlert: .constant(false),       // Binding dla alertu
                     usernameField: .constant("TestUser"),     // Binding dla pola nazwy użytkownika
                     passwordField: .constant("password123"),  // Binding dla pola hasła
                     rememberMe: .constant(true))
                    .environmentObject(BLEManager())
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("HOME")
                    }
                
                SmartbandView()
                    .tabItem {
                        Image(systemName: "applewatch")
                        Text("BAND")
                    }
                
                DataView()
                    .tabItem {
                        Image(systemName: "person.crop.circle.fill")
                        Text("PROFILE")
                    }
                
                TestView()
                    .tabItem {
                        Image(systemName: "gearshape.fill")
                        Text("SETTINGS")
                    }
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
               // Wymuszenie trybu jasnego na wypadek braku zadziałania w `init`
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
            username: "TestUser",                     // Przykładowa nazwa użytkownika
            isLoggedIn: .constant(true),              // Ustawienie przykładowej wartości Binding
            showWelcomeAlert: .constant(false),       // Binding dla alertu
            usernameField: .constant("TestUser"),     // Binding dla pola nazwy użytkownika
            passwordField: .constant("password123"),  // Binding dla pola hasła
            rememberMe: .constant(true)              // Binding dla przełącznika "zapamiętaj mnie",
        )
        .environmentObject(BLEManager())             // Przykładowe środowisko BLEManager
        //.preferredColorScheme(.light)                 // Dodatkowe zabezpieczenie dla podglądu
    }
}
