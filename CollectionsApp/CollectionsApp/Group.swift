//
//  ItemGroup.swift
//  CollectionsApp
//
//  Created by Dominguez, Harley on 4/13/26.
//


import SwiftData
import Foundation

@Model
class ItemGroup {
    var id: UUID
    var name: String
    var createdAt: Date
    @Relationship(deleteRule: .cascade) var items: [Item] = []

    init(name: String) {
        self.id = UUID()
        self.name = name
        self.createdAt = Date()
    }
}
