import SwiftUI

struct ItemRowView: View {
    var item: Item
    var onEdit: () -> Void
    var onDelete: () -> Void
    var onMove: () -> Void

    @State private var viewingImage: UIImage? = nil

    var body: some View {
        switch item.type {

        case .text:
            HStack(spacing: 12) {
                IconBadge(systemName: "text.quote", color: .brandPurple)
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title.isEmpty ? "Untitled" : item.title)
                        .font(.headline)
                    Text(item.content.isEmpty ? "No additional text" : item.content)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
            }
            .padding(.vertical, 4)
            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                Button(role: .destructive) { onDelete() } label: {
                    Label("Delete", systemImage: "trash")
                }
                Button { onEdit() } label: {
                    Label("Edit", systemImage: "pencil")
                }
                .tint(.brandPurple)
                Button { onMove() } label: {
                    Label("Move", systemImage: "folder")
                }
                .tint(.brandBlue)
            }

        case .link:
            HStack(spacing: 12) {
                IconBadge(systemName: "link", color: .brandBlue)
                VStack(alignment: .leading, spacing: 4) {
                    if let label = item.label, !label.isEmpty {
                        Text(label).font(.headline)
                    }
                    Link(
                        item.content,
                        destination: URL(string: item.content) ?? URL(string: "https://apple.com")!
                    )
                    .font(.subheadline)
                    .foregroundStyle(Color.brandBlue)
                    .lineLimit(1)
                }
            }
            .padding(.vertical, 4)
            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                Button(role: .destructive) { onDelete() } label: {
                    Label("Delete", systemImage: "trash")
                }
                Button { onEdit() } label: {
                    Label("Edit", systemImage: "pencil")
                }
                .tint(.brandPurple)
                Button { onMove() } label: {
                    Label("Move", systemImage: "folder")
                }
                .tint(.brandBlue)
            }

        case .image:
            VStack(alignment: .leading, spacing: 4) {
                Label("Image", systemImage: "photo")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                AsyncBase64Image(base64String: item.content)
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 180)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .onTapGesture {
                        Task.detached(priority: .userInitiated) {
                            let content = item.content
                            guard let data = Data(base64Encoded: content),
                                  let image = UIImage(data: data) else { return }
                            await MainActor.run { viewingImage = image }
                        }
                    }
            }
            .padding(.vertical, 4)
            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                Button(role: .destructive) { onDelete() } label: {
                    Label("Delete", systemImage: "trash")
                }
                Button { onMove() } label: {
                    Label("Move", systemImage: "folder")
                }
                .tint(.brandBlue)
            }
            .fullScreenCover(item: $viewingImage) { image in
                ImageViewerView(uiImage: image)
            }
        }
    }
}
