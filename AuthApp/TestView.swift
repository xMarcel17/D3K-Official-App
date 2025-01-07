import SwiftUI

struct TestView: View {
    var body: some View {
        ZStack{
            ZStack{
                VStack (spacing: 15){
                    Text("chuj")
                    
                }
                .offset(y: -15)
                
                
                
                ZStack{
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: abs(500), height: abs(120))
                        .background(
                            LinearGradient(
                                stops: [
                                    Gradient.Stop(color: Color(red: 0.75, green: 0.73, blue: 0.87), location: 0.00),
                                    Gradient.Stop(color: Color(red: 0.5, green: 0.63, blue: 0.83), location: 1.00),
                                ],
                                startPoint: UnitPoint(x: 0.5, y: 0),
                                endPoint: UnitPoint(x: 0.5, y: 1)
                            )
                            .frame(width: abs(500), height: abs(120))
                            .shadow(radius: 5)
                        )
                        .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 100)
                }
            }
        }
    }
}

#Preview {
    TestView()
}
