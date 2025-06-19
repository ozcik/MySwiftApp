import SwiftUI

struct ContentView: View {
    @StateObject private var appData = AppData()  // Tek bir instance oluşturduk

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            CalendarView()
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }

            ProgressView()
                .tabItem {
                    Label("Progress", systemImage: "chart.bar")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .environmentObject(appData)  // Burada inject ediyoruz
    }
}

#Preview {
    ContentView()
        .environmentObject(AppData()) // Preview için de inject edelim
}
