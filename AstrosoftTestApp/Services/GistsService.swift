import Foundation

final class GistsService {
    private (set) var gists: [GistModel] = []
    private (set) var commits: [CommitsModel] = []
    private var gistsPage: Int = 1
    private var task: URLSessionTask?
    private let token = TokenService().token
    private let urlSession = URLSession.shared
    static let shared = GistsService()
    static let gistsDidChangeNotification = Notification.Name(rawValue: "GistsDidChange")
    static let commitsDidChangeNotification = Notification.Name(rawValue: "CommitsDidChange")
    
    func fetchNextGistsPage() {
        if task != nil {
            return
        }
        var urlComponents = URLComponents(string: "https://api.github.com/gists/public")
        urlComponents?.queryItems = [
            URLQueryItem(name: "per_page", value: "\(10)"),
            URLQueryItem(name: "page", value: "\(gistsPage)")
        ]
        
        guard let url = urlComponents?.url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        guard let token = token else{
            return
        }
        request.addValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("2022-11-28", forHTTPHeaderField: "X-GitHub-Api-Version")
        let task = urlSession.objectTask(for: request) {[weak self] (result: Result<[GistModel], Error>)  in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let results):
                    self.gists += results
                    self.gistsPage += 1
                    NotificationCenter.default.post(
                        name: GistsService.gistsDidChangeNotification,
                        object: self,
                        userInfo: ["Gists": self.gists])
                case .failure(let error):
                    print("ошибка \(error)")
                }
                self.task = nil
            }
        }
        self.task = task
        task.resume()
    }
    
    func fetchCommits(url: String) {
        if task != nil {
            return
        }
        var urlComponents = URLComponents(string: url)
        
        guard let url = urlComponents?.url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        guard let token = token else{
            return
        }
        request.addValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("2022-11-28", forHTTPHeaderField: "X-GitHub-Api-Version")
        let task = urlSession.objectTask(for: request) {[weak self] (result: Result<[CommitsModel], Error>)  in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let results):
                    self.commits += results
                    NotificationCenter.default.post(
                        name: GistsService.commitsDidChangeNotification,
                        object: self,
                        userInfo: ["Commits": self.commits])
                case .failure(let error):
                    print("ошибка \(error)")
                }
                self.task = nil
            }
        }
        self.task = task
        task.resume()
    }
    
    func refreshGistsData() {
        gistsPage = 1
        gists = []
    }
    
    func refreshCommitsData() {
        commits = []
    }
}
