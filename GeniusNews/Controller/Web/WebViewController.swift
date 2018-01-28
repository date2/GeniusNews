import UIKit
import RxSwift
import RxCocoa
import WebKit
import RxWebKit

final class WebViewController: UIViewController, Injectable {
    
    typealias Dependency = WebViewModel
    
    @IBOutlet var webView: WKWebView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var viewModel: WebViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.urlRequest
            .bind { [unowned self] in self.webView.load($0) }
            .disposed(by: rx.disposeBag)
        
        Observable
            .merge(
                webView.rx.didStartProvisionalNavigation.map { _ in false },
                webView.rx.didCommitNavigation.map { _ in true },
                webView.rx.didFailProvisionalNavigation.map { _ in true }
            )
            .bind(to: loadingIndicator.rx.isHidden)
            .disposed(by: rx.disposeBag)
        
        let error = webView.rx.didFailProvisionalNavigation.map { $0.2 }
        
        error
            .flatMap { [unowned self] error -> Observable<DefaultAlertResult> in
                return UIAlertController.rx.present(
                    baseController: self,
                    title: "Error",
                    message: error.localizedDescription,
                    actions: [AlertAction(style: .default, result: .ok)])
            }
            .bind { _ in }
            .disposed(by: rx.disposeBag)
    }
    
    static func make(dependency: Dependency) -> WebViewController {
        let storyboard = UIStoryboard(name: "Web", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController() as! WebViewController
        viewController.viewModel = dependency
        return viewController
    }
}
