// Items.swift

import SwiftData
import Foundation

enum ItemType: String, Codable {
    case text
    case link
    case image
}

@Model
class Item {
    var id: UUID
    var type: ItemType
    var title: String
    var label: String? // Changed to optional to support migrations
    var content: String
    var createdAt: Date
    var group: ItemGroup?

    init(type: ItemType, title: String = "", label: String? = nil, content: String, group: ItemGroup? = nil) {
        self.id = UUID()
        self.type = type
        self.title = title
        self.label = label
        self.content = content
        self.createdAt = Date()
        self.group = group
    }
}
