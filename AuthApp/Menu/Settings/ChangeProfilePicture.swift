import SwiftUI

struct ChangeProfilePicture: View {
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
        VStack {
            Text("Change your\nprofile picture")
              .font(
                Font.custom("Roboto Mono", size: 32)
                  .weight(.bold)
              )
              .multilineTextAlignment(.center)
              .foregroundColor(.white)
              .shadow(radius: 10)
            
            ZStack{
                Circle()
                    .fill(Color.white)
                    .frame(width: 225, height: 225)
                    .shadow(radius: 10)
                
                
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 197, height: 197)
                    .background(
                        Image("lamiine")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 197, height: 197)
                            .clipped()
                    )
                    .cornerRadius(197)
            }
            
            Button(action: {
                
            }) {
                Text("Upload new picture")
                    .font(Font.custom("RobotoMono-Bold", size: 20))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                    .padding()
                    .frame(width: 273, height: 58)
                    .background(Color.white)
                    .cornerRadius(100)
                    .offset(y: 20)
                    .shadow(radius: 10)
            }
        }
        .padding(.bottom, 100)
    }

}

struct ChangeProfilePicture_Previews: PreviewProvider {
    static var previews: some View {
        ChangeProfilePicture(
        )
        .environmentObject(WebSocketManager()) // Jeśli wymaga `WebSocketManager`
        .environmentObject(LocalizationManager())
    }
}

