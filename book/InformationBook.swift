import SwiftUI
import SwiftData

// Using the SwiftData @Model defined in Models.swift
// Page and Book are provided by SwiftData models

struct InformationBookView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Page.createdAt, order: .forward) private var pages: [Page]

    @State private var selection: Page?
    @State private var isSaving: Bool = false

    var body: some View {
        NavigationStack {
            contentView
                .navigationTitle("Information Book")
                .toolbar { toolbarContent }
                .sheet(isPresented: $isSaving) {
                    SaveSheet()
                }
        }
        .onAppear {
            if selection == nil { selection = pages.first }
        }
    }

    @ViewBuilder
    private var contentView: some View {
        #if os(iOS)
        contentSplit
        #else
        contentSplit
        #endif
    }

    private var contentSplit: some View {
        HStack(spacing: 0) {
            List {
                Section("Pages") {
                    ForEach(pages) { page in
                        PageRow(page: page)
                            .contentShape(Rectangle())
                            .onTapGesture { selection = page }
                            .background(selection === page ? Color.accentColor.opacity(0.12) : Color.clear)
                            .contextMenu {
                                Button(role: .destructive) { delete(page) } label: {
                                    Label("Delete Page", systemImage: "trash")
                                }
                            }
                    }
                    .onDelete { indexSet in
                        delete(at: indexSet)
                    }
                }
            }
            .frame(minWidth: 260)

            Divider()

            Group {
                if let selected = selection ?? pages.first {
                    PageDetailView(page: selected)
                } else {
                    ContentPlaceholder()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarLeading) {
            Button {
                addPage()
            } label: {
                Label("Add Page", systemImage: "plus")
            }
            .keyboardShortcut("n", modifiers: [.command])
        }

        ToolbarItemGroup(placement: .topBarTrailing) {
            Button {
                isSaving = true
            } label: {
                Label("Save", systemImage: "square.and.arrow.down")
            }
            .disabled(pages.isEmpty)
        }
    }

    private func addPage() {
        let new = Page(title: "New Page", content: "Start writing...")
        modelContext.insert(new)
        selection = new
    }

    private func delete(at offsets: IndexSet) {
        for index in offsets {
            let page = pages[index]
            modelContext.delete(page)
        }
        selection = pages.first
    }

    private func delete(_ page: Page) {
        modelContext.delete(page)
        selection = pages.first
    }
}

private struct PageDetailView: View {
    @Bindable var page: Page

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            TextField("Page Title", text: $page.title)
                .font(.title2)
                .textFieldStyle(.roundedBorder)

            TextEditor(text: $page.content)
                .font(.body)
                .scrollContentBackground(.hidden)
                .padding(8)
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))

            Spacer()
        }
        .padding()
        .navigationTitle(page.title.isEmpty ? "Untitled" : page.title)
    }
}

private struct PageRow: View {
    @Bindable var page: Page

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            TextField("Title", text: $page.title)
                .font(.headline)
            Text(page.content)
                .font(.subheadline)
                .lineLimit(1)
                .foregroundStyle(.secondary)
        }
    }
}

private struct ContentPlaceholder: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "book")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("Select or add a page to begin")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct SaveSheet: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("Your changes are saved automatically with SwiftData. No manual save is required.")
                Button("Close") { dismiss() }
                    .buttonStyle(.borderedProminent)
                    .padding(.top, 8)
                Spacer()
            }
            .padding()
            .navigationTitle("Save Book")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    InformationBookView()
        .modelContainer(for: [Book.self, Page.self], inMemory: true)
}
