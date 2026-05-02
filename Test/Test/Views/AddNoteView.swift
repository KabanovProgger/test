import SwiftUI

struct AddNoteView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AddNoteViewModel()
    
    let onSave: (WeatherNote) -> Void
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                TextField("Например: пробежка, прогулка, поездка", text: $viewModel.text, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(3...6)
                
                if viewModel.isLoading {
                    ProgressView("Получаем погоду...")
                }
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                        .font(.footnote)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Новая заметка")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        Task {
                            if let note = await viewModel.createNote() {
                                onSave(note)
                                dismiss()
                            }
                        }
                    }
                    .disabled(!viewModel.canSave)
                }
            }
        }
    }
}
