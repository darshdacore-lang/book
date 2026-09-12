import SwiftUI

struct AddBookView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var author = ""
    @State private var totalPages = ""
    @State private var pagesRead = ""

    let onAdd: (Book) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("Book Information") {
                    TextField("Title", text: $title)

                    TextField("Author", text: $author)

                    TextField("Total Pages", text: $totalPages)
                        .keyboardType(.numberPad)

                    TextField("Pages Read", text: $pagesRead)
                        .keyboardType(.numberPad)
                }
            }
            .navigationTitle("Add Book")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        addBook()
                    }
                    .disabled(
                        title.isEmpty ||
                        author.isEmpty ||
                        Int(totalPages) == nil
                    )
                }
            }
        }
    }

    private func addBook() {
        guard let totalPages = Int(totalPages) else { return }

        let pagesRead = Int(pagesRead) ?? 0

        let book = Book(
            title: title,
            author: author,
            totalPages: totalPages,
            pagesRead: pagesRead
        )

        onAdd(book)
        dismiss()
    }
}
