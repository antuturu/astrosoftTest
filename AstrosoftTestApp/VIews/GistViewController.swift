import UIKit

final class GistViewController: UIViewController {
    
    private var viewModel: CommitsViewModel?
    private var vizov: Int = 0
    
    private let topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.backgroundColor = UIColor.systemGray6
        return view
    }()
    
    private let commitsView: UIView = {
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
    
    private lazy var gistCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width - 16, height: 150)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(GistCollectionViewCell.self, forCellWithReuseIdentifier: GistCollectionViewCell.reuseIdentifier)
        return collection
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return refreshControl
    }()
    
    private let scroll: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
    
        return scroll
    }()
    
    private let commitsTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 12)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.sizeToFit()
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        return textView
    }()
    
    init(viewModel: CommitsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureConstraints()
        setupBindings()
    }
    
    @objc private func refreshData() {
        viewModel?.fetchСommits()
        refreshControl.endRefreshing()
    }
    
    private func configureView() {
        view.addSubview(scroll)
        scroll.refreshControl = refreshControl
        view.backgroundColor = UIColor.white
        [topView, commitsView, gistCollectionView].forEach {
            scroll.addSubview($0)
        }
        commitsView.addSubview(commitsTextView)
        [imageAuthor, gistName, authorName].forEach {
            topView.addSubview($0)
        }
        gistCollectionView.dataSource = self
        gistCollectionView.delegate = self
        guard let viewModel = viewModel else { return }
        authorName.text = viewModel.getGist()?.owner.login
        gistName.text = viewModel.getGist()?.description
        if let url = URL(string: viewModel.getGist()?.owner.avatarUrl ?? "") {
            imageAuthor.kf.setImage(with: url)
        }
    }
    
    private func configureConstraints() {
        let width = view.frame.width - 16
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            topView.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: 8),
            topView.trailingAnchor.constraint(equalTo: scroll.trailingAnchor, constant: -8),
            topView.topAnchor.constraint(equalTo: scroll.topAnchor, constant: 8),
            topView.widthAnchor.constraint(equalToConstant: width),
            
            commitsView.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: 8),
            commitsView.trailingAnchor.constraint(equalTo: scroll.trailingAnchor, constant: -8),
            commitsView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 16),
            commitsView.widthAnchor.constraint(equalToConstant: width),

            commitsTextView.leadingAnchor.constraint(equalTo: commitsView.leadingAnchor, constant: 8),
            commitsTextView.trailingAnchor.constraint(equalTo: commitsView.trailingAnchor, constant: -8),
            commitsTextView.topAnchor.constraint(equalTo: commitsView.topAnchor, constant: 8),
            commitsTextView.bottomAnchor.constraint(equalTo: commitsView.bottomAnchor, constant: -8),
            
            imageAuthor.topAnchor.constraint(equalTo: topView.topAnchor, constant: 8),
            imageAuthor.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 8),
            imageAuthor.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -8),
            imageAuthor.heightAnchor.constraint(equalTo: imageAuthor.widthAnchor, multiplier: 1.0),
            
            gistName.topAnchor.constraint(equalTo: imageAuthor.bottomAnchor, constant: 8),
            gistName.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 8),
            gistName.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -8),
            
            authorName.topAnchor.constraint(equalTo: gistName.bottomAnchor, constant: 8),
            authorName.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 8),
            authorName.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -8),
            authorName.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -8),
            
            gistCollectionView.topAnchor.constraint(equalTo: commitsView.bottomAnchor, constant: 16),
            gistCollectionView.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: 8),
            gistCollectionView.trailingAnchor.constraint(equalTo: scroll.trailingAnchor, constant: -8),
            gistCollectionView.widthAnchor.constraint(equalToConstant: width),
            gistCollectionView.heightAnchor.constraint(equalToConstant: CGFloat(viewModel?.numberOfItemsInGistSection() ?? 0) * 160),
            gistCollectionView.bottomAnchor.constraint(equalTo: scroll.bottomAnchor)
        ])
    }
    
    private func setupBindings() {
        viewModel?.onDataChanged = { [weak self] in
            self?.gistCollectionView.reloadData()
            self?.viewModel?.refreshCurrentIndex()
            self?.setupCommitsText(text: self?.viewModel?.getCommitsToTextField() ?? "")
            self?.refreshControl.endRefreshing()
        }
        viewModel?.fetchСommits()
    }
    
    private func calculateCommitsTextViewHeight() -> CGFloat {
        let size = commitsTextView.sizeThatFits(CGSize(width: commitsTextView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        return size.height
    }
    
    private func setupCommitsText(text: String) {
        commitsTextView.text = text
        let height = calculateCommitsTextViewHeight()
        commitsView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = height + 16
            }
        }
        view.layoutIfNeeded()
    }
    
}

extension GistViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfItemsInGistSection() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GistCollectionViewCell.reuseIdentifier, for: indexPath) as? GistCollectionViewCell else { return UICollectionViewCell() }
        let data = viewModel?.getNextFile()
        cell.setupCell(name: viewModel?.getNextKey() ?? "", url: data?.rawUrl ?? "")
        cell.view = self
        return cell
    }
}

extension GistViewController: UICollectionViewDelegate {}
