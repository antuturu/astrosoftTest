import UIKit

final class AuthViewController: UIViewController, ConfigureUIProtocol {
    
    private let tokenService = TokenService()
    
    private let tokenTextField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.layer.cornerRadius = 16
        field.placeholder = "fine-grained token"
        field.setLeftPaddingPoints(15)
        return field
    }()
    
    private lazy var enterButton: UIButton = {
        let bttn = UIButton()
        bttn.translatesAutoresizingMaskIntoConstraints = false
        bttn.layer.cornerRadius = 16
        bttn.setTitle("Ввести", for: .normal)
        bttn.backgroundColor = .systemBlue
        bttn.addTarget(self, action: #selector(pushEnterButton), for: .touchUpInside)
        return bttn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureConstraints()
    }
    
    @objc
    private func pushEnterButton() {
        if let text = tokenTextField.text, !text.isEmpty {
            tokenService.token = text
            let authView = MainViewController()
            authView.modalPresentationStyle = .fullScreen
            present(authView, animated: true)
        }
    }
    
    func configureView() {
        [
            tokenTextField,
            enterButton
        ].forEach {
            view.addSubview($0)
        }
        
        tokenTextField.backgroundColor = UIColor.systemGray6
        view.backgroundColor = UIColor.white
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            tokenTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tokenTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tokenTextField.heightAnchor.constraint(equalToConstant: 34),
            tokenTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            enterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            enterButton.topAnchor.constraint(equalTo: tokenTextField.bottomAnchor, constant: 16),
            enterButton.widthAnchor.constraint(equalToConstant: 100)
            
        ])
    }
}


