import Foundation
import SwiftData

@Model
class Book {
    var title: String
    var author: String
    var totalPages: Int
    var pagesRead: Int

    init(title: String, author: String, totalPages: Int, pagesRead: Int = 0) {
        self.title = title
        self.author = author
        self.totalPages = totalPages
        self.pagesRead = pagesRead
    }

    var isCompleted: Bool {
        pagesRead >= totalPages
    }
}
