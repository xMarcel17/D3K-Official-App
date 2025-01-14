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
    
    @State private var selectedLevel = ""
    let activityLevels = ["Very low (0-1 trainings/week)", "Low (2-3 trainings/week)",  "Medium (4-5 trainings/week)", "High (6-7 trainings/week)", "Very high (8+ trainings/week)"]
    
    @State private var kcal: Float = 0.0
    @State private var calculatedKCAL: Int = 0 // Wynik KCAL do przekazania do KCALOutcome
    
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
        VStack{
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
            
                VStack (spacing: 5){
                    Text("Activity level") // Tekst wyświetlany
                        .font(
                            Font.custom("Roboto Mono", size: 20)
                                .weight(.bold)
                        )
                        .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69)) // Kolor tekstu
                    
                    Picker("Activity level", selection: $selectedLevel) {
                        ForEach(activityLevels, id: \.self) { level in
                            Text(level)
                                .tag(level)
                        }
                    }
                    .frame(width: 280, height: 40) // Rozmiar ramki
                    .background(Color(red: 0.27, green: 0.43, blue: 0.69)) // Kolor tła
                    .cornerRadius(20) // Zaokrąglone rogi
                    .pickerStyle(.menu) // Styl rozwijanego menu

                }
                .padding(.top, 25)

                Button(action: {
                    calculateKCAL()
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
                .padding(.top, 5)
            }
    
        }
        .overlay(
            Group {
                if showKCALoutput {
                    KCALOutcome(kcal: calculatedKCAL)
                    .frame(width: 321, height: 292)
                    .background(Color.white)
                    .cornerRadius(40)
                    .shadow(radius: 90)
                    .transition(.opacity)
                }
            }
        )
    }
    
    // Słownik mapujący poziomy aktywności na wskaźnik aktywności fizycznej
    let activityFactors: [String: Float] = [
        "Very low (0-1 trainings/week)": 1.3,
        "Low (2-3 trainings/week)": 1.4,
        "Medium (4-5 trainings/week)": 1.6,
        "High (6-7 trainings/week)": 1.75,
        "Very high (8+ trainings/week)": 2.0
    ]
    
    func calculateKCAL() {
        guard let weightValue = Float(weight),
              let heightValue = Float(height),
              let ageValue = Float(age),
              (isMale || isFemale),
              let activityFactor = activityFactors[selectedLevel] else {
            print("Invalid input")
            return
        }
     
        if (isMale){
            kcal = (66 + (13.7 * weightValue) + (5 * heightValue) - (6.8 * ageValue)) * activityFactor
        } else{
            kcal = (655 + (9.6 * weightValue) + (1.8 * heightValue) - (4.7 * ageValue)) * activityFactor
        }
        
        calculatedKCAL = Int(kcal)
        showKCALoutput = true
    }
}

struct KCALCalcView_Previews: PreviewProvider {
    static var previews: some View {
        KCALCalcView()
    }
}
