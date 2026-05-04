import SwiftUI

struct GroupGridCard: View {
    var group: ItemGroup

    private var previewItem: Item? {
        group.items
            .filter { $0.type == .image }
            .sorted { $0.createdAt > $1.createdAt }
            .first
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(LinearGradient.brandGradientSubtle)
                    .frame(height: 90)

                if let imageItem = previewItem {
                    AsyncBase64Image(base64String: imageItem.content)
                        .scaledToFill()
                        .frame(height: 90)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                } else {
                    Image(systemName: "folder.fill")
                        .font(.system(size: 32))
                        .foregroundStyle(LinearGradient.brandGradient)
                }
            }

            Text(group.name)
                .font(.headline)
                .foregroundStyle(.primary)
                .lineLimit(1)

            Text("\(group.items.count) item\(group.items.count == 1 ? "" : "s")")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .themedCard()
    }
}
