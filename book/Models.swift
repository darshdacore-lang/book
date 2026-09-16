import Foundation
import SwiftData

@Model
final class Notebook {
    var name: String
    @Relationship(deleteRule: .cascade) var pages: [Page] = []
    var createdAt: Date

    init(name: String, createdAt: Date = .now) {
        self.name = name
        self.createdAt = createdAt
    }
}

@Model
final class Page {
    var title: String
    var content: String
    var createdAt: Date
    var notebook: Notebook?

    init(title: String, content: String, createdAt: Date = .now, notebook: Notebook? = nil) {
        self.title = title
        self.content = content
        self.createdAt = createdAt
        self.notebook = notebook
    }
}
