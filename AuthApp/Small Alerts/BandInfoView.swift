import SwiftUI

struct BandInfoView: View {
    @EnvironmentObject var bleManager: BLEManager
    @EnvironmentObject var webSocketManager: WebSocketManager
    
    let onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 15) {
            Text("Band Information")
                .font(
                  Font.custom("Roboto Mono", size: 28)
                    .weight(.bold)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))

            VStack(alignment: .center, spacing: 20) {
                HStack {
                    Text("Battery level")
                        .font(Font.custom("Roboto Mono", size: 20).weight(.bold)) // Nowa czcionka
                        .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                        .padding(.leading)
                    Spacer()
                    Text("\(bleManager.batteryLevel)%")
                        .font(Font.custom("Roboto Mono", size: 20).weight(.bold)) // Nowa czcionka
                        .foregroundColor(.gray) // Nowy kolor
                        .padding(.trailing)
                }
                .padding()
                .background(Color(red: 0.87, green: 0.85, blue: 0.89))
                .cornerRadius(48.0)
                .frame(width: 320, height: 56)
  

                HStack {
                    Text("Firmware version:")
                        .font(Font.custom("Roboto Mono", size: 20).weight(.bold))
                        .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                        .padding(.leading)
                    Spacer()
                    Text(bleManager.firmwareVersion)
                        .font(Font.custom("Roboto Mono", size: 20).weight(.bold))
                        .foregroundColor(.gray)
                        .padding(.trailing)
                }
                .padding()
                .background(Color(red: 0.87, green: 0.85, blue: 0.89))
                .cornerRadius(48.0)
                .frame(width: 320, height: 56)

                HStack {
                    Text("Files to send:")
                        .font(Font.custom("Roboto Mono", size: 20).weight(.bold))
                        .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                        .padding(.leading)
                    Spacer()
                    Text("\(bleManager.filesToSend)")
                        .font(Font.custom("Roboto Mono", size: 20).weight(.bold))
                        .foregroundColor(.gray)
                        .padding(.trailing)
                }
                .padding()
                .background(Color(red: 0.87, green: 0.85, blue: 0.89))
                .cornerRadius(48.0)
                .frame(width: 320, height: 56)
            }
            .padding()
            .background(.white)
            .cornerRadius(15.0)
            .padding(.horizontal)

            Button(action: {
                onDismiss()
            }) {
                Text("OK")
                    .font(Font.custom("RobotoMono-Bold", size: 20))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 131, height: 44)
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
                    .cornerRadius(100.0)
                    .shadow(radius: 5)
            }
        }
        .background(Color(red: 1, green: 1, blue: 1))
        .padding()
    }
}

struct BandInfoView_Previews: PreviewProvider {
    static var previews: some View {
        BandInfoView() {
            // Dismiss action
        }
        .environmentObject(BLEManager()) // Przykładowe środowisko BLEManager
        .environmentObject(WebSocketManager()) // Przykładowe środowisko WebSocketManager
    }
}
