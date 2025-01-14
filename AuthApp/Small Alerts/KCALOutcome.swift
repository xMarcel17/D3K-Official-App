import SwiftUI

struct KCALOutcome: View {
    @Environment(\.presentationMode) var presentationMode // Obsługa cofania
    @EnvironmentObject var webSocketManager: WebSocketManager // Obsługa WebSocket
    @EnvironmentObject var languageManager: LocalizationManager // Obsługa lokalizacji
    
    var body: some View {

        VStack(spacing: 20) {
            
            Text("Your Calorie income is:")
              .font(
                Font.custom("Roboto Mono", size: 24)
                  .weight(.bold)
              )
              .multilineTextAlignment(.center)
              .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
              .frame(width: 221, alignment: .center)
            

            VStack (spacing: 0){
                Text("2747")
                    .font(
                        Font.custom("Roboto Mono", size: 64)
                            .weight(.bold)
                    )
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                    .frame(width: 237, height: 74, alignment: .center)
                
                
                Text("kcal")
                    .font(
                        Font.custom("Roboto Mono", size: 24)
                            .weight(.bold)
                    )
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                    .frame(width: 85, height: 23, alignment: .center)
            }
            
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
            .padding(.top, 8)
        }
        .background(Color(red: 1, green: 1, blue: 1))
        .padding()
    }
}

struct KCALOutcome_Previews: PreviewProvider {
    static var previews: some View {
        KCALOutcome(
        )
    }
}


