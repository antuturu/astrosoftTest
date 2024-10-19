import Foundation
import SwiftKeychainWrapper

final class TokenService {
    
    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: "BearerToken")
        }
        set {
            let token = newValue
            guard let token = token else { return }
            let isSuccess = KeychainWrapper.standard.set(token, forKey: "BearerToken")
            guard isSuccess else {
                return
            }
        }
    }
}
