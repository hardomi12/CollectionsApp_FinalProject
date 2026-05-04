import SwiftUI

struct NoteDetailView: View {
    var item: Item

    @FocusState private var focusedField: NoteField?

    enum NoteField {
        case title, body
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                TextField("Title", text: Binding(
                    get: { item.title },
                    set: { item.title = $0 }
                ))
                .font(.title2.weight(.semibold))
                .focused($focusedField, equals: .title)
                .submitLabel(.next)
                .onSubmit {
                    focusedField = .body
                }

                Divider()
                    .overlay(Color.brandPurple.opacity(0.3))

                TextField("Write a note...", text: Binding(
                    get: { item.content },
                    set: { item.content = $0 }
                ), axis: .vertical)
                .font(.body)
                .focused($focusedField, equals: .body)
                .lineLimit(1...)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(LinearGradient.brandGradientSubtle.ignoresSafeArea())
        .navigationTitle(item.title.isEmpty ? "Note" : item.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                HStack {
                    Spacer()
                    Button("Done") {
                        focusedField = nil
                    }
                    .foregroundStyle(Color.brandPurple)
                }
            }
        }
        .scrollDismissesKeyboard(.interactively)
    }
}
