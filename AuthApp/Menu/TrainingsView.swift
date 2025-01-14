import SwiftUI

struct TrainingsView: View {
    @Environment(\.presentationMode) var presentationMode // Obsługa cofania
    @EnvironmentObject var webSocketManager: WebSocketManager // Obsługa WebSocket
    @EnvironmentObject var languageManager: LocalizationManager // Obsługa lokalizacji
    
    @State private var workouts: [(type: String, date: String)] = []
    @State private var currentPage: Int = 1
    @State private var limitPerPage: Int = 10
    @State private var isLastPage: Bool = false
    
    @State private var selectedWorkout: (type: String, date: String)? = nil
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
                SingleTraining()
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
        VStack(spacing: 20) {
            Text("Trainings")
                .font(
                    Font.custom("Roboto Mono", size: 36)
                        .weight(.bold)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                .frame(width: 251, height: 107, alignment: .center)

            VStack(alignment: .leading, spacing: 10) {
                ForEach(workouts.indices, id: \ .self) { index in
                    Button(action: {
                        handleWorkoutTap(index: index)
                    }) {
                        VStack(alignment: .leading) {
                            Text(workouts[index].type)
                                .font(.headline)
                                .foregroundColor(.black)
                            Text(workouts[index].date)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
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
                .foregroundColor(Color.black)

                Spacer()

                Button("Next") {
                    currentPage += 1
                    fetchWorkoutData()
                }
                .disabled(isLastPage)
                .foregroundColor(Color.black)
            }
            .padding()
        }
        .frame(width: 300)
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

                    let parsedWorkouts = workoutsArray.compactMap { workout -> (type: String, date: String)? in
                        guard let type = workout["workoutType"] as? String,
                              let date = workout["date"] as? String else {
                            return nil
                        }
                        return (type, date)
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
}

struct TrainingsView_Previews: PreviewProvider {
    static var previews: some View {
        TrainingsView()
    }
}
