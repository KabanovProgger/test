import SwiftUI

@main
struct WeatherNotesApp: App {
    
    @StateObject private var themeManager = AppThemeManager()
    
    var body: some Scene {
        WindowGroup {
            NotesListView()
                .environmentObject(themeManager)
                .preferredColorScheme(themeManager.selectedTheme.colorScheme)
        }
    }
}
