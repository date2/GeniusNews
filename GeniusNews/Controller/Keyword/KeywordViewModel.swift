import UIKit
import RxSwift

final class KeywordViewModel {
    
    private let disposeBag = DisposeBag()
    
    let registerButtonEnabled: Observable<Bool>
    let keywords: Observable<[String]>
    
    let appendKeyword = PublishSubject<String>()
    let removeKeyword = PublishSubject<String>()
    let clearKeywordTextField = PublishSubject<Void>()

    init(keywordText: Observable<String>) {
        registerButtonEnabled = keywordText.map { !$0.isEmpty }

        let refreshTrigger = PublishSubject<Void>()
        
        keywords = Observable
            .merge(.just(()), refreshTrigger)
            .map { _ in KeywordRepository.keywords }
        
        appendKeyword
            .bind { [unowned self] keyword in
                KeywordRepository.append(keyword: keyword)
                self.clearKeywordTextField.onNext(())
                refreshTrigger.onNext(())
            }.disposed(by: disposeBag)
        
        removeKeyword
            .bind { keyword in
                KeywordRepository.remove(keyword: keyword)
                refreshTrigger.onNext(())
            }.disposed(by: disposeBag)
    }
}
