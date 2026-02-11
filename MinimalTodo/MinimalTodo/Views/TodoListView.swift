import SwiftUI

struct TodoListView: View {
    @EnvironmentObject var store: TodoStore
    @State private var newTodoText = ""
    @FocusState private var isInputFocused: Bool

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                inputBar
                todoList
            }
            .navigationTitle("Todo")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if store.completedCount > 0 {
                        Button("Clear Done") {
                            withAnimation {
                                store.deleteCompleted()
                            }
                        }
                        .font(.subheadline)
                    }
                }
            }
        }
    }

    // MARK: - Input Bar

    private var inputBar: some View {
        HStack(spacing: 12) {
            TextField("What needs to be done?", text: $newTodoText)
                .textFieldStyle(.plain)
                .font(.body)
                .padding(.vertical, 12)
                .focused($isInputFocused)
                .onSubmit(addTodo)

            if !newTodoText.isEmpty {
                Button(action: addTodo) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.primary)
                }
            }
        }
        .padding(.horizontal, 20)
        .background(Color(.systemBackground))
        .overlay(
            Divider(), alignment: .bottom
        )
    }

    // MARK: - Todo List

    private var todoList: some View {
        Group {
            if store.items.isEmpty {
                emptyState
            } else {
                List {
                    ForEach(store.items) { item in
                        TodoRowView(item: item) {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                store.toggle(item)
                            }
                        }
                        .listRowInsets(EdgeInsets(top: 4, leading: 20, bottom: 4, trailing: 20))
                        .listRowSeparator(.hidden)
                    }
                    .onDelete(perform: store.delete)

                    if !store.items.isEmpty {
                        footerInfo
                            .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
            }
        }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: 12) {
            Spacer()
            Image(systemName: "checkmark.circle")
                .font(.system(size: 48, weight: .thin))
                .foregroundStyle(.secondary)
            Text("No todos yet")
                .font(.headline)
                .foregroundStyle(.secondary)
            Text("Add one above to get started")
                .font(.subheadline)
                .foregroundStyle(.tertiary)
            Spacer()
        }
    }

    // MARK: - Footer

    private var footerInfo: some View {
        HStack {
            Text("\(store.pendingCount) remaining")
                .font(.caption)
                .foregroundStyle(.secondary)
            Spacer()
            Text("\(store.items.count) total")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 8)
    }

    // MARK: - Actions

    private func addTodo() {
        let text = newTodoText
        newTodoText = ""
        withAnimation {
            store.add(text)
        }
    }
}

#Preview {
    TodoListView()
        .environmentObject(TodoStore())
}
