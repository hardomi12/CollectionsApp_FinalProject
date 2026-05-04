//
//  AddGroupView.swift
//  CollectionsApp
//
//  Created by Dominguez, Harley on 4/13/26.
//


import SwiftUI
import SwiftData

struct AddGroupView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var isPresented: Bool
    @State private var groupName = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Group name") {
                    TextField("e.g. Travel Inspiration", text: $groupName)
                }
            }
            .navigationTitle("New Group")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let newGroup = ItemGroup(name: groupName)
                        modelContext.insert(newGroup)
                        isPresented = false
                    }
                    .disabled(groupName.isEmpty)
                }
            }
        }
    }
}