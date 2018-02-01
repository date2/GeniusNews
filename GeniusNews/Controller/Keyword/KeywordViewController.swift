import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

final class KeywordViewController: UITableViewController {
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var keywordTextField: UITextField!
    
    private var viewModel: KeywordViewModel!
    
    var feedNavigationSegue: AnyObserver<FeedViewModel> {
        return NavigationSegue(
            fromViewController: self.navigationController,
            toViewControllerType: FeedViewController.self
        ).asObserver()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let keywordText = keywordTextField.rx.text.map { $0 ?? "" }.asObservable()
        
        viewModel = KeywordViewModel(keywordText: keywordText)
        
        registerButton.rx.tap
            .withLatestFrom(keywordText)
            .bind { [unowned self] in self.confirm(keyword: $0) }
            .disposed(by: rx.disposeBag)
        
        viewModel.registerButtonEnabled
            .bind(to: registerButton.rx.isEnabled)
            .disposed(by: rx.disposeBag)
        
        viewModel.keywords
            .bind(to: tableView.rx.items(cellIdentifier: "Cell")) { row, element, cell in
                cell.textLabel?.text = element
            }
            .disposed(by: rx.disposeBag)
        
        viewModel.clearKeywordTextField.map { "" }
            .bind(to: keywordTextField.rx.text)
            .disposed(by: rx.disposeBag)

        tableView.rx.itemSelected
            .withLatestFrom(viewModel.keywords) { $1[$0.row] }
            .map { FeedViewModel(keyword: $0) }
            .bind(to: feedNavigationSegue)
            .disposed(by: rx.disposeBag)
        
        tableView.rx.itemDeleted
            .withLatestFrom(viewModel.keywords) { $1[$0.row] }
            .bind { [unowned self] in self.viewModel.removeKeyword.onNext($0) }
            .disposed(by: rx.disposeBag)
    }
    
    private func confirm(keyword: String) {

        let actions: [AlertAction<DefaultConfirmResult>] = [
            AlertAction(style: .default, result: .ok),
            AlertAction(style: .destructive, result: .cancel)
        ]
        
        UIAlertController
            .rx.present(baseController: self, title: "Confirm", message: "Save \"\(keyword)\"? ", actions: actions)
            .bind { [unowned self] result in
                if case .ok = result {
                    self.viewModel.appendKeyword.onNext(keyword)
                }
            }.disposed(by: rx.disposeBag)
    }
}
