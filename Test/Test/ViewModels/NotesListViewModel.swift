import Foundation

@MainActor
final class NotesListViewModel: ObservableObject {
    
    @Published var notes: [WeatherNote] = []
    
    private let storage = NotesStorage()
    
    init() {
        loadNotes()
    }
    
    func loadNotes() {
        notes = storage.load().sorted {
            $0.createdAt > $1.createdAt
        }
    }
    
    func addNote(_ note: WeatherNote) {
        notes.insert(note, at: 0)
        storage.save(notes)
    }
    
    func deleteNote(at offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
        storage.save(notes)
    }
}
