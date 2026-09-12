import Foundation
import SwiftData

@Model
final class Book {
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
    var book: Book?

    init(title: String, content: String, createdAt: Date = .now, book: Book? = nil) {
        self.title = title
        self.content = content
        self.createdAt = createdAt
        self.book = book
    }
}
