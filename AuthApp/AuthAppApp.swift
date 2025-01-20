import SwiftUI

@main
struct AuthAppApp: App {
    @StateObject private var localizationManager = LocalizationManager.shared
    @StateObject private var bleManager = BLEManager() // Instancja BLEManager
    @StateObject private var webSocketManager = WebSocketManager() // // Instancja WebSocketManager
    @State private var showIntro = true // Flaga sterująca wyświetlaniem IntroView (Splash Screen)
    
    var body: some Scene {
        WindowGroup {
            if showIntro {
                IntroView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            showIntro = false   // Flaga ustawiana na false (przełączenie na widok LoginView)
                        }
                    }
            } else {
                NavigationView {
                    LoginView() 
                        .environmentObject(localizationManager) // Przekazany obiekt localizationManager
                        .environmentObject(bleManager)  // Przekazany obiekt bleManager
                        .environmentObject(webSocketManager)    // Przekazany obiekt webSocketManager
                }
            }
        }
    }
}
