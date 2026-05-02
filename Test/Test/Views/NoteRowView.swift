import SwiftUI

struct NoteRowView: View {
    
    let note: WeatherNote
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: note.weather.iconURL) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 48, height: 48)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(note.text)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(note.createdAt.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Text("\(Int(note.weather.temperature.rounded()))°C")
                .font(.headline)
        }
        .padding(.vertical, 4)
    }
}
