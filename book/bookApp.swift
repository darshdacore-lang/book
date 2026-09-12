import SwiftUI
import SwiftData

@main
struct ReadingAppApp: App {
    var body: some Scene {
        WindowGroup {
            InformationBookView()
        }
        .modelContainer(for: [Book.self, Page.self])
    }
}
