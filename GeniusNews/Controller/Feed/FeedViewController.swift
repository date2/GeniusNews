import UIKit
import RxSwift
import RxCocoa

final class FeedViewController: UITableViewController, Injectable {
    
    typealias Dependency = FeedViewModel
    
    private var viewModel: FeedViewModel!
    
    var webViewNavigationSegue: AnyObserver<WebViewModel> {
        return NavigationSegue(
            fromViewController: self.navigationController,
            toViewControllerType: WebViewController.self
        ).asObserver()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.items
            .bind(to: tableView.rx.items(cellIdentifier: "Cell")) { row, element, cell in
                cell.textLabel?.text = element.title
            }
            .disposed(by: rx.disposeBag)

        tableView.rx.itemSelected
            .withLatestFrom(viewModel.items) { $1[$0.row] }
            .flatMap { URL(string: $0.link).flatMap(Observable.just) ?? .empty() }
            .map { WebViewModel(url: $0) }
            .bind(to: webViewNavigationSegue)
            .disposed(by: rx.disposeBag)
    }
    
    static func make(dependency: Dependency) -> FeedViewController {
        let storyboard = UIStoryboard(name: "Feed", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController() as! FeedViewController
        viewController.viewModel = dependency
        return viewController
    }
}
