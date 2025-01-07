import SwiftUI

struct CustomResetCodeAlert: View {
    @EnvironmentObject var languageManager: LocalizationManager
    
    let resetCode: String
    let onDismiss: () -> Void
    let customMessage: String

    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Text(customMessage) // Wyświetlamy niestandardową wiadomość
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.primary)
                    .padding()
                    .frame(maxWidth: 300) // Ustawienie odpowiedniej szerokości dla tekstu
                    .fixedSize(horizontal: false, vertical: true) // Pozwala na wieloliniowość

                Text(resetCode)
                    .font(.system(size: 28, weight: .bold, design: .monospaced))
                    .padding()
                    .background(Color(UIColor.systemBackground))
                    .cornerRadius(8)
                    .shadow(radius: 5)

                Button(action: {
                    onDismiss()
                }) {
                    Text("Gotowe")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 220, height: 60)
                        .background(Color.blue)
                        .cornerRadius(15.0)
                }
            }
            .padding()
            .background(Color(UIColor.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 10)
            .padding(40)
        }
    }
}

struct CustomResetCodeAlert_Previews: PreviewProvider {
    static var previews: some View {
        CustomResetCodeAlert(
            resetCode: "1234-5678", // Przykładowy kod resetu
            onDismiss: {},         // Przykładowa pusta akcja
            customMessage: "Twój kod resetu został wygenerowany." // Przykładowy komunikat
        )
        .environmentObject(LocalizationManager()) // Ustawienie środowiska dla LocalizationManager
    }
}


