import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

final class KeywordController: UITableViewController {
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var keywordTextField: UITextField!
    
    private var viewModel: KeywordViewModel!
    
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
    }
    
    private func confirm(keyword: String) {
        enum Result: CustomStringConvertible {
            case ok
            case cancel
            
            var description: String {
                switch self {
                case .ok: return "OK"
                case .cancel: return "Cancel"
                }
            }
        }
        
        let actions: [AlertAction<Result>] = [
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
