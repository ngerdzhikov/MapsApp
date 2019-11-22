import Foundation

public class MapsAPI: NSObject {
    private let urlSession = URLSession.shared
    
    public func getGeoCoordinates(search: String, completion: @escaping([String: Any]?) -> Void, errorCompletion: @escaping(Error?) -> Void) {
        let urlString = String(format: "%@%@%@.json?access_token=%@", Constants.baseURLString, Constants.geoDecodingPrefix, search.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!, Constants.API_KEY)
        if let url = URL(string: urlString) {
            getRequest(url: url, completion: completion, errorCompletion: errorCompletion)
            print(url)
        }
    }
    
    public func getStaticImage(lon: Double, lat: Double, completion: @escaping(Data?) -> Void, errorCompletion: @escaping(Error?) -> Void) {
        let endpoint = Constants.staticImagesPrefix.replacingOccurrences(of: "{lat}", with: String(lat)).replacingOccurrences(of: "{lon}", with: String(lon))
        let urlString = String(format: "%@%@/300x200?access_token=%@", Constants.baseURLString, endpoint, Constants.API_KEY)
        if let url = URL(string: urlString) {
            getImageRequest(url: url, completion: completion, errorCompletion: errorCompletion)
            print(url)
        }
    }
    
    func getRequest(url: URL, completion: @escaping([String: Any]?) -> Void, errorCompletion: @escaping(Error?) -> Void) {
        urlSession.dataTask(with: url) { (data, response, error) in
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: Any] {
                completion(json)
            } else if error != nil {
                errorCompletion(error)
            }
        }.resume()
    }
    
    func getImageRequest(url: URL, completion: @escaping(Data?) -> Void, errorCompletion: @escaping(Error?) -> Void) {
        urlSession.dataTask(with: url) { (data, response, error) in
            if let data = data{
                completion(data)
            } else if error != nil {
                errorCompletion(error)
            }
        }.resume()
    }
}