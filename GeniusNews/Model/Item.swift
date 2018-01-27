import UIKit
import SWXMLHash

struct Item: XMLIndexerDeserializable {
    let title: String
    let link: String
    
    static func deserialize(_ node: XMLIndexer) throws -> Item {
        return try Item(
            title: node["title"].value(),
            link: node["link"].value()
        )
    }
}
