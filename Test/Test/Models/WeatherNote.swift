import Foundation
//
struct WeatherNote: Identifiable, Codable {
    let id: UUID
    let text: String
    let createdAt: Date
    let weather: WeatherInfo
}

struct WeatherInfo: Codable {
    let temperature: Double
    let description: String
    let iconCode: String
    let cityName: String
    
    var iconURL: URL? {
        URL(string: "https://openweathermap.org/img/wn/\(iconCode)@2x.png")
    }
}
