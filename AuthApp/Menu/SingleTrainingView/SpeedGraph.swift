import SwiftUI
import Charts

struct SpeedGraph: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var webSocketManager: WebSocketManager
    @EnvironmentObject var languageManager: LocalizationManager
    
    @State private var graphData: [SpeedPoint] = [] // Dane do grafu
    
    var body: some View {
        ZStack {
            backgroundView
            
            contentView
            
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
        .onAppear {
            fetchGraphData()
        }
    }
    
    var backgroundView: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.75, green: 0.73, blue: 0.87),
                    Color(red: 0.5, green: 0.63, blue: 0.83)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            Rectangle()
                .foregroundStyle(Color.clear)
                .frame(width: 600, height: 600)
        }
    }
    
    var contentView: some View {
        VStack(spacing: 29) {
            VStack(spacing: 12) {
                Text("Training")
                    .font(Font.custom("Roboto Mono", size: 36).weight(.bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .frame(width: 219, height: 35, alignment: .center)
                    .shadow(radius: 10)
                
                HStack {
                    Image("Calendar")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                    
                    Text("MON, 09/12/2024")
                        .font(Font.custom("Roboto Mono", size: 18).weight(.bold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .frame(width: 177, height: 20, alignment: .center)
                }
                .shadow(radius: 10)
            }
            .frame(width: 219, height: 65)
            .padding(.trailing, 110)
            .shadow(radius: 10)
            
            ZStack {
                VStack {
                    Text("Speed Graph")
                        .font(Font.custom("Roboto Mono", size: 28).weight(.bold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                        .frame(width: 251, height: 107, alignment: .center)
                    
                    // Wyświetlenie grafu
                    Chart(graphData) { point in
                        LineMark(
                            x: .value("Time", point.time),
                            y: .value("Speed", point.speed)
                        )
                        .foregroundStyle(Color.blue) // Kolor linii
                        
//                        PointMark(
//                            x: .value("Time", point.time),
//                            y: .value("Speed", point.speed)
//                        )
//                        .foregroundStyle(Color.green) // Kolor punktów
                    }
                    .frame(height: 300)
                }
            }
            .frame(width: 325, height: 582)
            .background(.white)
            .cornerRadius(20)
            .shadow(radius: 10)
        }
        .padding(.top, 40)
    }
    
    func fetchGraphData() {
        guard let userId = UserDefaults.standard.string(forKey: "user_id"),
              let sessionId = UserDefaults.standard.string(forKey: "session_id") else {
            print("Nie znaleziono user_id lub session_id w UserDefaults")
            return
        }
        
        let urlString = "http://192.168.1.20:8000/sensors/get_graph?user_id=\(userId)&date=2025-12-01T12:34:56Z&graph_type=speed"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.setValue(sessionId, forHTTPHeaderField: "session-id")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Błąd pobierania danych: \(error?.localizedDescription ?? "Nieznany błąd")")
                return
            }
            
            do {
                // Dekoduj dane JSON
                let response = try JSONDecoder().decode(GraphResponse.self, from: data)
                DispatchQueue.main.async {
                    self.graphData = response.graph_data
                }
            } catch {
                // Debuguj dane JSON, jeśli wystąpi błąd
                print("Błąd dekodowania JSON: \(error.localizedDescription)")
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Otrzymany JSON: \(jsonString)")
                }
            }
        }.resume()
    }

}

// Struktury danych
struct SpeedPoint: Identifiable, Codable {
    let id = UUID() // Lokalnie generowane ID
    let time: Int
    let speed: Double
    
    private enum CodingKeys: String, CodingKey {
        case time, speed
    }
}

struct GraphResponse: Codable {
    let graph_data: [SpeedPoint]
}

struct SpeedGraph_Previews: PreviewProvider {
    static var previews: some View {
        SpeedGraph()
    }
}
