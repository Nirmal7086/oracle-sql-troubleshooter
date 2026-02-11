import Foundation

class TodoStore: ObservableObject {
    @Published var items: [TodoItem] = [] {
        didSet { save() }
    }

    private let storageKey = "minimal_todo_items"

    init() {
        load()
    }

    func add(_ title: String) {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        items.insert(TodoItem(title: trimmed), at: 0)
    }

    func toggle(_ item: TodoItem) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[index].isCompleted.toggle()
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }

    func deleteCompleted() {
        items.removeAll { $0.isCompleted }
    }

    var pendingCount: Int {
        items.filter { !$0.isCompleted }.count
    }

    var completedCount: Int {
        items.filter { $0.isCompleted }.count
    }

    // MARK: - Persistence

    private func save() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([TodoItem].self, from: data) else { return }
        items = decoded
    }
}
