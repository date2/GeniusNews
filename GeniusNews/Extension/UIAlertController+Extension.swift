import UIKit
import RxSwift

protocol AlertActionType {
    associatedtype Result
    
    var style: UIAlertActionStyle { get }
    var result: Result { get }
}

struct AlertAction<R: CustomStringConvertible> : AlertActionType {
    typealias Result = R
    
    let style: UIAlertActionStyle
    let result: Result
}

enum DefaultConfirmResult: CustomStringConvertible {
    case ok
    case cancel
    
    var description: String {
        switch self {
        case .ok: return "OK"
        case .cancel: return "Cancel"
        }
    }
}

enum DefaultAlertResult: CustomStringConvertible {
    case ok

    var description: String {
        switch self {
        case .ok: return "OK"
        }
    }
}

extension Reactive where Base: UIAlertController {
    
    static func present<Action: AlertActionType, Result: CustomStringConvertible>(
        baseController: UIViewController,
        title: String,
        message: String = "",
        actions: [Action]) -> Observable<Result> where Action.Result == Result {
        
        return Observable.create { observer -> Disposable in
            let alertController = UIAlertController(
                title: title, message: message, preferredStyle: .alert)
            
            actions
                .map { action in
                    return UIAlertAction(title: action.result.description, style: .default) { _ in
                        observer.onNext(action.result)
                        observer.onCompleted()
                    }
                }.forEach { alertController.addAction($0) }
            
            baseController.present(alertController, animated: true)
            
            return Disposables.create {
                alertController.dismiss(animated: true)
            }
        }
    }
}
