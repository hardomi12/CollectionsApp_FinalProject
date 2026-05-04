import SwiftUI
import SwiftData

enum LayoutMode {
    case list, grid
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var groups: [ItemGroup]
    @State private var showingAddGroup = false
    @State private var layoutMode: LayoutMode = .list

    var columns: [GridItem] {
        [GridItem(.flexible()), GridItem(.flexible())]
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Group {
                    if layoutMode == .list {
                        List {
                            ForEach(groups) { group in
                                NavigationLink(destination: ItemsView(group: group)) {
                                    ThemedGroupRow(group: group)
                                }
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                            }
                            .onDelete(perform: deleteGroups)
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                    } else {
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(groups) { group in
                                    NavigationLink(destination: ItemsView(group: group)) {
                                        GroupGridCard(group: group)
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                }
                .background(LinearGradient.brandGradientSubtle.ignoresSafeArea())
            }
            .navigationTitle("My Collections")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddGroup = true
                    } label: {
                        Image(systemName: "plus")
                            .fontWeight(.semibold)
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
            .sheet(isPresented: $showingAddGroup) {
                AddGroupView(isPresented: $showingAddGroup)
            }
        }
    }

    private func deleteGroups(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(groups[index])
        }
    }
}

// Themed list row for a group
struct ThemedGroupRow: View {
    var group: ItemGroup

    var body: some View {
        HStack(spacing: 14) {
            IconBadge(systemName: "folder.fill", color: .brandPurple)
            VStack(alignment: .leading, spacing: 2) {
                Text(group.name)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text("\(group.items.count) item\(group.items.count == 1 ? "" : "s") · \(group.createdAt.formatted(date: .abbreviated, time: .omitted))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(12)
        .themedCard()
    }
}

#Preview {
    ContentView()
}  
