import SwiftUI

struct SingleTrainingView: View {
    var body: some View {
        ZStack{
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
        ZStack{
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
            
            Rectangle()
                .foregroundStyle(Color.clear)
                .frame(width: 600, height: 600)
                
        }
    }
    
    var contentView: some View {
        VStack (spacing: 29){
            VStack (spacing: 12){
                Text("Running_03")
                    .font(
                        Font.custom("Roboto Mono", size: 36)
                            .weight(.bold)
                    )
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .frame(width: 219, height: 35, alignment: .center)
                    .shadow(radius: 10)
                
                HStack{
                    Image("Calendar")
                      .resizable()
                      .scaledToFit()
                      .frame(width: 20, height: 20)
                    
                    Text("MON, 09/12/2024")
                      .font(
                        Font.custom("Roboto Mono", size: 18)
                          .weight(.bold)
                      )
                      .multilineTextAlignment(.center)
                      .foregroundColor(.white)
                      .frame(width: 177, height: 20, alignment: .center)
                }
                .shadow(radius: 10)
            }
            .frame(width: 219, height: 65)
            .padding(.trailing, 110)
            .shadow(radius: 10)
            
            VStack(spacing: 29){
                Button(action: {

                }) {
                    ZStack{
                        Image("RunningManTraining")
                          .resizable()
                          .scaledToFit()
                          .frame(width: 186, height: 124)
                          .padding(.leading, 80)

                        
                        Text("Speed Graph")
                            .font(
                                Font.custom("Roboto Mono", size: 24)
                                    .weight(.bold)
                            )
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                            .frame(width: 159, height: 18, alignment: .center)
                            .padding(.bottom, 45)
                            .padding(.trailing, 130)
                        
                        Image("SingleRightBlue")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .padding(.top, 50)
                            .padding(.leading, 275)
                    }
                    .frame(width: 325, height: 100)
                    .background(.white)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                }

                
                Button(action: {

                }) {
                    ZStack{
                        Image("HeartrateTraining")
                          .resizable()
                          .scaledToFit()
                          .frame(width: 325, height: 100)
                          .opacity(0.35)
                          
                        Text("Heartrate Graph")
                            .font(
                                Font.custom("Roboto Mono", size: 24)
                                    .weight(.bold)
                            )
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                            .frame(width: 217, height: 18, alignment: .center)
                            .padding(.bottom, 45)
                            .padding(.trailing, 75)
                        
                        Image("SingleRightBlue")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .padding(.top, 50)
                            .padding(.leading, 275)
                    }
                    .frame(width: 325, height: 100)
                    .background(.white)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                }
                
                ZStack{
                    Image("TimeTraining")
                      .resizable()
                      .scaledToFit()
                      .frame(width: 82, height: 82)
                      .padding(.trailing, 40)
                    
                    HStack(spacing: 100){
                        Text("Time:")
                            .font(
                                Font.custom("Roboto Mono", size: 20)
                                    .weight(.bold)
                            )
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                            .frame(width: 76, height: 25, alignment: .center)
                        
                        Text("")
                            .font(
                                Font.custom("Roboto Mono", size: 20)
                                    .weight(.bold)
                            )
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                            .frame(width: 110, height: 25, alignment: .trailing)
                    }
                }
                .frame(width: 325, height: 57)
                .background(.white)
                .cornerRadius(15)
                .shadow(radius: 10)
                
                HStack(spacing: 29){
                    ZStack{
                        Image("FlameTraining")
                          .resizable()
                          .scaledToFit()
                          .frame(width: 90, height: 90)
                          .padding(.leading, 50)
                        
                        Text("Calories:")
                          .font(
                            Font.custom("Roboto Mono", size: 20)
                              .weight(.bold)
                          )
                          .multilineTextAlignment(.center)
                          .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                          .frame(width: 109, height: 25, alignment: .leading)
                          .padding(.bottom, 50)
                          .padding(.trailing, 10)
                    }
                    .frame(width: 148, height: 100)
                    .background(.white)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    
                    ZStack{
                        Image("DistanceTraining")
                          .resizable()
                          .scaledToFit()
                          .frame(width: 80, height: 80)
                          .padding(.leading, 50)
                        
                        Text("Distance:")
                            .font(
                                Font.custom("Roboto Mono", size: 20)
                                    .weight(.bold)
                            )
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                            .frame(width: 109, height: 25, alignment: .leading)
                            .padding(.bottom, 50)
                            .padding(.trailing, 10)
                    }
                    .frame(width: 148, height: 100)
                    .background(.white)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                }
                .frame(width: 325, height: 100)
                
                HStack(spacing: 29){
                    ZStack{
                        Image("StepsTraining")
                          .resizable()
                          .scaledToFit()
                          .frame(width: 90, height: 90)
                          .padding(.leading, 40)
                          .padding(.bottom, 5)
                        
                        Text("Avg Steps:")
                          .font(
                            Font.custom("Roboto Mono", size: 20)
                              .weight(.bold)
                          )
                          .multilineTextAlignment(.center)
                          .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                          .frame(width: 121, height: 25, alignment: .leading)
                          .padding(.bottom, 50)
                    }
                    .frame(width: 148, height: 100)
                    .background(.white)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    
                    ZStack{
                        Image("HeartTraining")
                          .resizable()
                          .scaledToFit()
                          .frame(width: 90, height: 90)
                          .padding(.leading, 35)
                        
                        Text("Avg BPM:")
                            .font(
                                Font.custom("Roboto Mono", size: 20)
                                    .weight(.bold)
                            )
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.27, green: 0.43, blue: 0.69))
                            .frame(width: 121, height: 25, alignment: .leading)
                            .padding(.bottom, 50)
                    }
                    .frame(width: 148, height: 100)
                    .background(.white)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                }
                .frame(width: 325, height: 100)

            }
        }
        .padding(.top, 40)
    }
}

struct SingleTrainingView_Previews: PreviewProvider {
    static var previews: some View {
        SingleTrainingView()
    }
}
