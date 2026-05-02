import SwiftUI

struct NotesListView: View {
    
    @EnvironmentObject private var themeManager: AppThemeManager
    @StateObject private var viewModel = NotesListViewModel()
    @State private var isShowingAddNote = false
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.notes.isEmpty {
                    emptyState
                } else {
                    List {
                        ForEach(viewModel.notes) { note in
                            NavigationLink {
                                NoteDetailView(note: note)
                            } label: {
                                NoteRowView(note: note)
                            }
                        }
                        .onDelete(perform: viewModel.deleteNote)
                    }
                }
            }
            .navigationTitle("WeatherNotes")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Picker("Тема", selection: $themeManager.selectedTheme) {
                            ForEach(AppTheme.allCases) { theme in
                                Text(theme.title)
                                    .tag(theme)
                            }
                        }
                    } label: {
                        Image(systemName: "moon.circle")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShowingAddNote = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isShowingAddNote) {
                AddNoteView { note in
                    viewModel.addNote(note)
                }
            }
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "cloud.sun")
                .font(.system(size: 56))
                .foregroundStyle(.secondary)
            
            Text("Нет заметок")
                .font(.title3)
                .fontWeight(.semibold)
            
            Text("Нажмите +, чтобы добавить первую заметку с погодой.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
}
