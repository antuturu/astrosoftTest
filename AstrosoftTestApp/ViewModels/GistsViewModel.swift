import Foundation

final class GistsViewModel {
    private let gistsService = GistsService.shared
    private(set) var gists: [GistModel] = []
    var onDataChanged: (() -> Void)?

    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleDataChange),
            name: GistsService.gistsDidChangeNotification,
            object: nil
        )
        fetchGists()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func handleDataChange() {
        gists = gistsService.gists
        onDataChanged?()
    }

    func fetchGists() {
        gistsService.fetchNextGistsPage()
    }

    func refreshGists() {
        gistsService.refreshGistsData()
        gistsService.fetchNextGistsPage()
    }

    func numberOfGists() -> Int {
        return gists.count
    }

    func gist(at index: Int) -> GistModel {
        return gists[index]
    }

    func shouldLoadMoreGists(at index: Int) -> Bool {
        return index + 1 == gists.count
    }
}
