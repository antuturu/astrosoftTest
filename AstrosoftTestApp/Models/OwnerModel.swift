import Foundation

struct OwnerModel: Decodable {
    let login: String
    let avatarUrl: String
    
    private enum CodingKeys : String, CodingKey {
        case avatarUrl = "avatar_url"
        case login
    }
}
