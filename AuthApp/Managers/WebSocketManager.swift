import Foundation

class WebSocketManager: ObservableObject {
    private var webSocketTask: URLSessionWebSocketTask?
    @Published var showTrainingAlert = false

    func connect(withUserId userId: String, sessionId: String) {
        guard let url = URL(string: "ws://192.168.1.20:8000/socket/connect/\(userId)") else {
            print("Invalid WebSocket URL")
            return
        }

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
                self?.handleMessage(message)
            case .success:
                break
            }
            self?.receiveMessages()
        }
    }

    private func handleMessage(_ message: String) {
        if message.contains("Training") && message.contains("processed sucessfully") {
            DispatchQueue.main.async {
                self.showTrainingAlert = true
            }
        }
    }
}
