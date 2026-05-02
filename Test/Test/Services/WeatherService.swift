import Foundation

enum WeatherError: LocalizedError {
    case invalidURL
    case serverError(statusCode: Int, message: String)
    case noWeatherData
    case decodingError
    case unknown(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Неверный URL запроса."
        case .serverError(let statusCode, let message):
            return "Ошибка сервера \(statusCode): \(message)"
        case .noWeatherData:
            return "Нет данных о погоде."
        case .decodingError:
            return "Ошибка обработки данных."
        case .unknown(let message):
            return message
        }
    }
}

final class WeatherService {
    
    private let apiKey = "60ef77dd17147cd89a25bab7de9e60d3"
    
    func fetchWeather(city: String = "Kyiv") async throws -> WeatherInfo {
        var components = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather")
        
        components?.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "lang", value: "ru")
        ]
        
        guard let url = components?.url else {
            throw WeatherError.invalidURL
        }
        
        print("🌍 Weather URL:", url.absoluteString)
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            let responseText = String(data: data, encoding: .utf8) ?? "No response body"
            print("📦 Weather response:", responseText)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw WeatherError.unknown("Нет HTTP ответа.")
            }
            
            guard 200...299 ~= httpResponse.statusCode else {
                throw WeatherError.serverError(
                    statusCode: httpResponse.statusCode,
                    message: responseText
                )
            }
            
            let decoded = try JSONDecoder().decode(WeatherResponse.self, from: data)
            
            guard let firstWeather = decoded.weather.first else {
                throw WeatherError.noWeatherData
            }
            
            return WeatherInfo(
                temperature: decoded.main.temp,
                description: firstWeather.description,
                iconCode: firstWeather.icon,
                cityName: decoded.name
            )
            
        } catch let error as WeatherError {
            throw error
        } catch let decodingError as DecodingError {
            print("❌ Decoding error:", decodingError)
            throw WeatherError.decodingError
        } catch {
            throw WeatherError.unknown(error.localizedDescription)
        }
    }
}
