import SwiftUI

struct BMIOutcome: View {
    @Environment(\.presentationMode) var presentationMode // Obsługa cofania
    @EnvironmentObject var webSocketManager: WebSocketManager // Obsługa WebSocket
    @EnvironmentObject var languageManager: LocalizationManager // Obsługa lokalizacji
    
    var bmi: Float // Zmienna do przechowywania przekazanej wartości
    var status: String // Zmienna do przechowywania przekazanej wartości
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text(languageManager.localizedString(forKey: "bmioutcome"))
              .font(
                Font.custom("Roboto Mono", size: 24)
                  .weight(.bold)
              )
              .multilineTextAlignment(.center)
              .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
              .frame(width: 227, height: 25, alignment: .center)
            

            Text(String(format: "%.2f", bmi))
              .font(
                Font.custom("Roboto Mono", size: 78)
                  .weight(.bold)
              )
              .multilineTextAlignment(.center)
              .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
              .frame(width: 237, height: 71, alignment: .center)
            
            
            HStack{
                Text("Status:")
                  .font(
                    Font.custom("Roboto Mono", size: 18)
                      .weight(.bold)
                  )
                  .multilineTextAlignment(.center)
                  .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                
                Text(status)
                    .font(
                      Font.custom("Roboto Mono", size: 18)
                        .weight(.bold)
                    )
                    .multilineTextAlignment(.center)
                    .foregroundColor(colorForStatus(status: status)) // Dynamiczny kolor
                
            }
            .frame(width: 215, height: 44, alignment: .center)
            
            Button(action: {
                presentationMode.wrappedValue.dismiss() // Cofanie do poprzedniego widoku
            }) {
                ZStack{
                    Rectangle()
                      .foregroundColor(.clear)
                      .frame(width: 149, height: 43)
                      .background(
                        LinearGradient(
                          stops: [
                            Gradient.Stop(color: Color(red: 0.5, green: 0.63, blue: 0.83), location: 0.00),
                            Gradient.Stop(color: Color(red: 0.46, green: 0.79, blue: 0.78), location: 1.00),
                          ],
                          startPoint: UnitPoint(x: 0, y: 0.5),
                          endPoint: UnitPoint(x: 1, y: 0.5)
                        )
                      )
                      .cornerRadius(100)
                    
                    Text("OK")
                      .font(
                        Font.custom("Roboto Mono", size: 20)
                          .weight(.bold)
                      )
                      .multilineTextAlignment(.center)
                      .foregroundColor(.white)
                      .frame(width: 31, height: 22, alignment: .center)
                    
                }
                .cornerRadius(100.0)
                .shadow(radius: 5)
            }
        }
        .background(Color(red: 1, green: 1, blue: 1))
        .padding()
    }
    
    // Funkcja zwracająca odpowiedni kolor dla statusu BMI
    func colorForStatus(status: String) -> Color {
        switch status {
        case languageManager.localizedString(forKey: "normal"):
            return Color.green
        case languageManager.localizedString(forKey: "overweight"):
            return Color.orange
        case languageManager.localizedString(forKey: "obesity"):
            return Color.red
        case languageManager.localizedString(forKey: "underweight"):
            return Color.blue.opacity(0.7) // Jasny niebieski
        default:
            return Color.gray // Domyślny kolor, jeśli status jest nieznany
        }
    }
}

struct BMIOutcome_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BMIOutcome(bmi: 22.45, status: "Normal")
                .previewDisplayName("Normal BMI")
                .environmentObject(WebSocketManager())
                .environmentObject(LocalizationManager())

            BMIOutcome(bmi: 28.76, status: "Overweight")
                .previewDisplayName("Overweight BMI")
                .environmentObject(WebSocketManager())
                .environmentObject(LocalizationManager())

            BMIOutcome(bmi: 31.22, status: "Obesity")
                .previewDisplayName("Obesity BMI")
                .environmentObject(WebSocketManager())
                .environmentObject(LocalizationManager())

            BMIOutcome(bmi: 18.23, status: "Underweight")
                .previewDisplayName("Underweight BMI")
                .environmentObject(WebSocketManager())
                .environmentObject(LocalizationManager())
        }
        .previewLayout(.sizeThatFits) // Aby widok wypełnił się do rozmiaru kontenera
        .padding()
    }
}



