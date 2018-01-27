import UIKit
import RxSwift
import RxCocoa
import SWXMLHash

final class FeedViewModel {
    
    private let disposeBag = DisposeBag()

    let items = BehaviorRelay<[Item]>(value: [])

    init(keyword: String) {
        guard let url = Endpoint.googleNewsURL(keyword) else { return }

        URLSession.shared.rx.data(request: URLRequest(url: url))
            .flatMap { data -> Observable<[Item]> in
                let parsedXML = SWXMLHash.parse(data)
                do {
                    let items: [Item] = try parsedXML["rss"]["channel"]["item"].value()
                    return Observable.just(items)
                } catch {
                    return .empty()
                }
            }
            .bind(to: items)
            .disposed(by: disposeBag)
    }
}
