import SwiftUI

struct SingleTraining: View {
    let workout: (id: Int, type: String, duration: Int, distance: Double, caloriesBurned: Double, avgSteps: Int, avgHeartrate: Double, date: String)
    
    @Environment(\.presentationMode) var presentationMode // Obsługa cofania
    @EnvironmentObject var webSocketManager: WebSocketManager // Obsługa WebSocket
    @EnvironmentObject var languageManager: LocalizationManager // Obsługa lokalizacji
    
    @State private var showSpeedGraph = false
    @State private var showHeartrateGraph = false
    
    @AppStorage("appTheme") private var currentTheme: String = "Theme1"
    
    var body: some View {
        ZStack{
            backgroundView

            contentView
            
            // Custom back button in the top-left corner
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss() // Cofanie do poprzedniego widoku
                }) {
                    Image("DoubleLeftWhite")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 230, height: 40)
                        .shadow(radius: 10)
                }
                Spacer() // Push content to the right
            }
            .padding(.horizontal)
            .padding(20) // Adjust padding as needed
            .padding(.top, -400) // Adjust padding as needed
        }
    }
    
    var backgroundView: some View {
        ZStack{
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
    
    var contentView: some View {
        VStack (spacing: 29){
            VStack (spacing: 12){
                Text(workout.type)
                    .font(
                        Font.custom("Roboto Mono", size: 27)
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
                    
                    Text(formatDate(workout.date))
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
            
            VStack(spacing: 29){
                Button(action: {
                    showSpeedGraph = true
                }) {
                    ZStack{
                        Image("RunningManTraining")
                          .resizable()
                          .scaledToFit()
                          .frame(width: 186, height: 124)
                          .padding(.leading, 80)

                        
                        Text(languageManager.localizedString(forKey: "speed_graph"))
                            .font(
                                Font.custom("Roboto Mono", size: 24)
                                    .weight(.bold)
                            )
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                            .frame(width: 159, height: 18, alignment: .center)
                            .padding(.bottom, 45)
                            .padding(.trailing, 130)
                        
                        Image("SingleRightBlue")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .padding(.top, 50)
                            .padding(.leading, 275)
                    }
                    .frame(width: 325, height: 100)
                    .background(.white)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                }

                
                Button(action: {
                    showHeartrateGraph = true
                }) {
                    ZStack{
                        Image("HeartrateTraining")
                          .resizable()
                          .scaledToFit()
                          .frame(width: 325, height: 100)
                          .opacity(0.35)
                          
                        Text(languageManager.localizedString(forKey: "heartrate_graph"))
                            .font(
                                Font.custom("Roboto Mono", size: 24)
                                    .weight(.bold)
                            )
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                            .frame(width: 217, height: 18, alignment: .center)
                            .padding(.bottom, 45)
                            .padding(.trailing, 75)
                        
                        Image("SingleRightBlue")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .padding(.top, 50)
                            .padding(.leading, 275)
                    }
                    .frame(width: 325, height: 100)
                    .background(.white)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                }
                
                ZStack{
                    Image("TimeTraining")
                      .resizable()
                      .scaledToFit()
                      .frame(width: 82, height: 82)
                      .padding(.trailing, 40)
                    
                    HStack(spacing: 100){
                        Text(languageManager.localizedString(forKey: "time"))
                            .font(
                                Font.custom("Roboto Mono", size: 20)
                                    .weight(.bold)
                            )
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                            .frame(width: 76, height: 25, alignment: .center)
                        
                        Text(formatDuration(workout.duration))
                            .font(
                                Font.custom("Roboto Mono", size: 20)
                                .weight(.bold)
                            )
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))

                            .frame(width: 110, height: 25, alignment: .center)
                    }
                }
                .frame(width: 325, height: 57)
                .background(.white)
                .cornerRadius(15)
                .shadow(radius: 10)
                
                HStack(spacing: 29){
                    ZStack{
                        Image("FlameTraining")
                          .resizable()
                          .scaledToFit()
                          .frame(width: 90, height: 90)
                          .padding(.leading, 50)
                        
                        Text(languageManager.localizedString(forKey: "calories"))
                          .font(
                            Font.custom("Roboto Mono", size: 20)
                              .weight(.bold)
                          )
                          .multilineTextAlignment(.center)
                          .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                          .frame(width: 109, height: 25, alignment: .leading)
                          .padding(.bottom, 50)
                          .padding(.trailing, 10)
                        
                        HStack (spacing: 0){
                            Text("\(Int(workout.caloriesBurned))")
                                .font(
                                    Font.custom("Roboto Mono", size: 32)
                                        .weight(.bold)
                                )
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                            
                            Text("kcal")
                              .font(
                                Font.custom("Roboto Mono", size: 16)
                                  .weight(.bold)
                              )
                              .multilineTextAlignment(.center)
                              .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                              .padding(.top, 12)
                        }
                        .padding(.top, 30)
                    }
                    .frame(width: 148, height: 100)
                    .background(.white)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    
                    ZStack{
                        Image("DistanceTraining")
                          .resizable()
                          .scaledToFit()
                          .frame(width: 80, height: 80)
                          .padding(.leading, 50)
                        
                        Text(languageManager.localizedString(forKey: "distance"))
                            .font(
                                Font.custom("Roboto Mono", size: 20)
                                    .weight(.bold)
                            )
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                            .frame(width: 109, height: 25, alignment: .leading)
                            .padding(.bottom, 50)
                            .padding(.trailing, 10)
                        
                        HStack (spacing: 0){
                            Text(String(format: "%.2f", workout.distance))
                                .font(
                                    Font.custom("Roboto Mono", size: 32)
                                        .weight(.bold)
                                )
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                            
                            Text("m")
                              .font(
                                Font.custom("Roboto Mono", size: 16)
                                  .weight(.bold)
                              )
                              .multilineTextAlignment(.center)
                              .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                              .padding(.top, 12)
                        }
                        .padding(.top, 30)
                    }
                    .frame(width: 148, height: 100)
                    .background(.white)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                }
                .frame(width: 325, height: 100)
                
                HStack(spacing: 29){
                    ZStack{
                        Image("StepsTraining")
                          .resizable()
                          .scaledToFit()
                          .frame(width: 90, height: 90)
                          .padding(.leading, 40)
                          .padding(.bottom, 5)
                        
                        Text(languageManager.localizedString(forKey: "avg_steps"))
                          .font(
                            Font.custom("Roboto Mono", size: 20)
                              .weight(.bold)
                          )
                          .multilineTextAlignment(.center)
                          .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                          .frame(width: 121, height: 25, alignment: .leading)
                          .padding(.bottom, 50)
                        
                        Text("\(workout.avgSteps)")
                            .font(
                                Font.custom("Roboto Mono", size: 32)
                                    .weight(.bold)
                            )
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                            .padding(.top, 30)
                    }
                    .frame(width: 148, height: 100)
                    .background(.white)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    
                    ZStack{
                        Image("HeartTraining")
                          .resizable()
                          .scaledToFit()
                          .frame(width: 90, height: 90)
                          .padding(.leading, 35)
                        
                        Text(languageManager.localizedString(forKey: "avg_bpm"))
                            .font(
                                Font.custom("Roboto Mono", size: 20)
                                    .weight(.bold)
                            )
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                            .frame(width: 121, height: 25, alignment: .leading)
                            .padding(.bottom, 50)
                        
                        HStack (spacing: 0){
                            Text(String(format: "%.2f", workout.avgHeartrate))
                                .font(
                                    Font.custom("Roboto Mono", size: 32)
                                        .weight(.bold)
                                )
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                            
                            Text("bpm")
                              .font(
                                Font.custom("Roboto Mono", size: 16)
                                  .weight(.bold)
                              )
                              .multilineTextAlignment(.center)
                              .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                              .padding(.top, 12)
                        }
                        .padding(.top, 30)
                    }
                    .frame(width: 148, height: 100)
                    .background(.white)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                }
                .frame(width: 325, height: 100)

            }
        }
        .padding(.top, 40)
        .fullScreenCover(isPresented: $showSpeedGraph) {
            SpeedGraph(trainingType: workout.type, trainingDate: formatDate(workout.date), dateForQuery: workout.date)
        }
        .fullScreenCover(isPresented: $showHeartrateGraph) {
            HeartrateGraph(trainingType: workout.type, trainingDate: formatDate(workout.date), dateForQuery: workout.date)
        }
        
    }
    
    func formatDate(_ dateString: String) -> String {
        // Usuń część w nawiasach
        let cleanedDateString = dateString.components(separatedBy: " (").first ?? dateString
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX") // Ustaw odpowiednią lokalizację
        formatter.dateFormat = "EEE MMM dd yyyy HH:mm:ss ZZZZ"
        
        // Spróbuj sparsować datę
        if let date = formatter.date(from: cleanedDateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.locale = Locale(identifier: "en_US_POSIX") // Ustaw odpowiednią lokalizację
            outputFormatter.dateFormat = "EEE, dd/MM/yyyy"
            return outputFormatter.string(from: date).uppercased()
        } else {
            // Dodatkowa próba parsowania przy użyciu innego formatu
            formatter.dateFormat = "EEE MMM dd yyyy HH:mm:ss 'GMT'Z"
            if let date = formatter.date(from: cleanedDateString) {
                let outputFormatter = DateFormatter()
                outputFormatter.locale = Locale(identifier: "en_US_POSIX")
                outputFormatter.dateFormat = "EEE, dd/MM/yyyy"
                return outputFormatter.string(from: date).uppercased()
            }
        }
        
        return "Invalid Date" // Jeśli wszystko zawiedzie
    }

    func formatDuration(_ duration: Int) -> String {
        let hours = duration / 3600
        let minutes = (duration % 3600) / 60
        let seconds = duration % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
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

struct SingleTraining_Previews: PreviewProvider {
    static var previews: some View {
        SingleTraining(workout: (id: 1, type: "Running", duration: 3600, distance: 10.5, caloriesBurned: 500, avgSteps: 12000, avgHeartrate: 150, date: "2025-01-14"))
    }
}
