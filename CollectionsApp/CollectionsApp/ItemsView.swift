import SwiftUI
import SwiftData

struct ItemsView: View {
    var group: ItemGroup
    @Environment(\.modelContext) private var modelContext
    @Query private var allGroups: [ItemGroup]

    @State private var showingAddItem = false
    @State private var itemToEdit: Item? = nil
    @State private var itemToMove: Item? = nil
    @State private var layoutMode: LayoutMode = .list
    @State private var selectedNote: Item? = nil

    var sortedItems: [Item] {
        group.items.sorted { $0.createdAt > $1.createdAt }
    }

    var columns: [GridItem] {
        [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)]
    }

    var body: some View {
        Group {
            if layoutMode == .list {
                List {
                    ForEach(sortedItems) { item in
                        if item.type == .text {
                            Button {
                                selectedNote = item
                            } label: {
                                ItemRowView(
                                    item: item,
                                    onEdit: { itemToEdit = item },
                                    onDelete: { modelContext.delete(item) },
                                    onMove: { itemToMove = item }
                                )
                            }
                            .buttonStyle(.plain)
                        } else {
                            ItemRowView(
                                item: item,
                                onEdit: {
                                    if item.type != .image { itemToEdit = item }
                                },
                                onDelete: { modelContext.delete(item) },
                                onMove: { itemToMove = item }
                            )
                        }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(sortedItems) { item in
                            ItemGridCard(
                                item: item,
                                onEdit: {
                                    if item.type != .image { itemToEdit = item }
                                },
                                onDelete: { modelContext.delete(item) },
                                onMove: { itemToMove = item },
                                onNoteSelected: { selectedNote = $0 }
                            )
                        }
                    }
                    .padding()
                }
            }
        }
        .background(LinearGradient.brandGradientSubtle.ignoresSafeArea())
        .navigationTitle(group.name)
        .navigationDestination(item: $selectedNote) { item in
            NoteDetailView(item: item)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button { showingAddItem = true } label: {
                    Image(systemName: "plus")
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    layoutMode = layoutMode == .list ? .grid : .list
                } label: {
                    Image(systemName: layoutMode == .list ? "square.grid.2x2" : "list.bullet")
                }
            }
        }
        .sheet(isPresented: $showingAddItem) {
            AddItemView(group: group)
        }
        .sheet(item: $itemToEdit) { item in
            AddItemView(group: group, editingItem: item)
        }
        .sheet(item: $itemToMove) { item in
            MoveItemSheet(item: item, currentGroup: group) { destination in
                moveItem(item, to: destination)
            }
        }
    }

    private func moveItem(_ item: Item, to destination: ItemGroup) {
        // Remove from current group
        group.items.removeAll { $0.id == item.id }
        // Add to destination group
        item.group = destination
        destination.items.append(item)
    }
}
