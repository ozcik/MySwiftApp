import SwiftUI
import Combine

// Tarihin sadece yıl-ay-gün kısmını alır, zamanı sıfırlar.
extension Date {
    func strippedTime() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        return calendar.date(from: components)!
    }
}

class AppData: ObservableObject {
    // Tam tarih (yıl, ay, gün, zaman sıfırlı) ve emoji eşleşmesi
    @Published private(set) var markedDays: [Date: String] = [:]

    private let saveKey = "markedDays"
    private var calendar: Calendar {
        var cal = Calendar.current
        cal.timeZone = TimeZone(secondsFromGMT: 0)! // UTC tutarlılığı için
        return cal
    }

    init() {
        loadMarkedDays()
    }

    // MARK: - Public Methods

    func addMark(for date: Date, emoji: String) {
        let key = date.strippedTime()
        var copy = markedDays
        copy[key] = emoji
        markedDays = copy
        saveMarkedDays()
    }

    func removeMark(for date: Date) {
        let key = date.strippedTime()
        var copy = markedDays
        copy.removeValue(forKey: key)
        markedDays = copy
        saveMarkedDays()
    }

    func toggleMark(for date: Date, emoji: String) {
        let key = date.strippedTime()
        if markedDays.keys.contains(key) {
            removeMark(for: date)
        } else {
            addMark(for: date, emoji: emoji)
        }
    }

    // MARK: - Persistence

    private func saveMarkedDays() {
        do {
            let data = try JSONEncoder().encode(markedDays)
            UserDefaults.standard.set(data, forKey: saveKey)
        } catch {
            print("Error saving markedDays:", error)
        }
    }

    private func loadMarkedDays() {
        guard let data = UserDefaults.standard.data(forKey: saveKey) else { return }
        do {
            let loaded = try JSONDecoder().decode([Date: String].self, from: data)
            markedDays = loaded
        } catch {
            print("Error loading markedDays:", error)
        }
    }

    // MARK: - İstatistikler

    // Mevcut yıl içindeki işaretli günler (Date olarak)
    func markedDaysInCurrentYear() -> Set<Date> {
        let currentYear = calendar.component(.year, from: Date())
        return Set(markedDays.keys.filter { calendar.component(.year, from: $0) == currentYear })
    }

    // Yıl gözetmeden, ay-gün kombinasyonlarının seti (ör: "03-15")
    func markedDayMonthCombinations() -> Set<String> {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd"
        return Set(markedDays.keys.map { formatter.string(from: $0) })
    }

    // Seçilen yıl için ay bazında işaretlenen gün sayısı (1-12 ay)
    func markedCountsPerMonth(forYear year: Int) -> [Int: Int] {
        var counts: [Int: Int] = [:]

        for (date, _) in markedDays {
            let components = calendar.dateComponents([.year, .month], from: date)
            if components.year == year, let month = components.month {
                counts[month, default: 0] += 1
            }
        }

        // 1'den 12'ye tüm aylar için değer atama, olmayan aylar 0
        for month in 1...12 {
            counts[month] = counts[month] ?? 0
        }

        return counts
    }
}
