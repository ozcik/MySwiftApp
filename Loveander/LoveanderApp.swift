//
//  LoveanderApp.swift
//  Loveander
//
//  Created by weepay-macbook on 18.06.2025.
//

import SwiftUI

@main

struct LoveanderApp: App {
    @AppStorage("selectedTheme") private var selectedTheme: ThemeOption = .system

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(colorScheme(for: selectedTheme))
        }
    }
    func colorScheme(for theme: ThemeOption) -> ColorScheme? {
            switch theme {
            case .light: return .light
            case .dark: return .dark
            case .system: return nil
            }
        }
}
