import Foundation

struct Habit: Codable, Identifiable {
    var id = UUID()
    var name: String
}

class HabitViewModel: ObservableObject {
    @Published var habits: [Habit] = [] {
        didSet {
            saveHabits()
        }
    }

    init() {
        loadHabits()
    }

    func addHabit(name: String) {
        let newHabit = Habit(name: name)
        habits.append(newHabit)
    }

    private func saveHabits() {
        if let encoded = try? JSONEncoder().encode(habits) {
            UserDefaults.standard.set(encoded, forKey: "habits")
        }
    }

    private func loadHabits() {
        if let savedData = UserDefaults.standard.data(forKey: "habits"),
           let decoded = try? JSONDecoder().decode([Habit].self, from: savedData) {
            habits = decoded
        }
    }
}