import Foundation

final class CommitsViewModel: CommitsViewModelProtocol {
    private var currentIndex: Int = 0
    private var keys: [String] = []
    private let gistsService = GistsService.shared
    private(set) var commits: [CommitsModel] = []
    private var gist: GistModel?
    var onDataChanged: (() -> Void)?
    
    init(gist: GistModel) {
        self.gist = gist
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleDataChange),
            name: GistsService.commitsDidChangeNotification,
            object: nil
        )
        fetchСommits()
        keys += gist.files.keys
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func handleDataChange() {
        commits = gistsService.commits
        onDataChanged?()
    }
    
    func gistKeys() -> [String] {
        return keys
    }
    
    func getGist() -> GistModel? {
        guard let gist = gist else { return nil }
        return gist
    }
    
    func fetchСommits() {
        guard let gist = gist else { return }
        gistsService.refreshCommitsData()
        gistsService.fetchCommits(url: gist.commits_url)
    }
    
    func refreshCurrentIndex() {
        currentIndex = 0
    }
    
    func numberOfItemsInGistSection() -> Int {
        return gist?.files.count ?? 0 <= 5 ? gist?.files.count ?? 0 : 5
    }
    
    func updateCurrentIndex() {
        currentIndex += 1
    }
    
    func getNextKey() -> String {
        defer { updateCurrentIndex() }
        return keys[currentIndex]
    }
    
    func getNextFile() -> FilesModel? {
        guard let gist = gist else { return nil }
        let key = keys[currentIndex]
        return gist.files[key]
    }
    
    func getCommitsToTextField() -> String {
        var text = String()
        commits.forEach {
            text += "\($0.version) \($0.committedAt)\n"
        }
        return text
    }
}
