import SwiftUI
import Charts

struct HeartrateGraph: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var webSocketManager: WebSocketManager
    @EnvironmentObject var languageManager: LocalizationManager
    
    @State private var graphData: [HeartratePoint] = [] // Dane do grafu BPM
    @State private var scale: CGFloat = 1.0 // Zmienna przechowująca poziom powiększenia
    @State private var lastScaleValue: CGFloat = 1.0 // Ostatnia wartość gestu
    let maxScale: CGFloat = 3.0 // Zmienna do określenia maksymalnego powiększenia
    
    // Dodane zmienne
    var trainingType: String // Typ treningu
    var trainingDate: String // Data treningu
    var dateForQuery: String // Data treningu
    
    
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
        ZStack{
            // Gradientowe tło
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
            VStack (spacing: 12){
                Text(trainingType)
                    .font(
                        Font.custom("Roboto Mono", size: 30)
                            .weight(.bold)
                    )
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .frame(width: 320, height: 35, alignment: .leading)
                    .shadow(radius: 10)
                    .padding(.trailing, 10)
                
                HStack{
                    Image("Calendar")
                      .resizable()
                      .scaledToFit()
                      .frame(width: 20, height: 20)
                    
                    Text(trainingDate)
                      .font(
                        Font.custom("Roboto Mono", size: 18)
                          .weight(.bold)
                      )
                      .multilineTextAlignment(.center)
                      .foregroundColor(.white)
                      .frame(width: 300, height: 20, alignment: .leading)
                }
                .shadow(radius: 10)
            }
            .frame(width: 320, height: 65)
            .padding(.leading, 15)
            .shadow(radius: 10)
            
            ZStack {
                Text("Heartrate\nGraph")
                    .font(Font.custom("Roboto Mono", size: 28).weight(.bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                    .frame(alignment: .center)
                    .padding(.bottom, 450)
                
                
                // Powiększany wykres
                ScrollView(.horizontal) {
                    Chart(graphData) { point in
                        LineMark(
                            x: .value("Time", point.time),
                            y: .value("BPM", point.bpm)
                        )
                        .foregroundStyle(Color.red) // Kolor linii
                    }
                    .frame(width: 1000 * scale, height: 250 * scale) // Skala dynamiczna
                    .gesture(
                        MagnificationGesture()
                            .onChanged { value in
                                // Oblicz nowy poziom powiększenia
                                let delta = value / lastScaleValue
                                lastScaleValue = value
                                scale = max(1.0, min(maxScale, scale * delta)) // Ustaw limit minimalnej i maksymalnej skali
                            }
                            .onEnded { _ in
                                // Zresetuj lastScaleValue po zakończeniu gestu
                                lastScaleValue = 1.0
                            }
                    )
                }
                .padding(.trailing, 30)
                .padding(.leading, 30)
                
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
        
        // Konwertuj `dateForQuery` na format ISO 8601
        let convertedDate = convertDateToISO8601(from: dateForQuery)
        
        guard !convertedDate.isEmpty else {
            print("Nie udało się przekonwertować daty.")
            return
        }
        
        let urlString = "http://192.168.1.20:8000/sensors/get_graph?user_id=\(userId)&date=\(convertedDate)&graph_type=heartrate"
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
                let response = try JSONDecoder().decode(HeartrateResponse.self, from: data)
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

func convertDateToISO8601(from dateString: String) -> String {
    let formatter = DateFormatter()
    // Poprawiony format daty zgodny z Twoim przykładem
    formatter.dateFormat = "EEE MMM dd yyyy HH:mm:ss 'GMT'Z '('zzzz')'"
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    
    if let date = formatter.date(from: dateString) {
        let isoFormatter = ISO8601DateFormatter()
        // Usuń opcję `.withFractionalSeconds`, aby zapisać tylko sekundy
        isoFormatter.formatOptions = [.withInternetDateTime]
        isoFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return isoFormatter.string(from: date)
    } else {
        print("Nie udało się sparsować daty: \(dateString)")
        return ""
    }
}



// Struktury danych dla heartrate
struct HeartratePoint: Identifiable, Codable {
    let id = UUID() // Lokalnie generowane ID
    let time: Double // Czas w sekundach
    let bpm: Float   // Bity na minutę (BPM)
    
    private enum CodingKeys: String, CodingKey {
        case time, bpm
    }
}

struct HeartrateResponse: Codable {
    let graph_data: [HeartratePoint]
}

struct HeartrateGraph_Previews: PreviewProvider {
    static var previews: some View {
        HeartrateGraph(trainingType: "Running", trainingDate: "FRI, 09/12/2026", dateForQuery: "random")
    }
}
