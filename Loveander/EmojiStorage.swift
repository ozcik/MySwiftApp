import Foundation
import Combine

class EmojiStorage: ObservableObject {
    @Published var emojiDays: [RecurringEmojiDay] = []
    
    private let key = "emojiDaysKey"
    
    init() {
        load()
    }
    
    func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let saved = try? JSONDecoder().decode([RecurringEmojiDay].self, from: data) else {
            emojiDays = []
            return
        }
        emojiDays = saved
    }
    
    func save() {
        if let data = try? JSONEncoder().encode(emojiDays) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    func addOrUpdate(_ item: RecurringEmojiDay) {
        if let index = emojiDays.firstIndex(where: { $0.day == item.day && $0.month == item.month }) {
            emojiDays[index] = item
        } else {
            emojiDays.append(item)
        }
        save()
    }
    
    func remove(day: Int, month: Int) {
        emojiDays.removeAll(where: { $0.day == day && $0.month == month })
        save()
    }
    
    func emoji(for day: Int, month: Int) -> String? {
        emojiDays.first(where: { $0.day == day && $0.month == month })?.emoji
    }
}
