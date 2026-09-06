import SwiftUI
import SwiftData

struct BookDetailView: View {
    // @Bindable allows automatic, real-time SwiftData synchronization when properties change
    @Bindable var book: Book

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Book Info Header
                VStack(spacing: 8) {
                    Image(systemName: "book.closed.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.accentColor)
                        .padding()
                        .background(Color.accentColor.opacity(0.1))
                        .clipShape(Circle())
                    
                    Text(book.title)
                        .font(.title)
                        .bold()
                        .multilineTextAlignment(.center)

                    Text("by \(book.author)")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .padding(.top)

                // Progress Bar & Percentage
                VStack(spacing: 8) {
                    ProgressView(value: Double(book.pagesRead), total: Double(max(book.totalPages, 1))) {
                        HStack {
                            Text("Reading Progress")
                                .font(.headline)
                            Spacer()
                            Text("\(progressPercentage)%")
                                .font(.headline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .tint(book.isCompleted ? .green : .accentColor)

                    if book.isCompleted {
                        Label("Completed!", systemImage: "checkmark.circle.fill")
                            .font(.subheadline)
                            .foregroundColor(.green)
                            .padding(.top, 4)
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)

                // Page Control Section
                VStack(spacing: 16) {
                    Text("Current Page: \(book.pagesRead) of \(book.totalPages)")
                        .font(.headline)

                    // Slider Control
                    Slider(
                        value: Binding(
                            get: { Double(book.pagesRead) },
                            set: { book.pagesRead = Int($0) }
                        ),
                        in: 0...Double(max(book.totalPages, 1)),
                        step: 1
                    )

                    // Quick Stepper Buttons (-10 / +10 pages)
                    HStack(spacing: 20) {
                        Button(action: {
                            book.pagesRead = max(0, book.pagesRead - 10)
                        }) {
                            Label("10 pgs", systemImage: "minus.circle")
                        }
                        .disabled(book.pagesRead == 0)

                        Spacer()

                        Button(action: {
                            book.pagesRead = min(book.totalPages, book.pagesRead + 10)
                        }) {
                            Label("10 pgs", systemImage: "plus.circle")
                        }
                        .disabled(book.pagesRead >= book.totalPages)
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Reading Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    // Helper to calculate progress percentage
    private var progressPercentage: Int {
        guard book.totalPages > 0 else { return 0 }
        let percentage = (Double(book.pagesRead) / Double(book.totalPages)) * 100
        return Int(percentage)
    }
}
