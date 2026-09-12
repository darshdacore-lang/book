import SwiftUI

struct ContentView: View {
    @State private var books: [Book] = [
        Book(title: "The Hobbit", author: "J.R.R. Tolkien", totalPages: 310, pagesRead: 150),
        Book(title: "1984", author: "George Orwell", totalPages: 328, pagesRead: 328),
        Book(title: "Dune", author: "Frank Herbert", totalPages: 412, pagesRead: 45)
    ]

    @State private var showAddBook = false

    var body: some View {
        NavigationStack {
            List($books) { $book in
                NavigationLink {
                    BookDetailView(book: book)
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(book.title)
                                .font(.headline)

                            Text(book.author)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }

                        Spacer()

                        if book.isCompleted {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundColor(.green)
                        } else {
                            Text("\(book.pagesRead)/\(book.totalPages) pgs")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .navigationTitle("My Library 📚")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddBook = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddBook) {
                AddBookView { newBook in
                    books.append(newBook)
                }
            }
        }
    }
}
