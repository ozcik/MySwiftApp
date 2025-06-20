import Foundation

struct YearMilestone: Identifiable {
    let id = UUID()
    let label: String
    let desc: String
    let icon: String
    let achieved: Bool
}

struct MonthAchievement: Identifiable {
    let id = UUID()
    let label: String
    let desc: String
    let icon: String
    let achieved: Bool
}

struct ProgressLogic {
    static func generateMilestones(progress: Double) -> [YearMilestone] {
        return [
            YearMilestone(label: "Quarterly Achiever",
                          desc: "Yılın %25’ini tamamladın",
                          icon: "🏅",
                          achieved: progress >= 0.25),
            YearMilestone(label: "Halfway Hero",
                          desc: "Yılın %50’sini tamamladın",
                          icon: "🥈",
                          achieved: progress >= 0.5),
            YearMilestone(label: "Three-Quarter Star",
                          desc: "Yılın %75’ini tamamladın",
                          icon: "🥇",
                          achieved: progress >= 0.75),
            YearMilestone(label: "Year Champion",
                          desc: "Tüm yılı tamamladın",
                          icon: "🏆",
                          achieved: progress >= 1.0)
        ]
    }

    static func generateMonthAchievements(markedDays: Set<Date>, year: Int) -> [MonthAchievement] {
        let calendar = Calendar.current
        var achievements: [MonthAchievement] = []

        for month in 1...12 {
            guard let range = calendar.range(of: .day, in: .month, for: calendar.date(from: DateComponents(year: year, month: month))!) else { continue }

            var allDaysMarked = true

            for day in range {
                let components = DateComponents(year: year, month: month, day: day)
                guard let date = calendar.date(from: components) else { continue }
                if !markedDays.contains(where: { calendar.isDate($0, inSameDayAs: date) }) {
                    allDaysMarked = false
                    break
                }
            }

            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "tr_TR")
            let monthName = formatter.monthSymbols[month - 1].capitalized

            achievements.append(
                MonthAchievement(
                    label: "\(monthName) Tamamlandı",
                    desc: "\(monthName) ayındaki tüm günler işaretlendi",
                    icon: "📅",
                    achieved: allDaysMarked
                )
            )
        }

        return achievements
    }
}
