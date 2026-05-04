import SwiftUI

struct ItemGridCard: View {
    var item: Item
    var onEdit: () -> Void
    var onDelete: () -> Void
    var onMove: () -> Void
    var onNoteSelected: (Item) -> Void

    @State private var viewingImage: UIImage? = nil

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                switch item.type {
                case .text:
                    textCard
                        .onTapGesture { onNoteSelected(item) }
                case .link:
                    linkCard
                case .image:
                    imageCard
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .clipped()
        }
        .aspectRatio(1, contentMode: .fit)
        .contextMenu {
            if item.type != .image {
                Button { onEdit() } label: {
                    Label("Edit", systemImage: "pencil")
                }
            }
            Button { onMove() } label: {
                Label("Move to Collection", systemImage: "folder")
            }
            Button(role: .destructive) { onDelete() } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .fullScreenCover(item: $viewingImage) { image in
            ImageViewerView(uiImage: image)
        }
    }

    private var textCard: some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(systemName: "text.quote")
                .font(.system(size: 18))
                .foregroundStyle(Color.brandPurple)
            Spacer()
            Text(item.title.isEmpty ? "Untitled" : item.title)
                .font(.headline)
                .foregroundStyle(.primary)
                .lineLimit(1)
            Text(item.content.isEmpty ? "No text" : item.content)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
        .padding(12)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(Color.white)
    }

    private var linkCard: some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(systemName: "link")
                .font(.system(size: 18))
                .foregroundStyle(Color.brandBlue)
            Spacer()
            if let label = item.label, !label.isEmpty {
                Text(label)
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .lineLimit(1)
            }
            Text(item.content)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
        .padding(12)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(Color.white)
        .onTapGesture {
            if let url = URL(string: item.content) {
                UIApplication.shared.open(url)
            }
        }
    }

    private var imageCard: some View {
        let contentString = item.content
        return AsyncBase64Image(base64String: contentString)
            .scaledToFill()
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .clipped()
            .onTapGesture {
                Task.detached(priority: .userInitiated) {
                    guard let data = Data(base64Encoded: contentString),
                          let image = UIImage(data: data) else { return }
                    await MainActor.run { viewingImage = image }
                }
            }
    }
}
