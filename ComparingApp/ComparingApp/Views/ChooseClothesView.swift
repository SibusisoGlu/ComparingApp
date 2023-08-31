import SwiftUI

struct ChooseClothesView: View {
    @EnvironmentObject var viewModel: ComparingClothesViewModel
    @State private var chosenButtonClicked: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                if let image = viewModel.image {
                    ZoomableScrollView {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                        .frame(minWidth: 0, maxWidth: .infinity)
                    }
                } else {
                    Image(systemName: "photo.fill")
                        .resizable()
                        .scaledToFit()
                        .opacity(0.6)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding(.horizontal)
                }
                
                Button {
                    viewModel.predictClothingItem()
                    chosenButtonClicked = true
                } label: {
                    Text("Predict")
                }
                .padding(.top)
                .disabled(viewModel.image == nil)
                
                HStack {
                    Button {
                        viewModel.source = .camera
                        viewModel.showPhotoPicker()
                    } label: {
                        Text("Camera")
                    }
                    
                    Button {
                        viewModel.source = .library
                        viewModel.showPhotoPicker()
                    } label: {
                        Text("Photos")
                    }
                }
                .padding()
                
                Spacer()
            }
            .sheet(isPresented: $viewModel.showPicker) {
                ImagePicker(sourceType: viewModel.source == .library ? .photoLibrary : .camera, selectedImage: $viewModel.image)
                    .ignoresSafeArea()
            }
            .navigationTitle(chosenButtonClicked ? viewModel.classLabel: "My Images")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseClothesView()
            .environmentObject(ComparingClothesViewModel())
    }
}
