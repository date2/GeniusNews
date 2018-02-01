import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

final class KeywordViewController: UITableViewController {
    
    @IBOutlet var keywordRegisterView: KeywordRegisterView!
    
    private var viewModel: KeywordViewModel!
    
    var feedNavigationSegue: AnyObserver<FeedViewModel> {
        return NavigationSegue(
            fromViewController: self.navigationController,
            toViewControllerType: FeedViewController.self
        ).asObserver()
    }
    
    override var inputAccessoryView: UIView? {
        return keywordRegisterView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let keywordText = keywordRegisterView
            .textField.rx.text.map { $0 ?? "" }.asObservable()
        
        viewModel = KeywordViewModel(keywordText: keywordText)
        
        keywordRegisterView.registerButton.rx.tap
            .withLatestFrom(keywordText)
            .bind { [unowned self] in self.viewModel.appendKeyword.onNext($0) }
            .disposed(by: rx.disposeBag)
        
        viewModel.registerButtonEnabled
            .bind(to: keywordRegisterView.registerButton.rx.isEnabled)
            .disposed(by: rx.disposeBag)
        
        viewModel.keywords
            .bind(to: tableView.rx.items(cellIdentifier: "Cell")) { row, element, cell in
                cell.textLabel?.text = element
            }
            .disposed(by: rx.disposeBag)
        
        viewModel.clearKeywordTextField.map { "" }
            .bind(to: keywordRegisterView.textField.rx.text)
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
        
        rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .bind { [unowned self] _ in self.becomeFirstResponder() }
            .disposed(by: rx.disposeBag)
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
}



