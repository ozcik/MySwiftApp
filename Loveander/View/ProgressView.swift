import SwiftUI
import Charts

struct ProgressView: View {
    @EnvironmentObject var appData: AppData
    
    @State private var habits: [Habit] = [
        Habit(name: "Egzersiz yap", emoji: "🏃‍♂️", isCompleted: true),
        Habit(name: "Kitap oku", emoji: "📚", isCompleted: false),
        Habit(name: "Su iç (2L)", emoji: "💧", isCompleted: false)
    ]
    
    @State private var showYearlyDetail = false
    @State private var showTimelessDetail = false
    @State private var showYearPickerSheet = false
    
    @State private var showAddHabit = false
    @State private var habitToEdit: Habit?
    
    @State private var selectedYear: Int = Calendar.current.component(.year, from: Date())
    
    private var dailyProgress: Double {
        habits.isEmpty ? 0 : Double(habits.filter { $0.isCompleted }.count) / Double(habits.count)
    }
    
    private var yearlyProgress: Double {
        let markedDays = appData.markedDaysInCurrentYear()
        let calendar = Calendar.current
        let isLeap = calendar.range(of: .day, in: .year, for: Date())?.count == 366
        let totalDays = isLeap ? 366.0 : 365.0
        return totalDays > 0 ? Double(markedDays.count) / totalDays : 0
    }
    
    private var timelessProgress: Double {
        let uniqueDays = appData.markedDayMonthCombinations()
        return Double(uniqueDays.count) / 365.0
    }
    
    private var monthlyMarkedCounts: [Int: Int] {
        appData.markedCountsPerMonth(forYear: selectedYear)
    }
    
    var milestones: [YearMilestone] {
        ProgressLogic.generateMilestones(progress: yearlyProgress)
    }

    var monthAchievements: [MonthAchievement] {
        ProgressLogic.generateMonthAchievements(markedDays: appData.markedDaysInCurrentYear(), year: selectedYear)
    }

    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                
                // Günlük hedef
//                VStack(alignment: .leading) {
//                    Text("Günlük Hedef")
//                        .font(.headline)
//                    
//                    GeometryReader { geo in
//                        ZStack(alignment: .leading) {
//                            RoundedRectangle(cornerRadius: 8)
//                                .fill(Color.gray.opacity(0.2))
//                                .frame(height: 12)
//                            
//                            RoundedRectangle(cornerRadius: 8)
//                                .fill(LinearGradient(colors: [.blue, .cyan], startPoint: .leading, endPoint: .trailing))
//                                .frame(width: CGFloat(dailyProgress) * geo.size.width, height: 12)
//                                .animation(.easeInOut, value: dailyProgress)
//                        }
//                    }
//                    .frame(height: 12)
//                    .padding(.top, 4)
//                    
//                    Text("\(Int(dailyProgress * 100))% tamamlandı")
//                        .font(.caption)
//                        .foregroundColor(.gray)
//                }
//                .padding()
//                
//                Divider()
                
                // Alışkanlıklar
//                VStack(alignment: .leading, spacing: 12) {
//                    HStack {
//                        Text("Alışkanlıklar")
//                            .font(.headline)
//                        Spacer()
//                        Button(action: {
//                            showAddHabit = true
//                        }) {
//                            Image(systemName: "plus.circle.fill")
//                                .font(.title2)
//                        }
//                    }
//                    
//                    if habits.isEmpty {
//                        Text("Henüz alışkanlık eklenmedi.")
//                            .foregroundColor(.gray)
//                            .italic()
//                    }
//                    
//                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 16) {
//                        ForEach(habits) { habit in
//                            Button(action: {
//                                if let index = habits.firstIndex(where: { $0.id == habit.id }) {
//                                    habits[index].isCompleted.toggle()
//                                }
//                            }) {
//                                VStack(spacing: 8) {
//                                    Text(habit.emoji)
//                                        .font(.largeTitle)
//                                    Text(habit.name)
//                                        .font(.caption)
//                                        .multilineTextAlignment(.center)
//                                        .foregroundColor(.primary)
//                                }
//                                .frame(maxWidth: .infinity, minHeight: 80)
//                                .padding()
//                                .background(habit.isCompleted ? Color.green.opacity(0.2) : Color.gray.opacity(0.1))
//                                .cornerRadius(12)
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 12)
//                                        .stroke(habit.isCompleted ? Color.green : Color.gray.opacity(0.3), lineWidth: 1)
//                                )
//                            }
//                            .buttonStyle(.plain)
//                            .contextMenu {
//                                Button("Düzenle") {
//                                    habitToEdit = habit
//                                }
//                                Button("Sil", role: .destructive) {
//                                    habits.removeAll { $0.id == habit.id }
//                                }
//                            }
//                        }
//                    }
//                }
//                
//                Divider()
//                
                // Başarılar
//                VStack(alignment: .leading, spacing: 12) {
//                    Text("Başarılar")
//                        .font(.headline)
//                    
//                    if dailyProgress == 1.0 {
//                        AchievementBadge(title: "Günü Tamamladın 🎉", color: .green)
//                    } else if dailyProgress >= 0.75 {
//                        AchievementBadge(title: "Harika Gidiyorsun 💪", color: .blue)
//                    } else if dailyProgress >= 0.5 {
//                        AchievementBadge(title: "Yarısını Geçtin 🌓", color: .orange)
//                    } else if dailyProgress >= 0.25 {
//                        AchievementBadge(title: "Başlangıç Yapıldı 🚀", color: .yellow)
//                    } else {
//                        Text("Henüz başarı yok.")
//                            .font(.caption)
//                            .foregroundColor(.gray)
//                    }
//                }
//                
//                Divider()
//                
                // Yıl seçimi butonu + aylık ilerleme grafiği
                VStack(alignment: .leading) {
                    Text("Yıl Seçimi")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Button(action: {
                        showYearPickerSheet = true
                    }) {
                        HStack {
                            Text("\(selectedYear)")
                                .font(.headline)
                            Image(systemName: "chevron.down")
                                .font(.subheadline)
                        }
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                    }
                    
                    Text("\(selectedYear) Yılı Aylık İlerleme")
                        .font(.headline)
                        .padding(.top, 8)
                    
                    Chart {
                        ForEach(1...12, id: \.self) { month in
                            let count = monthlyMarkedCounts[month] ?? 0
                            BarMark(
                                x: .value("Ay", monthName(from: month)),
                                y: .value("İşaretlenen Gün", count)
                            )
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.blue, .cyan],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        }
                    }

                    .frame(height: 180)
                }
                .sheet(isPresented: $showYearPickerSheet) {
                    YearPickerView(selectedYear: $selectedYear, isPresented: $showYearPickerSheet)
                }
                
                Divider()
                
                // Yıllık ilerleme
                VStack(alignment: .leading) {
                    Text("Yıllık İlerleme (Bu Yıl)")
                        .font(.headline)
                        .onTapGesture {
                            showYearlyDetail = true
                        }
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 12)
                        RoundedRectangle(cornerRadius: 8)
                            .fill(LinearGradient(colors: [.purple, .pink], startPoint: .leading, endPoint: .trailing))
                            .frame(width: CGFloat(yearlyProgress) * UIScreen.main.bounds.width * 0.85, height: 12)
                    }
                    .padding(.top, 4)
                    Text("\(Int(yearlyProgress * 100))% tamamlandı")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .sheet(isPresented: $showYearlyDetail) {
                    ProgressDetailView(title: "Yıllık İlerleme", markedDays: appData.markedDaysInCurrentYear())
                }
                
                Divider()
                
                // Zaman bağımsız ilerleme
                VStack(alignment: .leading) {
                    Text("Tüm Zamanların İlerlemesi (365 gün)")
                        .font(.headline)
                        .onTapGesture {
                            showTimelessDetail = true
                        }
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 12)
                        RoundedRectangle(cornerRadius: 8)
                            .fill(LinearGradient(colors: [.pink, .orange], startPoint: .leading, endPoint: .trailing))
                            .frame(width: CGFloat(timelessProgress) * UIScreen.main.bounds.width * 0.85, height: 12)
                    }
                    .padding(.top, 4)
                    Text("\(Int(timelessProgress * 100))% tamamlandı")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .sheet(isPresented: $showTimelessDetail) {
                    ProgressDetailView(title: "Zaman Bağımsız İlerleme", markedDays: Set(appData.markedDays.keys))
                }
                
                Spacer(minLength: 30)
                Divider()

                // Başarı Rozetleri
                VStack(alignment: .leading, spacing: 12) {
                    Text("Başarılar")
                        .font(.headline)

                    ForEach(milestones) { milestone in
                        AchievementBadge(title: milestone.label, desc: milestone.desc, icon: milestone.icon, achieved: milestone.achieved)
                            }

                    ForEach(monthAchievements) { achievement in
                        AchievementBadge(title: achievement.label, desc: achievement.desc, icon: achievement.icon, achieved: achievement.achieved)
                            
                    }
                }

            }
            .padding()
        }
        // Yeni alışkanlık eklemek için sheet
        .sheet(isPresented: $showAddHabit) {
            AddEditHabitView { newHabit in
                habits.append(newHabit)
                showAddHabit = false
            }
        }
        // Alışkanlık düzenlemek için sheet
        .sheet(item: $habitToEdit) { habit in
            AddEditHabitView(habit: habit) { updatedHabit in
                if let index = habits.firstIndex(where: { $0.id == updatedHabit.id }) {
                    habits[index] = updatedHabit
                }
                habitToEdit = nil
            }
        }
    }
    
    func monthName(from month: Int) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.monthSymbols[month - 1]
    }
}

// Yıl seçim sheet’i
struct YearPickerView: View {
    @Binding var selectedYear: Int
    @Binding var isPresented: Bool
    
    let currentYear = Calendar.current.component(.year, from: Date())
    let years: [Int]
    
    init(selectedYear: Binding<Int>, isPresented: Binding<Bool>) {
        self._selectedYear = selectedYear
        self._isPresented = isPresented
        
        let startYear = currentYear - 50
        self.years = Array(startYear...currentYear).reversed()
    }
    
    var body: some View {
        NavigationView {
            List(years, id: \.self) { year in
                Button(action: {
                    selectedYear = year
                    isPresented = false
                }) {
                    HStack {
                        Text("\(year)")
                        if year == selectedYear {
                            Spacer()
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .navigationTitle("Yıl Seç")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Kapat") {
                        isPresented = false
                    }
                }
            }
        }
    }
}

// Alışkanlık ekleme/düzenleme sheet’i
struct AddEditHabitView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var habit: Habit
    var onSave: (Habit) -> Void
    
    // Yeni alışkanlık eklemek için initializer
    init(habit: Habit = Habit(name: "", emoji: "", isCompleted: false), onSave: @escaping (Habit) -> Void) {
        _habit = State(initialValue: habit)
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Alışkanlık Bilgileri")) {
                    TextField("Alışkanlık adı", text: $habit.name)
                    TextField("Emoji", text: $habit.emoji)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.none)
                }
            }
            .navigationTitle(habit.name.isEmpty ? "Yeni Alışkanlık" : "Alışkanlık Düzenle")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Kaydet") {
                        guard !habit.name.trimmingCharacters(in: .whitespaces).isEmpty,
                              !habit.emoji.trimmingCharacters(in: .whitespaces).isEmpty
                        else { return }
                        onSave(habit)
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("İptal") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// Destekleyici yapılar

struct Habit: Identifiable, Equatable {
    let id: UUID = UUID()
    var name: String
    var emoji: String
    var isCompleted: Bool
}

struct WeekProgress: Identifiable {
    let id = UUID()
    let day: String
    let value: Double
}

struct AchievementBadge: View {
    let title: String
    let desc: String
    let icon: String
    let achieved: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(icon)
                .font(.largeTitle)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .bold()
                Text(desc)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(achieved ? Color.green.opacity(0.15) : Color.gray.opacity(0.1))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(achieved ? Color.green : Color.gray.opacity(0.3), lineWidth: 1)
        )
    }
}


struct ProgressDetailView: View {
    let title: String
    let markedDays: Set<Date>

    var body: some View {
        NavigationView {
            List {
                ForEach(groupedByMonth(), id: \.key) { month, dates in
                    Section(header: Text(month)) {
                        ForEach(dates, id: \.self) { date in
                            Text(formatted(date))
                                .foregroundColor(.green)
                        }
                    }
                }
            }
            .navigationTitle(title)
        }
    }

    func groupedByMonth() -> [(key: String, value: [Date])] {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        let grouped = Dictionary(grouping: Array(markedDays)) { (date: Date) -> String in
            formatter.string(from: date)
        }
        return grouped.sorted { $0.key < $1.key }
    }

    func formatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
