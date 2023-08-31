import SwiftUI
import CoreML

class ComparingClothesViewModel: ObservableObject {
    @Published var image: UIImage?
    @Published var classLabel: String = ""
    @Published var showPicker: Bool = false
    @Published var source: Picker.Source = .library
    
    private var imageClassifier: ClothesIdentifier?
    
    init() {
        do {
            imageClassifier = try ClothesIdentifier(configuration: MLModelConfiguration())
        } catch {
            print("Error intialising Model: \(error)")
        }
    }
    
    func showPhotoPicker() {
        if source == .camera {
            if !Picker.checkPermissions() {
                print("There is no camera on this device")
                return
            }
        }
        
        showPicker = true
    }
    
    func predictClothingItem() {
        guard let chosenImage = image else { return }
        guard let pixelBuffer = chosenImage.toCVPixelBuffer() else { return }
        
        do {
            let result = try imageClassifier?.prediction(image: pixelBuffer)
            classLabel = result?.classLabel ?? ""
            print(classLabel)
        } catch {
            print("Could not fetch data from model: \(error)")
        }
    }
}
