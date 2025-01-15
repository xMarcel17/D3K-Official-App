import SwiftUI

struct TrainingsView: View {
    @Environment(\.presentationMode) var presentationMode // Obsługa cofania
    @EnvironmentObject var webSocketManager: WebSocketManager // Obsługa WebSocket
    @EnvironmentObject var languageManager: LocalizationManager // Obsługa lokalizacji
    
    @State private var workouts: [(id: Int, type: String, duration: Int, distance: Double, caloriesBurned: Double, avgSteps: Int, avgHeartrate: Double, date: String)] = []
    @State private var currentPage: Int = 1
    @State private var limitPerPage: Int = 10
    @State private var isLastPage: Bool = false
    
    @State private var selectedWorkout: (id: Int, type: String, duration: Int, distance: Double, caloriesBurned: Double, avgSteps: Int, avgHeartrate: Double, date: String)? = nil
    
    @State private var isShowingSingleTraining: Bool = false
    
    var body: some View {
        ZStack{
            backgroundView

            contentView
            
            // Custom back button in the top-left corner
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss() // Cofanie do poprzedniego widoku
                }) {
                    Image("DoubleLeftBlue")
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
        .onAppear {
            fetchWorkoutData()
        }
        .fullScreenCover(isPresented: $isShowingSingleTraining) {
            SingleTraining(workout: selectedWorkout ?? defaultWorkout)
                    .environmentObject(webSocketManager)
                    .environmentObject(languageManager)
        }
    }
    
    var backgroundView: some View {
        ZStack{
            Color.white
                .ignoresSafeArea()
            
            Image("RunningMan2")
                .resizable()
                .scaledToFit()
                .frame(width: 600, height: 600)
                .opacity(0.37)
                .offset(x: -35)
        }
    }
    
    var contentView: some View {
        ZStack{
            Text("Trainings")
                .font(
                    Font.custom("Roboto Mono", size: 36)
                        .weight(.bold)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                .frame(width: 251, height: 107, alignment: .center)
            
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(workouts.indices, id: \ .self) { index in
                        Button(action: {
                            handleWorkoutTap(index: index)
                        }) {
                            HStack{
                                Text(workouts[index].type)
                                    .font(
                                        Font.custom("Roboto Mono", size: 16)
                                            .weight(.regular)
                                    )
                                    .frame(width: 170, alignment: .leading)
                                    .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                                Text(formatDate(workouts[index].date))
                                    .font(
                                        Font.custom("Roboto Mono", size: 16)
                                            .weight(.regular)
                                    )
                                    .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                            }
                            .padding(.leading, 10)
                        }
                        Rectangle()
                            .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                            .frame(width: 301, height: 1)
                    }
                }
                
                HStack {
                    Button("Previous") {
                        if currentPage > 1 {
                            currentPage -= 1
                            fetchWorkoutData()
                        }
                    }
                    .disabled(currentPage == 1)
                    .font(
                        Font.custom("Roboto Mono", size: 18)
                            .weight(.bold)
                    )
                    .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                    .disabled(currentPage == 1)
                    
                    Spacer()
                    
                    Button("Next") {
                        currentPage += 1
                        fetchWorkoutData()
                    }
                    .disabled(isLastPage)
                    .font(
                        Font.custom("Roboto Mono", size: 18)
                            .weight(.bold)
                    )
                    .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                }
                .padding()
            }
            .frame(width: 300)
        }
    }
    
    func fetchWorkoutData() {
        guard let userId = UserDefaults.standard.string(forKey: "user_id"),
              let sessionId = UserDefaults.standard.string(forKey: "session_id"),
              let url = URL(string: "http://192.168.1.20:8000/health/workouts?userId=\(userId)&page=\(currentPage)&limit=\(limitPerPage)") else {
            print("Invalid URL or missing UserDefaults values")
            return
        }

        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(sessionId, forHTTPHeaderField: "session-id")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching workouts: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let workoutsArray = json["workouts"] as? [[String: Any]] {

                    let parsedWorkouts = workoutsArray.compactMap { workout -> (id: Int, type: String, duration: Int, distance: Double, caloriesBurned: Double, avgSteps: Int, avgHeartrate: Double, date: String)? in
                        guard let id = workout["id"] as? Int,
                              let type = workout["workoutType"] as? String,
                              let duration = workout["duration"] as? Int,
                              let distance = workout["distance"] as? Double,
                              let caloriesBurned = workout["caloriesBurned"] as? Double,
                              let avgSteps = workout["avgSteps"] as? Int,
                              let avgHeartrate = workout["avgHeartrate"] as? Double,
                              let date = workout["date"] as? String else {
                            return nil
                        }
                        return (id, type, duration, distance, caloriesBurned, avgSteps, avgHeartrate, date)
                    }

                    DispatchQueue.main.async {
                        workouts = parsedWorkouts
                        isLastPage = workoutsArray.count < limitPerPage
                    }
                }
            } catch {
                print("Failed to parse JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func handleWorkoutTap(index: Int) {
        selectedWorkout = workouts[index]
        isShowingSingleTraining = true
        print("Workout tapped: \(workouts[index])")
    }
    
    func formatDate(_ date: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "en_US_POSIX") // Ustawienie odpowiedniej lokalizacji
        inputFormatter.dateFormat = "EEE MMM dd yyyy HH:mm:ss 'GMT'Z (zzzz)" // Format wejściowy odpowiadający danym z serwera
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd/MM/yyyy" // Format wyjściowy
        
        if let dateObject = inputFormatter.date(from: date) {
            return outputFormatter.string(from: dateObject)
        }
        return date // Zwraca oryginalną datę, jeśli konwersja się nie powiedzie
    }


    
    private var defaultWorkout: (id: Int, type: String, duration: Int, distance: Double, caloriesBurned: Double, avgSteps: Int, avgHeartrate: Double, date: String) {
        return (id: 0, type: "Unknown", duration: 0, distance: 0.0, caloriesBurned: 0.0, avgSteps: 0, avgHeartrate: 0.0, date: "Unknown")
    }
}

struct TrainingsView_Previews: PreviewProvider {
    static var previews: some View {
        TrainingsView()
    }
}
