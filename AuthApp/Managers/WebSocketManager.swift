import Foundation

class WebSocketManager: ObservableObject {
    private var webSocketTask: URLSessionWebSocketTask?

    func connect(withUserId userId: String, sessionId: String) {
        // Tworzenie URL na podstawie userId
        guard let url = URL(string: "ws://192.168.1.20:8000/socket/connect/\(userId)") else {
            print("Invalid WebSocket URL")
            return
        }

        // Używamy URL i przekazujemy subprotocoly
        webSocketTask = URLSession.shared.webSocketTask(with: url, protocols: ["session-id.\(sessionId)"])
        webSocketTask?.resume()

        print("WebSocket connected to: \(url) with session-id: \(sessionId)")
        receiveMessages()
    }

    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        webSocketTask = nil
        print("WebSocket disconnected.")
    }

    private func receiveMessages() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                print("WebSocket error: \(error)")
            case .success(.string(let message)):
                print("Received message: \(message)")
            case .success:
                break
            }
            // Ponownie wywołujemy receiveMessages(), aby utrzymać nasłuchiwanie
            self?.receiveMessages()
        }
    }
}


