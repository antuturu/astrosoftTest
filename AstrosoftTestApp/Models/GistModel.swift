import Foundation

struct GistModel: Decodable {
    let description: String?
    let owner: OwnerModel
    let files: [String: FilesModel]
    let commits_url: String
}

