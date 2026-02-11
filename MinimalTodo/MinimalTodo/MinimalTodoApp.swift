import SwiftUI

@main
struct MinimalTodoApp: App {
    @StateObject private var todoStore = TodoStore()

    var body: some Scene {
        WindowGroup {
            TodoListView()
                .environmentObject(todoStore)
        }
    }
}
