import SwiftUI

enum ThemeOption: String, CaseIterable, Codable, Identifiable {
    case light = "Açık"
    case dark = "Koyu"
    case system = "Sistem"

    var id: String { self.rawValue }
}

struct SettingsView: View {
    @AppStorage("username") private var username: String = "Misafir"
    @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = true
    @AppStorage("selectedTheme") private var selectedTheme: ThemeOption = .system

    var body: some View {
        NavigationView {
            Form {
                // Kullanıcı Adı
                Section(header: Text("Kullanıcı")) {
                    TextField("Kullanıcı adınız", text: $username)
                        .textInputAutocapitalization(.never)
                }

                // Bildirimler
                Section(header: Text("Bildirimler")) {
                    Toggle("Bildirimleri Aç", isOn: $notificationsEnabled)
                }

                // Tema Seçimi
                Section(header: Text("Tema")) {
                    VStack(spacing: 10) {
                        ForEach(ThemeOption.allCases) { option in
                            ThemeOptionRow(option: option, isSelected: selectedTheme == option) {
                                withAnimation {
                                    selectedTheme = option
                                }
                            }
                        }
                    }
                    .padding(.vertical, 5)
                }

                // Hakkında
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

/// 🔹 Seçenek satırı — background ifadesi sadeleştirilmiş haliyle ayrı View
struct ThemeOptionRow: View {
    let option: ThemeOption
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        let bg: AnyView = isSelected ?
            AnyView(
                LinearGradient(colors: [Color.blue.opacity(0.8), Color.blue],
                               startPoint: .topLeading, endPoint: .bottomTrailing)
            ) :
            AnyView(Color.clear)

        return Text(option.rawValue)
            .fontWeight(isSelected ? .bold : .regular)
            .padding()
            .frame(maxWidth: .infinity)
            .background(bg)
            .cornerRadius(10)
            .foregroundColor(isSelected ? .white : .primary)
            .onTapGesture(perform: onTap)
    }
}
