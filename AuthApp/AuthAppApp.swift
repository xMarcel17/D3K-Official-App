import SwiftUI

@main
struct AuthAppApp: App {
    @StateObject private var localizationManager = LocalizationManager.shared
    @StateObject private var bleManager = BLEManager() // Jedna instancja BLEManager dla całej aplikacji
    @StateObject private var webSocketManager = WebSocketManager() // Dodajemy WebSocket Manager
    @State private var showIntro = true // Flaga sterująca wyświetlaniem IntroView
    
    var body: some Scene {
        WindowGroup {
            if showIntro {
                IntroView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            showIntro = false
                        }
                    }
            } else {
                NavigationView {
                    LoginView() 
                        .environmentObject(localizationManager)
                        .environmentObject(bleManager) // Przekazujemy BLEManager do środowiska
                        .environmentObject(webSocketManager)
                }
            }
        }
    }
}
