import SwiftUI
import UIKit

struct KCALCalcView: View {
    @Environment(\.presentationMode) var presentationMode // Obsługa cofania
    @EnvironmentObject var webSocketManager: WebSocketManager // Obsługa WebSocket
    @EnvironmentObject var languageManager: LocalizationManager // Obsługa lokalizacji
    
    @State private var weight = ""
    @State private var height = ""
    @State private var age = ""
    @State private var isMale = false
    @State private var isFemale = false
    @State private var showKCALoutput = false
    
    @State private var selectedLevel = "Low"
    let activityLevels = ["Low", "Medium", "High"]
    
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
    }
    
    var backgroundView: some View {
        ZStack{
            Color.white
                .ignoresSafeArea()
            
            ZStack{
                Image("FlamePurple")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 400, height: 400)
                    .opacity(0.37)
                    .padding(.bottom, 100)
            }
            .frame(width: 600, height: 600)
        }
        .onTapGesture {
            UIApplication.shared.hideKeyboard() // Ukrycie klawiatury po kliknięciu w tło
        }
    }
    
    var contentView: some View {
        VStack (spacing: 35){
            Text("Calories\nCalculator")
              .font(
                Font.custom("Roboto Mono", size: 36)
                  .weight(.bold)
              )
              .multilineTextAlignment(.center)
              .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
              .frame(width: 251, height: 107, alignment: .center)
            
            VStack (spacing: 26){
                HStack (spacing: 47){
                    VStack{
                        Text("Weight(kg)")
                            .font(
                                Font.custom("Roboto Mono", size: 20)
                                    .weight(.bold)
                            )
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                            .frame(width: 145, height: 42, alignment: .center)
                        
                        ZStack(alignment: .center) {
                            TextField("", text: $weight)
                                .padding()
                                .keyboardType(.numberPad)
                                .background(Color(red: 0.87, green: 0.85, blue: 0.89))
                                .cornerRadius(20)
                                .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                                .autocapitalization(.none)
                                .keyboardType(.default)
                                .multilineTextAlignment(.center)
                                .font(.system(size: 36, weight: .semibold, design: .monospaced))
                                .shadow(radius: 5)
                            if weight.isEmpty { // Sprawdzamy, czy pole tekstowe jest puste
                                Text("Weight")
                                    .font(.system(size: 16, weight: .semibold, design: .monospaced))
                                    .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69, opacity: 0.75))
                            }
                        }
                        .frame(width: 145, height: 64)
                    }
                    
                    
                    VStack{
                        Text("Height(cm)")
                            .font(
                                Font.custom("Roboto Mono", size: 20)
                                    .weight(.bold)
                            )
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                            .frame(width: 145, height: 42, alignment: .center)
                        
                        
                        ZStack(alignment: .center) {
                            TextField("", text: $height)
                                .padding()
                                .keyboardType(.numberPad)
                                .background(Color(red: 0.87, green: 0.85, blue: 0.89))
                                .cornerRadius(20)
                                .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                                .autocapitalization(.none)
                                .keyboardType(.default)
                                .multilineTextAlignment(.center)
                                .font(.system(size: 36, weight: .semibold, design: .monospaced))
                                .shadow(radius: 5)
                            if height.isEmpty { // Sprawdzamy, czy pole tekstowe jest puste
                                Text("Height")
                                    .font(.system(size: 16, weight: .semibold, design: .monospaced))
                                    .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69, opacity: 0.75))
                            }
                        }
                        .frame(width: 145, height: 64)
                    }
                }
                .frame(width: 337, height: 106)
                
                VStack{
                    Text("Age")
                      .font(
                        Font.custom("Roboto Mono", size: 20)
                          .weight(.bold)
                      )
                      .multilineTextAlignment(.center)
                      .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                      .frame(width: 145, height: 42, alignment: .center)
                    
                    
                    ZStack(alignment: .center) {
                        TextField("", text: $age)
                            .padding()
                            .keyboardType(.numberPad)
                            .background(Color(red: 0.87, green: 0.85, blue: 0.89))
                            .cornerRadius(20)
                            .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                            .autocapitalization(.none)
                            .keyboardType(.default)
                            .multilineTextAlignment(.center)
                            .font(.system(size: 36, weight: .semibold, design: .monospaced))
                            .shadow(radius: 5)
                        if age.isEmpty { // Sprawdzamy, czy pole tekstowe jest puste
                            Text("Age")
                                .font(.system(size: 16, weight: .semibold, design: .monospaced))
                                .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69, opacity: 0.75))
                        }
                    }
                    .frame(width: 145, height: 64)
                }
                .frame(width: 145, height: 106)
                
                ZStack{
                    Rectangle()
                      .foregroundColor(.clear)
                      .frame(width: 287, height: 96)
                      .background(Color(red: 0.87, green: 0.85, blue: 0.89))
                      .cornerRadius(20)
                      .shadow(radius: 5)
                    
                    Rectangle()
                      .foregroundColor(.clear)
                      .frame(width: 3, height: 96)
                      .background(Color(red: 0.27, green: 0.43, blue: 0.69))
                    
                    HStack{
                        ZStack{
                            Button(action: {
                                isMale = true
                                isFemale = false
                            }) {
                                VStack{
                                    Image("Male")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 38, height: 38)
                                    
                                    Text("Male")
                                      .font(
                                        Font.custom("Roboto Mono", size: 20)
                                          .weight(.bold)
                                      )
                                      .multilineTextAlignment(.center)
                                      .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                                      .frame(width: 50, height: 15, alignment: .center)
                                }
                                .frame(width: 142, height: 96)
                            }
                            
                        }
                        .frame(width: 142, height: 96)
                        
                        ZStack{
                            Button(action: {
                                isMale = false
                                isFemale = true
                            }) {
                                VStack{
                                    Image("Female")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 38, height: 38)
                                    
                                    Text("Female")
                                      .font(
                                        Font.custom("Roboto Mono", size: 20)
                                          .weight(.bold)
                                      )
                                      .multilineTextAlignment(.center)
                                      .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                                      .frame(width: 74, height: 15, alignment: .center)
                                    
                                }
                                .frame(width: 142, height: 96)
                                
                            }
                        }
                        .frame(width: 142, height: 96)
                        
                    }
                    .frame(width: 287, height: 96)
                    
                    if isFemale {
                        Image("Check")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35, height: 35)
                            .padding(.leading, 240)
                            .padding(.bottom, 50)
                    }
                    else if isMale {
                        Image("Check")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35, height: 35)
                            .padding(.trailing, 240)
                            .padding(.bottom, 50)
                    }
                }
                .padding(.top, 38)
                .frame(width: 287, height: 96)
                
                
                Picker("Activity level", selection: $selectedLevel) {
                    ForEach(activityLevels, id: \.self) { level in
                        Text(level)
                            .tag(level)
                    }
                }
                .frame(width: 130, height: 40) // Rozmiar ramki
                .background(Color(red: 0.27, green: 0.43, blue: 0.69)) // Kolor tła
                .cornerRadius(20) // Zaokrąglone rogi
                .padding(.leading, 210)
                .pickerStyle(.menu) // Styl rozwijanego menu
                .frame(width: 327, height: 57) // Rozmiar ramki
                .overlay(
                    Text("Activity level") // Tekst wyświetlany
                        .font(
                            Font.custom("Roboto Mono", size: 20)
                                .weight(.bold)
                        )
                        .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69)) // Kolor tekstu
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 10),
                    alignment: .leading
                )
                .padding(.top, 28)
          

                Button(action: {
                    showKCALoutput = true
                }) {
                    Text("CALCULATE")
                        .font(Font.custom("RobotoMono-Bold", size: 24))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 249, height: 65)
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
                        .cornerRadius(50.0)
                        .shadow(radius: 5)
                }
                .padding(.top, 10)
            }
    
        }
        .overlay(
            Group {
                if showKCALoutput {
                    KCALOutcome()
                    .frame(width: 321, height: 292)
                    .background(Color.white)
                    .cornerRadius(40)
                    .shadow(radius: 90)
                    .transition(.opacity)
                }
            }
        )
        
    }
}

struct KCALCalcView_Previews: PreviewProvider {
    static var previews: some View {
        KCALCalcView()
    }
}
