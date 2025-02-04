import SwiftUI
import Charts

struct SpeedGraph: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var webSocketManager: WebSocketManager
    @EnvironmentObject var languageManager: LocalizationManager
    
    // Dane do wykresu
    @State private var graphData: [SpeedPoint] = []
    
    // Zmienne do zoomu
    @State private var scale: CGFloat = 1.0
    @State private var lastScaleValue: CGFloat = 1.0
    let maxScale: CGFloat = 3.0
    
    // Parametry z zewnątrz
    var trainingType: String
    var trainingDate: String
    var dateForQuery: String
    
    // Sterowanie zoomowaniem wykresu
    @State private var isZoomedIn: Bool = false
    
    @AppStorage("appTheme") private var currentTheme: String = "Theme1"
    
    var body: some View {
        ZStack {
            // Tło
            backgroundView
            
            // Główny content
            contentView
            
            // Przycisk "cofnij"
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
    
    // MARK: - Widok tła
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
            
            Rectangle()
                .foregroundStyle(Color.clear)
                .frame(width: 600, height: 600)
        }

    }
    
    // MARK: - Główny kontener na nagłówek, wykres i przycisk lupy
    private var contentView: some View {
        VStack(spacing: 29) {
            headerView         // Nagłówek
            chartContainerView // Kontener z wykresem
        }
        .padding(.top, 40)
    }
    
    // MARK: - Nagłówek z tytułem i datą treningu
    private var headerView: some View {
        ZStack{
            VStack(spacing: 12) {
                Text(trainingType)
                    .font(
                        Font.custom("Roboto Mono", size: 27)
                            .weight(.bold)
                    )
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .frame(width: 320, height: 35, alignment: .leading)
                    .shadow(radius: 10)
                    .padding(.trailing, 10)
                
                HStack {
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
            
            zoomToggleButton
                .padding(.leading, 270)
        }
    }
    
    // MARK: - Kontener na wykres (z białym tłem)
    private var chartContainerView: some View {
        VStack(spacing: 29){
            ZStack{
                VStack{
                    Text(languageManager.localizedString(forKey: "speed_graph"))
                        .font(Font.custom("Roboto Mono", size: 28).weight(.bold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                        .frame(alignment: .center)
                    
                    Text(languageManager.localizedString(forKey: "graph_info"))
                        .font(Font.custom("Roboto Mono", size: 12).weight(.bold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                        .frame(alignment: .center)
                }
            }
            .frame(width: 325, height: 93)
            .background(.white)
            .cornerRadius(20)
            .shadow(radius: 10)
            
            ZStack {
                if isZoomedIn {
                    // W trybie zoomu: przewijalny wykres z kropkami i etykietkami
                    scrollableZoomChart
                } else {
                    // Bez zoomu: tylko linia, bez kropek
                    nonZoomChart
                }
            }
            .frame(width: 325, height: 460)
            .frame(width: 325, height: 460)
            .background(.white)
            .cornerRadius(20)
            .shadow(radius: 10)
        }
    }
    
    // MARK: - Przycisk lupy
    private var zoomToggleButton: some View {
        Button {
            isZoomedIn.toggle()
        } label: {
            Image(systemName: isZoomedIn ? "minus.magnifyingglass" : "plus.magnifyingglass")
                .font(.title)
                .foregroundColor(.white)
                .padding()
                .shadow(radius: 10)
        }
    }
    
    // MARK: - Wykres w trybie ZOOM + Scroll
    private var scrollableZoomChart: some View {
        let darkGrayColor = Color(red: 0.5, green: 0.5, blue: 0.5)
        
        return ScrollView(.horizontal) {
            Chart {
                // 1) Linia dla wszystkich punktów
                ForEach(graphData) { point in
                    LineMark(
                        x: .value("Time (s)", point.time),
                        y: .value("Speed (m/s)", point.speed)
                    )
                    .foregroundStyle(.red)
                }
                
                // 2) Kropki i etykiety TYLKO dla wybranych punktów (co 10 sekund)
                ForEach(graphData.filter { $0.time % 10 == 0 }, id: \.time) { point in
                    PointMark(
                        x: .value("Time (s)", point.time),
                        y: .value("Time (m/s)", point.speed)
                    )
                    .foregroundStyle(.red)
                    .symbolSize(24)  // Większe kropki
                    
                    // Adnotacja z małym tekstem obok kropki
                    .annotation(position: .top) {
                        Text(String(format: "%.2f", point.speed))
                            .font(.caption)          // Nieco większa czcionka
                            .foregroundColor(.black) // Kolor czarny
                    }
                }
            }
            // Rozmiar wykresu zależny od skali
            .frame(width: 1000 * scale, height: 350 * scale)
            .chartXAxisLabel(alignment: .center) {
                Text(languageManager.localizedString(forKey: "time_graph"))
                    .foregroundStyle(darkGrayColor)
            }
            .chartYAxisLabel(position: .leading, alignment: .center) {
                Text(languageManager.localizedString(forKey: "speedms_graph"))
                    .rotationEffect(.degrees(-180))
                    .foregroundStyle(darkGrayColor)
            }
            .chartXAxis {
                AxisMarks(position: .bottom, values: .stride(by: 5)) { value in
                    AxisValueLabel()
                        .foregroundStyle(darkGrayColor)
                    AxisGridLine()
                        .foregroundStyle(darkGrayColor)
                    AxisTick()
                        .foregroundStyle(darkGrayColor)
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading, values: .stride(by: 0.5)) { value in
                    AxisValueLabel()
                        .foregroundStyle(darkGrayColor)
                    AxisGridLine()
                        .foregroundStyle(darkGrayColor)
                    AxisTick()
                        .foregroundStyle(darkGrayColor)
                }
            }
            // Gest powiększania
            .gesture(
                MagnificationGesture()
                    .onChanged { value in
                        let delta = value / lastScaleValue
                        lastScaleValue = value
                        scale = max(1.0, min(3.0, scale * delta))
                    }
                    .onEnded { _ in
                        lastScaleValue = 1.0
                    }
            )
        }
    }
    
    // MARK: - Wykres bez zoomu
    private var nonZoomChart: some View {
        let darkGrayColor = Color(red: 0.5, green: 0.5, blue: 0.5)
        
        return Chart(graphData) { point in
            LineMark(
                x: .value("Time (s)", point.time),
                y: .value("Speed (m/s)", point.speed)
            )
            .foregroundStyle(.red)
        }
        .frame(width: 300, height: 350)
        .chartXAxisLabel(alignment: .center) {
            Text(languageManager.localizedString(forKey: "time_graph"))
                .foregroundStyle(darkGrayColor)
        }
        .chartYAxisLabel(position: .leading, alignment: .center) {
            Text(languageManager.localizedString(forKey: "speedms_graph"))
                .rotationEffect(.degrees(-180))
                .foregroundStyle(darkGrayColor)
        }
        .chartXAxis {
            AxisMarks(position: .bottom, values: .stride(by: 50)) { value in
                AxisValueLabel()
                    .foregroundStyle(darkGrayColor)
                AxisGridLine()
                    .foregroundStyle(darkGrayColor)
                AxisTick()
                    .foregroundStyle(darkGrayColor)
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading, values: .stride(by: 1)) { value in
                AxisValueLabel()
                    .foregroundStyle(darkGrayColor)
                AxisGridLine()
                    .foregroundStyle(darkGrayColor)
                AxisTick()
                    .foregroundStyle(darkGrayColor)
            }
        }
    }
    
    // MARK: - Pobieranie danych JSON
    func fetchGraphData() {
        guard let userId = UserDefaults.standard.string(forKey: "user_id"),
              let sessionId = UserDefaults.standard.string(forKey: "session_id") else {
            print("user_id or session_id not found in UserDefaults")
            return
        }
        
        let convertedDate = convertDateToISO8601(from: dateForQuery)
        guard !convertedDate.isEmpty else {
            print("Failed to convert date.")
            return
        }
        
        let urlString = "http://192.168.1.22:8000/sensors/get_graph?user_id=\(userId)&date=\(convertedDate)&graph_type=speed"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.setValue(sessionId, forHTTPHeaderField: "session-id")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Data download error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            do {
                let response = try JSONDecoder().decode(GraphResponse.self, from: data)
                DispatchQueue.main.async {
                    self.graphData = response.graph_data
                }
            } catch {
                print("JSON decoding error: \(error.localizedDescription)")
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Received JSON: \(jsonString)")
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

// MARK: - Struktury danych
struct SpeedPoint: Identifiable, Codable {
    let id = UUID()
    let time: Int
    let speed: Double
    
    private enum CodingKeys: String, CodingKey {
        case time, speed
    }
}

struct GraphResponse: Codable {
    let graph_data: [SpeedPoint]
}

// MARK: - Podgląd w trybie Preview
struct SpeedGraph_Previews: PreviewProvider {
    static var previews: some View {
        return SpeedGraph(
            trainingType: "Running",
            trainingDate: "FRI, 09/12/2026",
            dateForQuery: "random"
        )
    }
}
