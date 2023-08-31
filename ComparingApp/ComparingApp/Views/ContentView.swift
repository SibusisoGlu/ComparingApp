import SwiftUI
import CoreML

struct ContentView: View {
    let images = ["images", "images-1", "images-2"]
    var imageClassifier: AnimalCalssifier?

    @State private var currentIndex = 0
    @State private var classLabel = ""

    init() {
        do {
            imageClassifier = try AnimalCalssifier(configuration: MLModelConfiguration())
        } catch {
            print("Error intialising Model: \(error)")
        }
    }

    var isPreviousButtonValid: Bool {
        currentIndex != 0
    }

    var isNxetButtonValid: Bool {
        currentIndex < images.count - 1
    }

    var body: some View {
        VStack {
            Image(images[currentIndex])
            Button("Predict") {
                predict()
            }.buttonStyle(.borderedProminent)

            Text(classLabel)

            HStack {
                Button("Previous") {
                    classLabel = ""
                    currentIndex -= 1
                }.disabled(!isPreviousButtonValid)

                Button("Next") {
                    classLabel = ""
                    currentIndex += 1
                }.disabled(!isNxetButtonValid)
                    .padding()
            }
        }
        .padding()
    }

    func predict() {
        guard let uiImage = UIImage(named: images[currentIndex]) else {
            return
        }

        // pixel buffer
        guard let pixelBuffer = uiImage.toCVPixelBuffer() else { return }
        do {
            let result = try imageClassifier?.prediction(image: pixelBuffer)
            classLabel = result?.classLabel ?? ""
        } catch {
            print("Could not fetch data from model: \(error)")
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
