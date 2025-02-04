import SwiftUI
import Charts

struct HeartrateGraph: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var webSocketManager: WebSocketManager
    @EnvironmentObject var languageManager: LocalizationManager
    
    // Dane do wykresu
    @State private var graphData: [HeartratePoint] = []
    
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
            
            // Główny content (nagłówek + wykres)
            contentView
            
            // Przycisk "cofnij" (lewy górny róg)
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
    
    // MARK: - Główny kontener na nagłówek i wykres
    private var contentView: some View {
        VStack(spacing: 29) {
            headerView
            chartContainerView
        }
        .padding(.top, 40)
    }
    
    // MARK: - Nagłówek (tytuł, data i przycisk lupy)
    private var headerView: some View {
        ZStack {
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
            
            // Przycisk lupy w prawym górnym rogu nagłówka
            zoomToggleButton
                .padding(.leading, 270)
        }
    }
    
    // MARK: - Kontener na wykres (z białym tłem)
    private var chartContainerView: some View {
        VStack(spacing: 29) {
            
            // Napis "Heartrate Graph" (lub inny)
            ZStack {
                VStack {
                    Text(languageManager.localizedString(forKey: "heartrate_graph"))
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
            
            // Właściwy wykres w zależności od trybu
            ZStack {
                if isZoomedIn {
                    scrollableZoomChart
                } else {
                    nonZoomChart
                }
            }
            .frame(width: 325, height: 460)
            .background(.white)
            .cornerRadius(20)
            .shadow(radius: 10)
        }
    }

    
    // MARK: - Przycisk lupy (przełączanie zoomu)
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
                        y: .value("BPM", point.bpm)
                    )
                    .foregroundStyle(.red)
                }
                
                // 2) Kropki i etykiety TYLKO dla wybranych punktów (np. co 10s)
                //    (zakładamy, że czas jest Double, więc bierzemy Int(point.time))
                ForEach(filteredData, id: \.time) { point in
                    PointMark(
                        x: .value("Time (s)", point.time),
                        y: .value("BPM", point.bpm)
                    )
                    .foregroundStyle(.red)
                    .symbolSize(24)
                    .annotation(position: .top) {
                        // Przykładowe formatowanie BPM z jedną cyfrą po przecinku:
                        Text(String(format: "%.1f", Double(point.bpm)))
                            .font(.caption)
                            .foregroundColor(.black)
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
                Text(languageManager.localizedString(forKey: "bpm_graph"))
                    .rotationEffect(.degrees(-180))
                    .foregroundStyle(darkGrayColor)
            }
            .chartXAxis {
                // Jednostka kroku co 5 (lub dopasuj do woli)
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
                // Możesz zmienić krok np. co 10 BPM
                AxisMarks(position: .leading, values: .stride(by: 10)) { value in
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
                        scale = max(1.0, min(maxScale, scale * delta))
                    }
                    .onEnded { _ in
                        lastScaleValue = 1.0
                    }
            )
        }
    }
    
    private var filteredData: [HeartratePoint] {
        // 1) Najpierw zaokrąglamy time do najbliższej liczby całkowitej
        //    (np. 9.9999 → 10.0, 10.0001 → 10.0)
        let rounded = graphData.map { oldPoint -> HeartratePoint in
            let newTime = round(oldPoint.time)
            return HeartratePoint(time: newTime, bpm: oldPoint.bpm)
        }
        
        // 2) Filtrowanie co 10 sekund
        //    (tylko te punkty, które po zaokrągleniu dają (time % 10 == 0))
        let everyTen = rounded.filter { Int($0.time) % 10 == 0 }
        
        // 3) Usuwanie duplikatów po tym samym time (jeśli wciąż zdarzą się punkty o tym samym time).
        //    Jeśli trafimy na identyczny time, to np. ostatni nadpisze poprzedniego
        //    (możesz tu wybrać inny wariant, np. pierwszy).
        var uniqueDict: [Double: HeartratePoint] = [:]
        for p in everyTen {
            uniqueDict[p.time] = p
        }
        
        // 4) Zwracamy posortowane rosnąco po czasie
        let result = uniqueDict.values.sorted { $0.time < $1.time }
        return result
    }
    
    // MARK: - Wykres bez zoomu
    private var nonZoomChart: some View {
        let darkGrayColor = Color(red: 0.5, green: 0.5, blue: 0.5)
        
        return Chart(graphData) { point in
            LineMark(
                x: .value("Time (s)", point.time),
                y: .value("BPM", point.bpm)
            )
            .foregroundStyle(.red)
        }
        .frame(width: 300, height: 350)
        .chartXAxisLabel(alignment: .center) {
            Text(languageManager.localizedString(forKey: "time_graph"))
                .foregroundStyle(darkGrayColor)
        }
        .chartYAxisLabel(position: .leading, alignment: .center) {
            Text(languageManager.localizedString(forKey: "bpm_graph"))
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
            AxisMarks(position: .leading, values: .stride(by: 10)) { value in
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
        
        let urlString = "http://192.168.1.22:8000/sensors/get_graph?user_id=\(userId)&date=\(convertedDate)&graph_type=heartrate"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.setValue(sessionId, forHTTPHeaderField: "session-id")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Data download error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            do {
                let response = try JSONDecoder().decode(HeartrateResponse.self, from: data)
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

func convertDateToISO8601(from dateString: String) -> String {
    let formatter = DateFormatter()
    // Poprawiony format daty zgodny z Twoim przykładem
    formatter.dateFormat = "EEE MMM dd yyyy HH:mm:ss 'GMT'Z '('zzzz')'"
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    
    if let date = formatter.date(from: dateString) {
        let isoFormatter = ISO8601DateFormatter()
        // Usuń opcję .withFractionalSeconds, aby zapisać tylko sekundy
        isoFormatter.formatOptions = [.withInternetDateTime]
        isoFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return isoFormatter.string(from: date)
    } else {
        print("Failed to convert date: \(dateString)")
        return ""
    }
}

// MARK: - Struktury danych
struct HeartratePoint: Identifiable, Codable {
    let id = UUID()
    let time: Double // Czas w sekundach
    let bpm: Float   // Uderzenia serca na minutę
    
    private enum CodingKeys: String, CodingKey {
        case time, bpm
    }
}

struct HeartrateResponse: Codable {
    let graph_data: [HeartratePoint]
}

// MARK: - Podgląd
struct HeartrateGraph_Previews: PreviewProvider {
    static var previews: some View {
        return HeartrateGraph(
            trainingType: "Running",
            trainingDate: "FRI, 09/12/2026",
            dateForQuery: "random"
        )
    }
}

