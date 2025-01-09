import SwiftUI
import UIKit

struct IntroView: View {
    @State private var isAnimationComplete = false

    var body: some View {
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

            // Logo D3K z GIF-em na środku
            if !isAnimationComplete {
                VStack {
                    NativeGifView(gifName: "LogoGif", isAnimationComplete: $isAnimationComplete)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                        .clipped() // Ograniczenie widocznego obszaru
                        .padding(.bottom, 50) // Opcjonalny margines
                }
            }

            // Nawigacja do LoginView po zakończeniu animacji
            if isAnimationComplete {
                NavigationView {
                    LoginView()
                }
                .transition(.opacity)
            }
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
