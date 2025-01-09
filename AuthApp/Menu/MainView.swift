import SwiftUI

struct MainView: View {
    var username: String
    @Binding var isLoggedIn: Bool
    @Binding var showWelcomeAlert: Bool
    @Binding var usernameField: String
    @Binding var passwordField: String
    @Binding var rememberMe: Bool
    @EnvironmentObject var bleManager: BLEManager // Pobieramy BLEManager z EnvironmentObject
    
    var body: some View {
        ZStack {
            ZStack{
                VStack (spacing: 15){
                    ZStack{
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 343, height: 78)
                            .background(
                                LinearGradient(
                                    stops: [
                                        Gradient.Stop(color: Color(red: 0.75, green: 0.73, blue: 0.87), location: 0.00),
                                        Gradient.Stop(color: Color(red: 0.5, green: 0.63, blue: 0.83), location: 1.00),
                                    ],
                                    startPoint: UnitPoint(x: 0.5, y: 0),
                                    endPoint: UnitPoint(x: 0.5, y: 1)
                                )
                            )
                            .cornerRadius(50)
                            .shadow(radius: 5)
                        
                        Text("Welcome, \(username)!")
                            .font(Font.custom("RobotoMono-Bold", size: 18))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .padding(.trailing, 70)
                    }
                    .frame(width: 343, height: 78)
                    
                    Button{
                        
                    } label: {
                        ZStack{
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 343, height: 211)
                                .background(
                                    LinearGradient(
                                        stops: [
                                            Gradient.Stop(color: Color(red: 0.75, green: 0.73, blue: 0.87), location: 0.00),
                                            Gradient.Stop(color: Color(red: 0.5, green: 0.63, blue: 0.83), location: 1.00),
                                        ],
                                        startPoint: UnitPoint(x: 0.5, y: 0),
                                        endPoint: UnitPoint(x: 0.5, y: 1)
                                    )
                                )
                                .cornerRadius(40)
                                .shadow(radius: 5)
                            
                            Image("HeartrateRed")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(.bottom, 40)
                                .opacity(0.3)
                                
                            
                            Image("RunningManSmall")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 109, height: 137)
                                .padding(.bottom, 40)
                                .padding(.trailing, 20)
                            
                            Text("My trainings")
                                .font(Font.custom("RobotoMono-Bold", size: 28))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .padding(.top, 140)
                        }
                        .frame(width: 343, height: 211)
                    }
                    
                    
                    HStack (spacing: 15){
                        VStack (spacing: 15){
                            Button{
                                
                            } label: {
                                ZStack{
                                    Rectangle()
                                        .foregroundColor(.clear)
                                        .frame(width: 165, height: 172)
                                        .background(
                                            LinearGradient(
                                                stops: [
                                                    Gradient.Stop(color: Color(red: 0.75, green: 0.73, blue: 0.87), location: 0.00),
                                                    Gradient.Stop(color: Color(red: 0.5, green: 0.63, blue: 0.83), location: 1.00),
                                                ],
                                                startPoint: UnitPoint(x: 0.5, y: 0),
                                                endPoint: UnitPoint(x: 0.5, y: 1)
                                            )
                                        )
                                        .cornerRadius(40)
                                        .shadow(radius: 5)
                                    
                                    Image("MessageBlue")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 57, height: 57)
                                        .padding(.bottom, 80)
                                        .padding(.trailing, 71)
                                        .opacity(0.4)
                                    
                                    Image("ForumLogo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 76, height: 76)
                                        .padding(.bottom, 5)
                                        .padding(.leading, 40)
                                    
                                    Text("Forum")
                                        .font(Font.custom("RobotoMono-Bold", size: 28))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.white)
                                        .padding(.top, 110)
                                }
                                .frame(width: 165, height: 172)
                            }
                            
                            Button{
                                
                            } label: {
                                ZStack{
                                    Rectangle()
                                        .foregroundColor(.clear)
                                        .frame(width: 165, height: 172)
                                        .background(
                                            LinearGradient(
                                                stops: [
                                                    Gradient.Stop(color: Color(red: 0.75, green: 0.73, blue: 0.87), location: 0.00),
                                                    Gradient.Stop(color: Color(red: 0.5, green: 0.63, blue: 0.83), location: 1.00),
                                                ],
                                                startPoint: UnitPoint(x: 0.5, y: 0),
                                                endPoint: UnitPoint(x: 0.5, y: 1)
                                            )
                                        )
                                        .cornerRadius(40)
                                        .shadow(radius: 5)
                                    
                                    Image("Stars")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 74, height: 97)
                                        .padding(.bottom, 60)
                                        .padding(.leading, 60)
                                        .opacity(0.5)
                                    
                                    Image("Trophy")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 89, height: 80)
                                        .padding(.bottom, 12)
                                        .padding(.trailing, 45)
                                    
                                    Text("Badges")
                                        .font(Font.custom("RobotoMono-Bold", size: 28))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.white)
                                        .padding(.top, 100)
                                }
                                .frame(width: 165, height: 172)
                            }
                        }
                        .frame(width: 165, height: 359)
                        
                        Button{
                            
                        } label: {
                            ZStack{
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 163, height: 359)
                                    .background(
                                        LinearGradient(
                                            stops: [
                                                Gradient.Stop(color: Color(red: 0.75, green: 0.73, blue: 0.87), location: 0.00),
                                                Gradient.Stop(color: Color(red: 0.5, green: 0.63, blue: 0.83), location: 1.00),
                                            ],
                                            startPoint: UnitPoint(x: 0.5, y: 0),
                                            endPoint: UnitPoint(x: 0.5, y: 1)
                                        )
                                    )
                                    .cornerRadius(40)
                                    .shadow(radius: 5)
                                
                                Image("Food")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 163, height: 163)
                                    .padding(.bottom, 150)
                                    .opacity(0.5)
                                
                                Image("Meter")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 139, height: 73)
                                    .padding(.top, 110)
                                
                                Text("BMI & KCAL")
                                    .font(Font.custom("RobotoMono-Bold", size: 23))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white)
                                    .padding(.top, 235)
                                
                                Text("Calculator")
                                    .font(Font.custom("RobotoMono-Bold", size: 20))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white)
                                    .padding(.top, 290)
                            }
                            .frame(width: 163, height: 359)
                        }
                    }
                    .frame(width: 343, height: 359)
                }
            }
            .padding(.bottom, 10)
            
            ZStack{
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: abs(500), height: abs(100))
                    .background(
                        LinearGradient(
                            stops: [
                                Gradient.Stop(color: Color(red: 0.75, green: 0.73, blue: 0.87), location: 0.00),
                                Gradient.Stop(color: Color(red: 0.5, green: 0.63, blue: 0.83), location: 1.00),
                            ],
                            startPoint: UnitPoint(x: 0.5, y: 0),
                            endPoint: UnitPoint(x: 0.5, y: 1)
                        )
                        .frame(width: abs(500), height: abs(100))
                        .shadow(radius: 5)
                    )
            }
            .padding(.top, 800)
        }
        .background(.white)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(
            username: "TestUser",                     // Przykładowa nazwa użytkownika
            isLoggedIn: .constant(true),              // Ustawienie przykładowej wartości Binding
            showWelcomeAlert: .constant(false),       // Binding dla alertu
            usernameField: .constant("TestUser"),     // Binding dla pola nazwy użytkownika
            passwordField: .constant("password123"),  // Binding dla pola hasła
            rememberMe: .constant(true)              // Binding dla przełącznika "zapamiętaj mnie",
        )
        .environmentObject(BLEManager())             // Przykładowe środowisko BLEManager
        //.preferredColorScheme(.light)                 // Dodatkowe zabezpieczenie dla podglądu
    }
}
