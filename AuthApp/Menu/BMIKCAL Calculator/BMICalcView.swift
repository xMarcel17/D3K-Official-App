import SwiftUI
import UIKit

extension UIApplication {
    func hideKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct BMICalcView: View {
    @Environment(\.presentationMode) var presentationMode // Obsługa cofania
    @EnvironmentObject var webSocketManager: WebSocketManager // Obsługa WebSocket
    @EnvironmentObject var languageManager: LocalizationManager // Obsługa lokalizacji
    
    @State private var weight = ""
    @State private var height = ""
    @State private var age = ""
    @State private var showBMIoutput = false
    
    @State private var calculatedBMI: Float = 0.0 // Wynik PPM do przekazania do BMIOutcome
    @State private var status = " " // Obliczony status
        
    
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
                Image("MeterPurple")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 333, height: 175)
                    .opacity(0.37)
                    .padding(.bottom, 280)
            }
            .frame(width: 600, height: 600)
        }
        .onTapGesture {
            UIApplication.shared.hideKeyboard() // Ukrycie klawiatury po kliknięciu w tło
        }
    }
    
    var contentView: some View {
        VStack (spacing: 35){
            Text("BMI\nCalculator")
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
                
                
                Button(action: {
                    calculateBMI()
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
                .padding(.top, 36)
            }
    
        }
        .overlay(
            Group {
                if showBMIoutput {
                    BMIOutcome(bmi: calculatedBMI, status: status)
                    .frame(width: 321, height: 292)
                    .background(Color.white)
                    .cornerRadius(40)
                    .shadow(radius: 90)
                    .transition(.opacity)
                }
            }
        )
    }
    
    // Funkcja obliczająca PPM
    func calculateBMI() {
        guard let weightValue = Float(weight),
              let heightValue = Float(height),
              let ageValue = Float(age) else {
            print("Invalid input")
            return
        }
        
        let heightValueInMeters = heightValue / 100
        calculatedBMI = weightValue / (heightValueInMeters * heightValueInMeters)
        
        // Określenie przedziału normalnego BMI w zależności od wieku
        let normalRange: ClosedRange<Float>
        
        switch ageValue {
        case 19...24:
            normalRange = 19.0...24.0
        case 25...34:
            normalRange = 20.0...25.0
        case 35...44:
            normalRange = 21.0...26.0
        case 45...54:
            normalRange = 22.0...27.0
        case 55...64:
            normalRange = 23.0...28.0
        default: // 65 lat i więcej
            normalRange = 24.0...29.0
        }
        
        // Możesz zapisać skrajne wartości przedziału jako osobne zmienne
        let lowerBound = normalRange.lowerBound
        let upperBound = normalRange.upperBound
        
        if (calculatedBMI < lowerBound){
            status = "Underweight"
        }
        else if ((calculatedBMI > lowerBound) && (calculatedBMI < upperBound)){
            status = "Normal"
        }
        else if (calculatedBMI > upperBound) && (calculatedBMI < 31){
            status = "Overweight"
        }
        else{
            status = "Obesity"
        }
            
        showBMIoutput = true
    }
}

struct BMICalcView_Previews: PreviewProvider {
    static var previews: some View {
        BMICalcView()
    }
}
