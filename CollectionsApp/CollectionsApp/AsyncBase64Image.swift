import SwiftUI

struct AsyncBase64Image: View {
    let base64String: String
    var onImageDecoded: ((UIImage) -> Void)? = nil

    @State private var uiImage: UIImage? = nil

    var body: some View {
        Group {
            if let image = uiImage {
                Image(uiImage: image)
                    .resizable()
            } else {
                Color.gray.opacity(0.1)
                    .overlay(ProgressView().controlSize(.small))
            }
        }
        .onAppear { decodeImage() }
        .onChange(of: base64String) { decodeImage() }
    }

    private func decodeImage() {
        Task.detached(priority: .userInitiated) {
            guard let data = Data(base64Encoded: base64String),
                  let decoded = UIImage(data: data) else { return }
            await MainActor.run {
                self.uiImage = decoded
                // Only call the callback if the caller explicitly provided one
                // This does NOT automatically trigger fullScreenCover
                self.onImageDecoded?(decoded)
            }
        }
    }
}
