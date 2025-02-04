import SwiftUI
import UIKit

struct IntroView: View {    
    @State private var isAnimationComplete = false
    
    @AppStorage("appTheme") private var currentTheme: String = "Theme1"

    var body: some View {
        ZStack {
            // Tło – korzystamy ze zmiennych, które zależą od currentTheme
            let (topColor, bottomColor) = colorsForTheme(currentTheme)
            
            // Gradientowe tło
            LinearGradient(
                gradient: Gradient(colors: [topColor, bottomColor]),
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

            // Logo D3K z GIF-em na środku
            if !isAnimationComplete {
                VStack {
                    NativeGifView(gifName: "LogoGif", isAnimationComplete: $isAnimationComplete)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                        .clipped() // Ograniczenie widocznego obszaru
                        .padding(.bottom, 50) // Opcjonalny margines
                }
            }
        }

    }
    
    // Funkcja zwraca parę kolorów (górny i dolny) dla danego motywu
    private func colorsForTheme(_ theme: String) -> (Color, Color) {
        switch theme {
        case "Theme2":
            // Przykładowy drugi motyw
            return (
                Color(red: 0.65, green: 0.83, blue: 0.95),
                Color(red: 0.19, green: 0.30, blue: 0.38)
            )
        default:
            // Domyślny motyw (Theme1)
            return (
                Color(red: 0.75, green: 0.73, blue: 0.87),
                Color(red: 0.5, green: 0.63, blue: 0.83)
            )
        }
    }
}

struct NativeGifView: UIViewRepresentable {
    let gifName: String
    @Binding var isAnimationComplete: Bool

    func makeUIView(context: Context) -> UIView {
        let containerView = UIView()
        containerView.clipsToBounds = true

        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true

        if let gifUrl = Bundle.main.url(forResource: gifName, withExtension: "gif"),
           let gifData = try? Data(contentsOf: gifUrl) {
            let gifSource = CGImageSourceCreateWithData(gifData as CFData, nil)
            var frames: [UIImage] = []
            var totalDuration: TimeInterval = 0

            if let gifSource = gifSource {
                let frameCount = CGImageSourceGetCount(gifSource)
                for index in 0..<frameCount {
                    if let cgImage = CGImageSourceCreateImageAtIndex(gifSource, index, nil) {
                        let frameDuration = NativeGifView.frameDuration(from: gifSource, at: index)
                        totalDuration += frameDuration
                        frames.append(UIImage(cgImage: cgImage))
                    }
                }
            }

            imageView.animationImages = frames
            imageView.animationDuration = totalDuration
            imageView.animationRepeatCount = 1
            imageView.startAnimating()

            DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration) {
                isAnimationComplete = true
            }
        }

        containerView.addSubview(imageView)

        // Ograniczenie rozmiaru GIF-a
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])

        return containerView
    }

    func updateUIView(_ uiView: UIView, context: Context) {}

    static func frameDuration(from source: CGImageSource, at index: Int) -> TimeInterval {
        guard let properties = CGImageSourceCopyPropertiesAtIndex(source, index, nil) as? [CFString: Any],
              let gifProperties = properties[kCGImagePropertyGIFDictionary] as? [CFString: Any],
              let frameDuration = gifProperties[kCGImagePropertyGIFDelayTime] as? TimeInterval else {
            return 0.1
        }
        return frameDuration
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView()
            .environmentObject(WebSocketManager())
            .environmentObject(LocalizationManager())
            .environmentObject(BLEManager())
    }
}
