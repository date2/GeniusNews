import UIKit
import RxSwift

protocol Injectable where Self: UIViewController {
    associatedtype Dependency
    
    static func make(dependency: Dependency) -> Self
}

struct NavigationSegue<
    FromViewControllerType: UINavigationController,
    ToViewController: Injectable, Dependency>: ObserverType
    where Dependency == ToViewController.Dependency {
    
    typealias E = Dependency
    typealias T = FromViewControllerType
    typealias U = ToViewController
    
    private weak var fromViewController: T?
    private let toViewControllerType: U.Type
    private let animated: Bool
    
    init(fromViewController: T?, toViewControllerType: U.Type, animated: Bool = true) {
        self.fromViewController = fromViewController
        self.toViewControllerType = toViewControllerType
        self.animated = animated
    }
    
    func on(_ event: Event<Dependency>) {
        MainScheduler.ensureExecutingOnScheduler()
        
        switch event {
        case .next(let element):
            guard let fromViewController = fromViewController else { return }
            let toViewController = toViewControllerType.make(dependency: element)
            fromViewController.pushViewController(toViewController, animated: animated)
        case .error, .completed:
            break
        }
    }
}
