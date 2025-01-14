import SwiftUI

struct ContactUs: View {
    @Environment(\.presentationMode) var presentationMode // Obsługa cofania
    @EnvironmentObject var webSocketManager: WebSocketManager
    @EnvironmentObject var languageManager: LocalizationManager

    var body: some View {

            ZStack {
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
        ZStack {
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

            // Tło RunningMan w trybie wyblakłym
            Image("RunningMan")
                .resizable()
                .scaledToFit()
                .frame(width: 600, height: 600)
                .offset(x: -35)
        }
    }

    var contentView: some View {
        VStack (spacing: 10){
            Text("Contact")
                .font(
                    Font.custom("Roboto Mono", size: 40)
                        .weight(.bold)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
            
            Text("In case you have encountered any issues or bugs related to functionalities of our application, contact us via e-mail\n(click on the e-mail below) ")
                .font(
                    Font.custom("Roboto Mono", size: 20)
                        .weight(.medium)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .frame(width: 341, height: 160, alignment: .center)
            
            HStack{
                Image("Mail")
                  .resizable()
                  .scaledToFit()
                  .frame(width: 32, height: 32)
                  .padding(.top, 4)
                
                Text("d3kapp.support@gmail.com")
                  .font(
                    Font.custom("Roboto Mono", size: 20)
                      .weight(.bold)
                  )
                  .multilineTextAlignment(.center)
                  .foregroundColor(.white)
                  .frame(width: 304, height: 21, alignment: .center)
                
            }
            .padding(.top, 30)
    
        }
        .padding(.bottom, 90)
        .shadow(radius: 10)
    }

}

struct ContactUs_Previews: PreviewProvider {
    static var previews: some View {
        ContactUs(
        )
        .environmentObject(WebSocketManager()) // Jeśli wymaga `WebSocketManager`
        .environmentObject(LocalizationManager())
    }
}

