import UIKit

final class GistCollectionViewCell: UICollectionViewCell, ConfigureUIProtocol {
    static let reuseIdentifier = "gistCells"
    
    private var url: String = ""
    var view: GistViewController?
    
    private let tabView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.backgroundColor = UIColor.systemGray6
        return view
    }()
    
    private lazy var fileButton: UIButton = {
        let bttn = UIButton()
        bttn.translatesAutoresizingMaskIntoConstraints = false
        bttn.setTitleColor(UIColor.black, for: .normal)
        bttn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        bttn.addTarget(self, action: #selector(openGist), for: .touchUpInside)
        return bttn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func openGist() {
        guard let url = URL(string: url) else { return }
        let webViewVC = WebViewController()
        webViewVC.loadURL(url)
        self.view?.present(webViewVC, animated: true)
    }
    
    func setupCell(name: String, url: String) {
        fileButton.setTitle(name, for: .normal)
        self.url = url
    }
    
    func configureView() {
        contentView.addSubview(tabView)
        [
            fileButton
        ].forEach {
            tabView.addSubview($0)
        }
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            tabView.topAnchor.constraint(equalTo: contentView.topAnchor),
            tabView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            tabView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tabView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            fileButton.leadingAnchor.constraint(equalTo: tabView.leadingAnchor, constant: 8),
            fileButton.trailingAnchor.constraint(equalTo: tabView.trailingAnchor, constant: -8),
            fileButton.topAnchor.constraint(equalTo: tabView.topAnchor, constant: 8),
            fileButton.bottomAnchor.constraint(equalTo: tabView.bottomAnchor, constant: -8)
        ])
    }
    
}
