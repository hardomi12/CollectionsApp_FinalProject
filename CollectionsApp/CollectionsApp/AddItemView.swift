import SwiftUI
import SwiftData
import PhotosUI

struct AddItemView: View {
    var group: ItemGroup
    var editingItem: Item?

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var titleContent = ""
    @State private var labelContent = ""
    @State private var selectedType: ItemType
    @State private var textContent: String
    @State private var linkContent: String
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var imageData: Data?

    init(group: ItemGroup, editingItem: Item? = nil) {
        self.group = group
        self.editingItem = editingItem

        let type = editingItem?.type ?? .text
        _selectedType = State(initialValue: type)
        _titleContent = State(initialValue: editingItem?.title ?? "")
        _labelContent = State(initialValue: editingItem?.label ?? "")

        if type == .text {
            _textContent = State(initialValue: editingItem?.content ?? "")
            _linkContent = State(initialValue: "")
        } else if type == .link {
            _textContent = State(initialValue: "")
            _linkContent = State(initialValue: editingItem?.content ?? "")
        } else {
            _textContent = State(initialValue: "")
            _linkContent = State(initialValue: "")
        }

        // Initialize preview image if editing an existing image item
        let existingImageData: Data? = (type == .image) ? Data(base64Encoded: editingItem?.content ?? "") : nil
        _imageData = State(initialValue: existingImageData)
    }

    var isEditing: Bool { editingItem != nil }

    var body: some View {
        NavigationStack {
            Form {
                Section("Type") {
                    Picker("Item type", selection: $selectedType) {
                        Label("Note", systemImage: "text.quote").tag(ItemType.text)
                        Label("Link", systemImage: "link").tag(ItemType.link)
                        Label("Image", systemImage: "photo").tag(ItemType.image)
                    }
                    .pickerStyle(.segmented)
                    .disabled(isEditing)
                }

                Section("Content") {
                    switch selectedType {
                    case .text:
                        TextField("Title", text: $titleContent).font(.headline)
                        Divider()
                        TextField("Write a note...", text: $textContent, axis: .vertical).lineLimit(4...8)
                    case .link:
                        TextField("Label (e.g. My Favorite Site)", text: $labelContent)
                        Divider()
                        TextField("https://", text: $linkContent)
                            .keyboardType(.URL)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                    case .image:
                        imagePickerSection
                    }
                }
            }
            .navigationTitle(isEditing ? "Edit Item" : "Add Item")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { Task { await saveItem(); dismiss() } }.disabled(!canSave)
                }
            }
        }
    }

    private var imagePickerSection: some View {
        VStack(alignment: .leading) {
            PhotosPicker(
                selection: isEditing ? Binding(get: { selectedPhotos.first.map { [$0] } ?? [] }, set: { selectedPhotos = $0 }) : $selectedPhotos,
                maxSelectionCount: isEditing ? 1 : 10,
                matching: .images
            ) {
                Label(isEditing ? "Change photo" : (selectedPhotos.isEmpty ? "Choose photos" : "\(selectedPhotos.count) selected"), systemImage: "photo.badge.plus")
            }
            .onChange(of: selectedPhotos) {
                Task {
                    if let first = selectedPhotos.first, let data = try? await first.loadTransferable(type: Data.self) {
                        imageData = data
                    }
                }
            }
            if let data = imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage).resizable().scaledToFit().frame(maxHeight: 200).clipShape(RoundedRectangle(cornerRadius: 10)).padding(.top, 8)
            }
        }
    }

    private var canSave: Bool {
        switch selectedType {
        case .text: return !titleContent.isEmpty
        case .link: return !linkContent.isEmpty
        case .image: return imageData != nil || !selectedPhotos.isEmpty
        }
    }

    private func saveItem() async {
        switch selectedType {
        case .text:
            if let existing = editingItem {
                existing.content = textContent
                existing.title = titleContent
            } else {
                let newItem = Item(type: .text, title: titleContent, content: textContent, group: group)
                modelContext.insert(newItem)
            }
        case .link:
            if let existing = editingItem {
                existing.content = linkContent
                existing.label = labelContent
            } else {
                let newItem = Item(type: .link, label: labelContent, content: linkContent, group: group)
                modelContext.insert(newItem)
            }
        case .image:
            if let existing = editingItem {
                if let data = imageData { existing.content = data.base64EncodedString() }
            } else {
                for photo in selectedPhotos {
                    if let data = try? await photo.loadTransferable(type: Data.self) {
                        let newItem = Item(type: .image, content: data.base64EncodedString(), group: group)
                        modelContext.insert(newItem)
                    }
                }
            }
        }
        //try? modelContext.save() // Force UI update[cite: 16]
        //claude recommends that I can remove this due to an autosave
    }
}
