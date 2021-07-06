
import Foundation

struct UserInfoResponse: Decodable {
    let userId: Int64
    let userName: String
    let hasRequestedUserInfo: Bool
    let requestedUserId: Int64
    let requestedUserName: String?
}
