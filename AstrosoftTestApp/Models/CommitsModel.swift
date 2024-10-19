import Foundation

struct CommitsModel: Decodable {
    let version: String
    let committedAt: String
    
    private enum CodingKeys : String, CodingKey {
        case version = "version"
        case committedAt = "committed_at"
    }
}
