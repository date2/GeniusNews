//

import UIKit

struct Endpoint {

    static func googleNewsURL(_ keyword: String) -> URL? {
        guard let encodedKeyword = keyword.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed) else {
                return nil
        }
        
        let googleNewsUrlString = "https://news.google.com/news/rss/search/section/q/\(encodedKeyword)?ned=us&gl=US&hl=en"
        guard let url = URL(string: googleNewsUrlString) else {
            return nil
        }

        return url
    }
}
