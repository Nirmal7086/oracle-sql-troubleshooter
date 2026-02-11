import SwiftUI

struct TodoRowView: View {
    let item: TodoItem
    let onToggle: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            Button(action: onToggle) {
                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(item.isCompleted ? .secondary : .primary)
            }
            .buttonStyle(.plain)

            Text(item.title)
                .font(.body)
                .strikethrough(item.isCompleted)
                .foregroundStyle(item.isCompleted ? .secondary : .primary)
                .lineLimit(2)

            Spacer()
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .onTapGesture(perform: onToggle)
    }
}

#Preview {
    VStack {
        TodoRowView(item: TodoItem(title: "Buy groceries"), onToggle: {})
        TodoRowView(item: TodoItem(title: "Read a book", isCompleted: true), onToggle: {})
    }
    .padding()
}
