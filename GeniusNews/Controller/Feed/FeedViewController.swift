import UIKit
import RxSwift

final class FeedViewController: UITableViewController, Injectable {
    
    typealias Dependency = FeedViewModel
    
    private var viewModel: FeedViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.items
            .bind(to: tableView.rx.items(cellIdentifier: "Cell")) { row, element, cell in
                cell.textLabel?.text = element.title
            }
            .disposed(by: rx.disposeBag)
    }
    
    static func make(dependency: Dependency) -> FeedViewController {
        let storyboard = UIStoryboard(name: "Feed", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController() as! FeedViewController
        viewController.viewModel = dependency
        return viewController
    }
}
