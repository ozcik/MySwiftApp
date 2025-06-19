import SwiftUI

struct IdentifiableDate: Identifiable {
    let id = UUID()
    let date: Date
}

struct CalendarView: View {
    @State private var currentDate = Date()
    @EnvironmentObject var appData: AppData
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    private var firstDayOfMonth: Date {
        Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: currentDate))!
    }
    
    private var daysInMonth: Int {
        Calendar.current.range(of: .day, in: .month, for: currentDate)!.count
    }
    
    private var firstWeekday: Int {
        Calendar.current.component(.weekday, from: firstDayOfMonth)
    }
    
    private var days: [Date?] {
        var daysArray: [Date?] = []
        let startingOffset = (firstWeekday + 5) % 7
        for _ in 0..<startingOffset { daysArray.append(nil) }
        for day in 1...daysInMonth {
            if let date = Calendar.current.date(byAdding: .day, value: day - 1, to: firstDayOfMonth) {
                daysArray.append(date)
            }
        }
        return daysArray
    }
    
    let emojiOptions = ["🎉", "✅", "🔥", "🌟", "💪", "🎯", "🌈"]
    
    @State private var selectedEmoji: String? = nil
    @State private var showEmojiPickerForDate: IdentifiableDate? = nil
    
    // Yeni: Ay-Yıl Picker için state
    @State private var showMonthYearPicker = false
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    currentDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate)!
                }) {
                    Image(systemName: "chevron.left")
                }
                Spacer()
                
                Button(action: {
                    showMonthYearPicker = true
                }) {
                    Text(monthYearString(from: currentDate))
                        .font(.title2)
                        .bold()
                }
                
                Spacer()
                Button(action: {
                    currentDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate)!
                }) {
                    Image(systemName: "chevron.right")
                }
            }
            .padding(.horizontal)
            .padding(.top)
            // Picker sheet göster
            .sheet(isPresented: $showMonthYearPicker) {
                MonthYearPickerView(selectedDate: $currentDate)
            }
            
            LazyVGrid(columns: columns) {
                ForEach(["Pzt", "Sal", "Çar", "Per", "Cum", "Cmt", "Paz"], id: \.self) { dayName in
                    Text(dayName)
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                }
            }
            
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(days.indices, id: \.self) { index in
                    if let date = days[index] {
                        DayView(date: date,
                                isMarked: isDateMarked(date),
                                emoji: emojiForDate(date))
                        .onTapGesture {
                            showEmojiPickerForDate = IdentifiableDate(date: date)
                        }
                    } else {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(height: 40)
                    }
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .sheet(item: $showEmojiPickerForDate) { identifiableDate in
            EmojiPickerView(selectedEmoji: $selectedEmoji, onSelect: { emoji in
                toggleEmoji(for: identifiableDate.date, emoji: emoji)
                showEmojiPickerForDate = nil
            })
        }
        .onChange(of: selectedEmoji) { _ in
            selectedEmoji = nil
        }
    }
    
    func monthYearString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateFormat = "LLLL yyyy"
        return formatter.string(from: date).capitalized
    }
    
    func isDateMarked(_ date: Date) -> Bool {
        appData.markedDays.keys.contains(date.stripTime())
    }

    func emojiForDate(_ date: Date) -> String? {
        let dateKey = date.stripTime()
        return appData.markedDays[dateKey]
    }

    func toggleEmoji(for date: Date, emoji: String) {
        appData.toggleMark(for: date, emoji: emoji)
    }
}

struct DayView: View {
    let date: Date
    let isMarked: Bool
    let emoji: String?
    
    var body: some View {
        VStack(spacing: 2) {
            Text("\(Calendar.current.component(.day, from: date))")
                .frame(maxWidth: .infinity, minHeight: 40)
                .background(isMarked ? Color.blue.opacity(0.3) : Color.clear)
                .cornerRadius(8)
            
            if let emoji = emoji, isMarked {
                Text(emoji)
                    .font(.caption)
            } else {
                Spacer().frame(height: 14)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

// Emoji seçici basit örnek
struct EmojiPickerView: View {
    @Binding var selectedEmoji: String?
    @Environment(\.presentationMode) var presentationMode
    let onSelect: (String) -> Void
    
    let emojis = ["🎉", "✅", "🔥", "🌟", "💪", "🎯", "🌈"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5)) {
                    ForEach(emojis, id: \.self) { emoji in
                        Text(emoji)
                            .font(.largeTitle)
                            .padding()
                            .onTapGesture {
                                onSelect(emoji)
                                selectedEmoji = emoji
                            }
                    }
                }
                .padding()
            }
            .navigationTitle("Emoji Seç")
            .navigationBarItems(trailing: Button("Kapat") {
                selectedEmoji = nil
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

// MonthYearPickerView bileşeni:
struct MonthYearPickerView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedDate: Date
    
    @State private var selectedMonth: Int
    @State private var selectedYear: Int
    
    private var years: [Int] {
        let currentYear = Calendar.current.component(.year, from: Date())
        return Array((currentYear - 50)...(currentYear + 50))
    }
    
    init(selectedDate: Binding<Date>) {
        _selectedDate = selectedDate
        let components = Calendar.current.dateComponents([.year, .month], from: selectedDate.wrappedValue)
        _selectedMonth = State(initialValue: components.month ?? 1)
        _selectedYear = State(initialValue: components.year ?? Calendar.current.component(.year, from: Date()))
    }
    
    var body: some View {
        NavigationView {
            Form {
                Picker("Ay", selection: $selectedMonth) {
                    ForEach(1...12, id: \.self) { month in
                        Text("\(month) \(monthName(from: month))").tag(month)
                    }
                }
                Picker("Yıl", selection: $selectedYear) {
                    ForEach(years, id: \.self) { year in
                        Text("\(year)").tag(year)
                    }
                }
            }
            .navigationBarTitle("Ay ve Yıl Seç", displayMode: .inline)
            .navigationBarItems(trailing: Button("Tamam") {
                updateSelectedDate()
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    func monthName(from month: Int) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.monthSymbols[month - 1]
    }
    
    func updateSelectedDate() {
        var components = Calendar.current.dateComponents([.day], from: selectedDate)
        components.year = selectedYear
        components.month = selectedMonth
        if let newDate = Calendar.current.date(from: components) {
            selectedDate = newDate
        }
    }
}

// Date extension - sadece tarih kısmını karşılaştırmak için
extension Date {
    func stripTime() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        return Calendar.current.date(from: components)!
    }
}
