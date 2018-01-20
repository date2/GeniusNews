import UIKit

final class KeywordRepository {

    enum Key: String {
        case keywords
    }

    static var keywords: [String] {
        get {
            return UserDefaults.standard.value(forKey: Key.keywords.rawValue) as? [String] ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.keywords.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    static func append(keyword: String) {
        KeywordRepository.keywords = KeywordRepository.keywords.filter { $0 != keyword } + [keyword]
    }
}
