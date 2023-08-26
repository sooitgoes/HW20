import Foundation

// MARK: - Model Data
struct Cards: Decodable {
    let cards: [DataOfCard]
}

struct DataOfCard: Decodable {
    let name: String?
    let manaCost: String?
    let type: String?
    let setName: String?
    let cmc: Int?
    let artist: String?
}

// MARK: - Get data function
func getData(urlRequest: String) {
    let urlRequest = URL(string: urlRequest)
    guard let url = urlRequest else { return }

    URLSession.shared.dataTask(with: url) { data, responce, error in

        if error != nil {
            print("Error in request")
        } else if let resp = responce as? HTTPURLResponse, resp.statusCode == 200 {
            print("Responce statusCode -> \(resp.statusCode)\n")
            guard let data = data else { return }

            let dataAsString = String(data: data, encoding: .utf8)

            do {
                let decoder = JSONDecoder()
                let infoCard = try decoder.decode(Cards.self, from: data)

                infoCard.cards.forEach { data in
                    print("""
                    Название -> \(data.name ?? "")
                    Мановая стоимость -> \(data.manaCost ?? "")
                    Тип -> \(data.type ?? "")
                    Имя сета -> \(data.setName ?? "")
                    CMC -> \(data.cmc ?? 0)
                    Артист -> \(data.artist ?? "")
                    \n------------------------------------------
                    """)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }.resume()
}

// MARK: - URL
var urlComponents = URLComponents()
urlComponents.scheme = "https"
urlComponents.host = "api.magicthegathering.io"
urlComponents.path = "/v1/cards"
urlComponents.queryItems = [URLQueryItem(name: "name", value: "Black Lotus|Opt")]

let url = urlComponents.url?.absoluteString
getData(urlRequest: url ?? "")


