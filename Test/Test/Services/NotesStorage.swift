import Foundation

final class NotesStorage {
    
    private let key = "weather_notes_key"
    
    func save(_ notes: [WeatherNote]) {
        do {
            let data = try JSONEncoder().encode(notes)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Save error:", error.localizedDescription)
        }
    }
    
    func load() -> [WeatherNote] {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return []
        }
        
        do {
            return try JSONDecoder().decode([WeatherNote].self, from: data)
        } catch {
            print("Load error:", error.localizedDescription)
            return []
        }
    }
}
