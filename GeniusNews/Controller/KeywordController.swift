import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

final class KeywordController: UITableViewController {
    
    @IBOutlet weak var registerButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerButton.rx.tap
            .bind {
            }.disposed(by: rx.disposeBag)
        
        
        
    }
    
}
