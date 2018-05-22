import Alamofire

struct Comic {
    let image      : String
    let title       : String
    let alt         : String
    let num         : Int
    
    static func parse(json: Dictionary<String, Any>) -> Comic? {
        guard let name = json["title"] as? String, let num = json["num"] as? Int, let alt = json["alt"] as? String else {
            return nil
        }
        
        guard let image = json["img"] as? String else {
            return nil
        }
        
        return Comic(image: image, title: name, alt: alt, num: num)
    }
    
    // get last comic from website
    static func loadLast(completion: @escaping (Comic?) -> Void) {
        let url = "https://xkcd.com/info.0.json"
        load(url: url){ comic in
            completion(comic)
        }
    }
    
    // get comic from website by number
    static func load(num: Int, completion: @escaping (Comic?) -> Void) {
        let url = "https://xkcd.com/\(num)/info.0.json"
        load(url: url){ comic in
            completion(comic)
        }
    }
    
    // get comic by url
    static func load(url: String, completion: @escaping (Comic?) -> Void) {
        let request = Alamofire.request(url)
        request.responseJSON { (response) in
            guard let json = response.result.value as? [String: Any] else {
                completion(nil)
                return
            }
            guard let product = Comic.parse(json: json) else {
                completion(nil)
                return
            }
            completion(product)
        }
    }
    
}
