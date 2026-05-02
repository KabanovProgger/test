import SwiftUI

struct NoteDetailView: View {
    
    let note: WeatherNote
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(note.text)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text(note.createdAt.formatted(date: .long, time: .shortened))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Погода")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    HStack(spacing: 16) {
                        AsyncImage(url: note.weather.iconURL) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 80, height: 80)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("\(Int(note.weather.temperature.rounded()))°C")
                                .font(.system(size: 36, weight: .bold))
                            
                            Text(note.weather.description.capitalized)
                                .font(.headline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    InfoRow(title: "Локация", value: note.weather.cityName)
                    InfoRow(title: "Иконка", value: note.weather.iconCode)
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Детали")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct InfoRow: View {
    
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundStyle(.secondary)
            
            Spacer()
            
            Text(value)
                .fontWeight(.medium)
        }
        .padding(.vertical, 4)
    }
}
