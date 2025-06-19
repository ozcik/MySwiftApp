import SwiftUI

struct SettingsView: View {
    @AppStorage("username") private var username: String = "Misafir"
    @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = true
    @AppStorage("selectedTheme") private var selectedTheme: ThemeOption = .system

    var body: some View {
        NavigationView {
            Form {
                // 🔹 Kullanıcı Adı
                Section(header: Text("Kullanıcı")) {
                    TextField("Kullanıcı adınız", text: $username)
                        .textInputAutocapitalization(.never)
                }

                // 🔹 Bildirimler
                Section(header: Text("Bildirimler")) {
                    Toggle("Bildirimleri Aç", isOn: $notificationsEnabled)
                }

                // 🔹 Tema Seçimi
                Section(header: Text("Tema")) {
                    Picker("Tema", selection: $selectedTheme) {
                        ForEach(ThemeOption.allCases, id: \.self) { option in
                            Text(option.rawValue)
                        }
                    }
                }

                // 🔹 Hakkında
                Section(header: Text("Hakkında")) {
                    HStack {
                        Text("Uygulama Sürümü")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.gray)
                    }
                    NavigationLink(destination: Text("Loveander, kişisel takvim ve alışkanlık takip uygulamasıdır. © 2025")) {
                        Text("Hakkında")
                    }
                }
            }
            .navigationTitle("Ayarlar")
        }
    }
}

// 🔸 Tema Seçenekleri
enum ThemeOption: String, CaseIterable, Codable {
    case light = "Açık"
    case dark = "Koyu"
    case system = "Sistem"
}
