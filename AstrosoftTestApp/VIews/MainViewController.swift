import UIKit

final class MainViewController: UIViewController, ConfigureUIProtocol {
    private let viewModel = GistsViewModel()
    
    private let mainTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.layer.masksToBounds = true
        table.separatorStyle = .none
        table.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.reuseIdentifier)
        return table
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return refresh
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupBindings()
        configureView()
        configureConstraints()
    }
    
    private func setupBindings() {
        viewModel.onDataChanged = { [weak self] in
            self?.mainTableView.reloadData()
        }
    }

    func configureView() {
        view.addSubview(mainTableView)
        mainTableView.dataSource = self
        mainTableView.delegate = self
        mainTableView.refreshControl = refreshControl
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            mainTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mainTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func refreshData() {
        viewModel.refreshGists()
        refreshControl.endRefreshing()
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfGists()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.reuseIdentifier, for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        let data = viewModel.gist(at: indexPath.row)
        cell.selectionStyle = .none
        cell.setupCell(name: data.owner.login, gistName: data.description ?? "No gist name", avatarUrl: data.owner.avatarUrl)
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if viewModel.shouldLoadMoreGists(at: indexPath.row) {
            viewModel.fetchGists()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gist = viewModel.gist(at: indexPath.row)
        let commitsViewModel = CommitsViewModel(gist: gist)
        let gistViewController = GistViewController(viewModel: commitsViewModel)
        let navigationController = UINavigationController(rootViewController: gistViewController)
        navigationController.navigationBar.isHidden = true
        present(navigationController, animated: true)
    }
}
