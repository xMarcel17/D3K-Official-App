import SwiftUI

struct AppInformation: View {
    @EnvironmentObject var webSocketManager: WebSocketManager
    @EnvironmentObject var languageManager: LocalizationManager

    var body: some View {

            ZStack {
                backgroundView
                
                contentView
                
                // Custom back button in the top-left corner
                HStack {
                    Button(action: {
                        
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
        VStack (spacing: 262){
            VStack (spacing: -50){
                Image("Logo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 350, height: 350)
                    .clipped()
                    .shadow(radius: 10)
                
                VStack{
                    Text("D3K Official App")
                        .font(
                            Font.custom("Roboto Mono", size: 32)
                                .weight(.bold)
                        )
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .frame(width: 317, height: 41, alignment: .center)
                    
                    Text("version: 1.0")
                        .font(
                            Font.custom("Roboto Mono", size: 24)
                                .weight(.bold)
                        )
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .frame(width: 207, height: 26, alignment: .center)
                        .shadow(radius: 10)
                }
                .shadow(radius: 10)
                

            }
            
            Text("Created by:\nMarcel Radtke\nBartosz Rakowski")
                .font(
                    Font.custom("Roboto Mono", size: 20)
                        .weight(.bold)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .frame(width: 211, height: 91, alignment: .center)
                .shadow(radius: 10)
        }
    }

}

struct AppInformation_Previews: PreviewProvider {
    static var previews: some View {
        AppInformation(
        )
        .environmentObject(WebSocketManager()) // Jeśli wymaga `WebSocketManager`
        .environmentObject(LocalizationManager())
    }
}

