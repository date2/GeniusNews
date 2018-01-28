import UIKit
import RxSwift
import RxCocoa

final class WebViewModel {
    
    let urlRequest: BehaviorRelay<URLRequest>
    
    init(url: URL) {
        urlRequest = BehaviorRelay<URLRequest>(value: URLRequest(url: url))
    }
    
}
