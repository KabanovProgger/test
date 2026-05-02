import Foundation

@MainActor
final class AddNoteViewModel: ObservableObject {
    
    @Published var text: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let weatherService = WeatherService()
    
    var canSave: Bool {
        !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isLoading
    }
    
    func createNote() async -> WeatherNote? {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedText.isEmpty else {
            errorMessage = "Введите текст заметки."
            return nil
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let weather = try await weatherService.fetchWeather(city: "Kyiv")
            
            let note = WeatherNote(
                id: UUID(),
                text: trimmedText,
                createdAt: Date(),
                weather: weather
            )
            
            isLoading = false
            return note
            
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
            return nil
        }
    }
}
