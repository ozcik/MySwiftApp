import Foundation

struct Habit: Identifiable, Equatable, Codable {
    let id: UUID
    var name: String
    var emoji: String
    var isCompleted: Bool

    init(id: UUID = UUID(), name: String, emoji: String, isCompleted: Bool) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.isCompleted = isCompleted
    }
}