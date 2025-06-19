import Foundation

struct RecurringEmojiDay: Identifiable, Hashable, Codable {
    var id = UUID()
    var day: Int
    var month: Int
    var emoji: String
}
