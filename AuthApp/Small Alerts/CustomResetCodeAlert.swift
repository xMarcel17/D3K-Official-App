import SwiftUI

struct CustomResetCodeAlert: View {
    @EnvironmentObject var languageManager: LocalizationManager
    
    let resetCode: String
    let onDismiss: () -> Void
    let customMessage: String

    var body: some View {

        VStack(spacing: 20) {
            
            Text(languageManager.localizedString(forKey: "resetcodetext"))
              .font(
                Font.custom("Roboto Mono", size: 24)
                  .weight(.bold)
              )
              .multilineTextAlignment(.center)
              .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
              .frame(width: 297, height: 64, alignment: .center)
            

            ZStack{
                Rectangle()
                  .foregroundColor(.clear)
                  .frame(width: 169, height: 71)
                  .background(Color(red: 0.85, green: 0.85, blue: 0.85))
                  .cornerRadius(20)
                
                Text(resetCode)
                    .font(Font.custom("Roboto Mono", size: 36).weight(.bold))
                    .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                    .padding()
            }
            
            
            Text(customMessage) // Wyświetlamy
                .font(
                  Font.custom("Roboto Mono", size: 20)
                    .weight(.medium)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                .frame(width: 281, height: 85, alignment: .center)


            Button(action: {
                onDismiss()
            }) {
                ZStack{
                    Rectangle()
                      .foregroundColor(.clear)
                      .frame(width: 159, height: 44)
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
}

struct CustomResetCodeAlert_Previews: PreviewProvider {
    static var previews: some View {
        CustomResetCodeAlert(
            resetCode: "123678", // Przykładowy kod resetu
            onDismiss: {},         // Przykładowa pusta akcja
            customMessage: "Save it in a safe place. This message is displayed once." // Przykładowy komunikat
        )
        .environmentObject(LocalizationManager()) // Ustawienie środowiska dla LocalizationManager
    }
}


