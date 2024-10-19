import UIKit
import Kingfisher

final class MainTableViewCell: UITableViewCell {
    static let reuseIdentifier = "MainCell"
    
    private let backgroundViews: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.backgroundColor = UIColor.systemGray6
        
        return view
    }()
    
    private let imageAuthor: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(systemName: "person.circle")
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    private let gistName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    private let authorName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
        configureConstraits()
    }
    
    override public func prepareForReuse() {
        super.prepareForReuse()
        imageAuthor.kf.cancelDownloadTask()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        contentView.addSubview(backgroundViews)
        [
        imageAuthor,
        gistName,
        authorName
        ].forEach {
            backgroundViews.addSubview($0)
        }
    }
    
    private func configureConstraits() {
        NSLayoutConstraint.activate([
            backgroundViews.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundViews.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundViews.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundViews.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            imageAuthor.topAnchor.constraint(equalTo: backgroundViews.topAnchor, constant: 8),
            imageAuthor.leadingAnchor.constraint(equalTo: backgroundViews.leadingAnchor, constant: 8),
            imageAuthor.trailingAnchor.constraint(equalTo: backgroundViews.trailingAnchor, constant: -8),
            imageAuthor.heightAnchor.constraint(equalTo: imageAuthor.widthAnchor, multiplier: imageAuthor.image!.size.height / imageAuthor.image!.size.width),
            
            gistName.topAnchor.constraint(equalTo: imageAuthor.bottomAnchor, constant: 8),
            gistName.leadingAnchor.constraint(equalTo: backgroundViews.leadingAnchor, constant: 8),
            gistName.trailingAnchor.constraint(equalTo: backgroundViews.trailingAnchor, constant: -8),
            
            authorName.topAnchor.constraint(equalTo: gistName.bottomAnchor, constant: 8),
            authorName.leadingAnchor.constraint(equalTo: backgroundViews.leadingAnchor, constant: 8),
            authorName.trailingAnchor.constraint(equalTo: backgroundViews.trailingAnchor, constant: -8),
            authorName.bottomAnchor.constraint(equalTo: backgroundViews.bottomAnchor, constant: -8)
        ])
    }
    
    func setupCell(name: String, gistName: String, avatarUrl: String) {
        self.authorName.text = name
        self.gistName.text = gistName
        let url = URL(string: avatarUrl)
        imageAuthor.kf.setImage(with: url)
    }
}
