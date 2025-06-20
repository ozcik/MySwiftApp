import SwiftUI

struct ContentView: View {
    @StateObject private var appData = AppData()  // Tek bir instance oluşturduk

    var body: some View {
        TabView {
            //HomeView()
               // .tabItem {
                //    Label("Home", systemImage: "house")
                //}

            CalendarView()
                .tabItem {
                    Label("Takvim", systemImage: "calendar")
                }

            ProgressView()
                .tabItem {
                    Label("Raporlar", systemImage: "chart.bar")
                }

            SettingsView()
                .tabItem {
                    Label("Ayarlar", systemImage: "gear")
                }
        }
        .environmentObject(appData)  // Burada inject ediyoruz
    }
}

#Preview {
    ContentView()
        .environmentObject(AppData()) // Preview için de inject edelim
}
