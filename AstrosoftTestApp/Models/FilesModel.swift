import Foundation

struct FilesModel: Decodable {
    let rawUrl: String
    
    private enum CodingKeys : String, CodingKey {
        case rawUrl = "raw_url"
    }
}
