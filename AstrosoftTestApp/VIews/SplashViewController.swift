import UIKit

final class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if TokenService().token != nil {
            let mainView = MainViewController()
            mainView.modalPresentationStyle = .fullScreen
            present(mainView, animated: true)
        } else {
            let authView = AuthViewController()
            authView.modalPresentationStyle = .fullScreen
            present(authView, animated: true)
        }
    }
}
