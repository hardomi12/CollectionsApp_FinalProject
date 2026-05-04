//
//  MoveItemSheet.swift
//  CollectionsApp
//
//  Created by Dominguez, Harley on 5/4/26.
//


import SwiftUI
import SwiftData

struct MoveItemSheet: View {
    var item: Item
    var currentGroup: ItemGroup
    var onMove: (ItemGroup) -> Void

    @Environment(\.dismiss) private var dismiss
    @Query private var allGroups: [ItemGroup]

    var availableGroups: [ItemGroup] {
        allGroups.filter { $0.id != currentGroup.id }
    }

    var body: some View {
        NavigationStack {
            Group {
                if availableGroups.isEmpty {
                    ContentUnavailableView(
                        "No Other Collections",
                        systemImage: "folder.badge.questionmark",
                        description: Text("Create another collection first to move this item.")
                    )
                } else {
                    List {
                        ForEach(availableGroups) { group in
                            Button {
                                onMove(group)
                                dismiss()
                            } label: {
                                HStack(spacing: 14) {
                                    IconBadge(systemName: "folder.fill", color: .brandPurple)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(group.name)
                                            .font(.headline)
                                            .foregroundStyle(.primary)
                                        Text("\(group.items.count) item\(group.items.count == 1 ? "" : "s")")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                        .foregroundStyle(.tertiary)
                                }
                            }
                            .listRowBackground(Color.cardBackground)
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
            .background(LinearGradient.brandGradientSubtle.ignoresSafeArea())
            .navigationTitle("Move To")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(Color.brandPurple)
                }
            }
        }
    }
}