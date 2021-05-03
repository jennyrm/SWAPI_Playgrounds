import Foundation

//MARK: - Model
struct Person: Decodable {
    var name: String
    var films: [URL]
}

struct Film: Decodable {
    var title: String
    var opening_crawl: String
    var release_date: String
}

//MARK: - Model Controller
class SwapiService {
    //MARK: - Properties
    static private let baseURL = URL(string: "https://swapi.dev/api/")
    static let peopleEndPoint = "people"
    static let filmsEndPoint = "films"

    //MARK: - Functions
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
      // 1 - Prepare URL
        guard let baseURL = baseURL else { return completion(nil) }
        let peopleURL = baseURL.appendingPathComponent(peopleEndPoint) //https://swapi.dev/api/people
        let finalURL = peopleURL.appendingPathComponent(String(id)) //https://swapi.dev/api/people/id
        print(finalURL)
        
      // 2 - Contact server
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            // 3 - Handle errors
            if let error = error {
                print("Error in \(#function)\(#line) : \(error.localizedDescription) \n---\n \(error)")
                return completion(nil)
            }
            // 4 - Check for data
            guard let data = data else { return completion(nil) }
            // 5 - Decode Person from JSON
            do {
                let person = try JSONDecoder().decode(Person.self, from: data)
                return completion(person)
            } catch {
                print("Error in \(#function)\(#line) : \(error.localizedDescription) \n---\n \(error)")
                return completion(nil)
            }
        }.resume()
    }
    
    static func fetchFilm(url: URL, completion: @escaping (Film?) -> Void) {
      // 1 - Contact server
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            // 2 - Handle errors
            if let error = error {
                print("Error in \(#function)\(#line) : \(error.localizedDescription) \n---\n \(error)")
                return completion(nil)
            }
            // 3 - Check for data
            guard let data = data else { return completion(nil) }
            // 4 - Decode Film from JSON
            do {
                let film = try JSONDecoder().decode(Film.self, from: data)
                return completion(film)
            } catch {
                print("Error in \(#function)\(#line) : \(error.localizedDescription) \n---\n \(error)")
                return completion(nil)
            }
        }.resume()
    }
    
}//End of class

SwapiService.fetchPerson(id: 10) { person in
    if let person = person {
        for url in person.films {
            fetchFilm(url: url)
        }
    }
}

func fetchFilm(url: URL) {
  SwapiService.fetchFilm(url: url) { film in
      if let film = film {
          print(film)
      }
  }
}
