import SwiftUI

enum AppTheme: String, CaseIterable, Identifiable {
    case system
    case light
    case dark
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .system:
            return "Системная"
        case .light:
            return "Светлая"
        case .dark:
            return "Тёмная"
        }
    }
    
    var colorScheme: ColorScheme? {
        switch self {
        case .system:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}

final class AppThemeManager: ObservableObject {
    
    @Published var selectedTheme: AppTheme {
        didSet {
            UserDefaults.standard.set(selectedTheme.rawValue, forKey: key)
        }
    }
    
    private let key = "selected_app_theme"
    
    init() {
        let savedValue = UserDefaults.standard.string(forKey: key)
        selectedTheme = AppTheme(rawValue: savedValue ?? "") ?? .system
    }
}
