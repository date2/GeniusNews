import UIKit
import RxSwift

final class FeedViewController: UITableViewController, Injectable {
    
    typealias Dependency = FeedViewModel
    
    private var viewModel: FeedViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    static func make(dependency: Dependency) -> FeedViewController {
        let storyboard = UIStoryboard(name: "Feed", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController() as! FeedViewController
        return viewController
    }
}
