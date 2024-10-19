protocol CommitsViewModelProtocol {
    var onDataChanged: (() -> Void)? { get set }
    func fetchСommits()
    func numberOfItemsInGistSection() -> Int
    func getGist() -> GistModel?
    func getCommitsToTextField() -> String
    func getNextFile() -> FilesModel?
    func getNextKey() -> String
}
