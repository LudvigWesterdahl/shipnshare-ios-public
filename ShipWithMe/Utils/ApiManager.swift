
import Foundation


enum NetworkError: Error {
    case authError
    case decodingError(_ data: String, _ statusCode: Int)
    case unknownError
}

extension DateFormatter {
    static let defaultFormat: String = "yyyy-MM-dd HH:mm:ss"
}


extension Data {
    var prettyPrintedJSONString: NSString? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        
        return prettyPrintedString
    }
}

final class ApiManager {
    
    private static let delaySeconds: Int = 0
    
    static let shared = ApiManager(baseUrl: InfoHelper.apiUrl)
    
    private let baseUrl: String
    
    private init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    private var baseUrlComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = baseUrl
        if InfoHelper.isDebug {
            components.port = 5050
        }

        return components
    }
    
    private var authenticateUrl: URL {
        var components = baseUrlComponents
        components.path = "/api/users/authenticate"
        return components.url!
    }
    
    private var postsUrl: URL {
        var components = baseUrlComponents
        components.path = "/api/posts"
        return components.url!
    }
    
    private func getPostUrl(postId: String) -> URL {
        var components = baseUrlComponents
        components.path = "/api/posts/\(postId)"
        return components.url!
    }
    
    private func getPostsUrl(latitude: Double, longitude: Double, maxDistance: Double) -> URL {
        var components = baseUrlComponents
        components.path = "/api/posts"
        components.queryItems = [
            URLQueryItem(name: "latitude", value: String(latitude)),
            URLQueryItem(name: "longitude", value: String(longitude)),
            URLQueryItem(name: "maxDistance", value: String(maxDistance))
        ]
        return components.url!
    }
    
    private var refreshAuthenticateUrl: URL {
        var components = baseUrlComponents
        components.path = "/api/users/refresh_authenticate"
        return components.url!
    }
    
    private func getUserInfoUrl(userName: String? = nil) -> URL {
        var components = baseUrlComponents
        components.path = "/api/users/info"
        if let userName = userName {
            components.queryItems = [
                URLQueryItem(name: "username", value: userName),
            ]
        }
        
        return components.url!
    }
    
    private func getPostImageUrl(imagePath: String) -> URL {
        var components = baseUrlComponents
        components.path = "/" + imagePath
        
        return components.url!
    }
    
    private var chatRequestsUrl: URL {
        var components = baseUrlComponents
        components.path = "/api/chats/requests"
        
        return components.url!
    }
    
    private var chatMessageUrl: URL {
        var components = baseUrlComponents
        components.path = "/api/chats/message"
        
        return components.url!
    }
    
    private func getChatsUrl(messagesCount: Int, chatId: String? = nil) -> URL {
        var components = baseUrlComponents
        
        if let chatId = chatId {
            components.path = "/api/chats/\(chatId)"
        } else {
            components.path = "/api/chats"
        }
        
        components.queryItems = [
            URLQueryItem(name: "messagescount", value: String(messagesCount))
        ]
        
        return components.url!
    }
    
    private func getChatByPostIdUrl(postId: String) -> URL {
        var components = baseUrlComponents
        components.path = "/api/chats/post/\(postId)"
        
        return components.url!
    }
    
    private func getUserReviewsUrl(userName: String? = nil, userId: Int? = nil, reviewsCount: Int? = nil) -> URL {
        var components = baseUrlComponents
        components.path = "/api/users/reviews"
        
        var queryItems: [URLQueryItem] = []
        
        if let userName = userName {
            queryItems.append(URLQueryItem(name: "username", value: userName))
        }
        
        if let userId = userId {
            queryItems.append(URLQueryItem(name: "userid", value: String(userId)))
        }
        
        if let reviewsCount = reviewsCount {
            queryItems.append(URLQueryItem(name: "reviewscount", value: String(reviewsCount)))
        }
        
        components.queryItems = queryItems
        
        return components.url!
    }
    
    private func getSentChatRequestsUrl(postId: String? = nil) -> URL {
        var components = baseUrlComponents
        components.path = "/api/chats/requests/sent"
        
        if let postId = postId {
            components.path += "/\(postId)"
        }
        
        return components.url!
    }
    
    private func getDeletePostUrl(postId: String) -> URL {
        var components = baseUrlComponents
        components.path = "/api/posts/close/\(postId)"
        
        return components.url!
    }
    
    private func getPostByChatIdUrl(chatId: String) -> URL {
        var components = baseUrlComponents
        components.path = "/api/chats/\(chatId)/post"
        
        return components.url!
    }
    
    private func getCanReviewPostUrl(postId: String) -> URL {
        var components = baseUrlComponents
        components.path = "/api/users/canreview/\(postId)"
        
        return components.url!
    }
    
    private var leaveChatUrl: URL {
        var components = baseUrlComponents
        components.path = "/api/chats/leave"
        
        return components.url!
    }
    
    private func getUserPostsUrl(userId: Int64, includeClosed: Bool = false) -> URL {
        var components = baseUrlComponents
        components.path = "/api/posts/user/\(userId)"
        
        components.queryItems = [
            URLQueryItem(name: "includeClosed", value: String(includeClosed))
        ]
        
        return components.url!
    }
    
    private var usersUrl: URL {
        var components = baseUrlComponents
        components.path = "/api/users"
        
        return components.url!
    }
    
    private var resetPasswordUrl: URL {
        var components = baseUrlComponents
        components.path = "/api/users/resetpassword"
        
        return components.url!
    }
    
    private var timezonesUrl: URL {
        var components = baseUrlComponents
        components.path = "/api/posts/timezones"
        
        return components.url!
    }
    
    private func toData<T: Encodable>(_ value: T) -> Data {
        let encoder = JSONEncoder()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        encoder.dateEncodingStrategy = .formatted(formatter)
        
        let jsonBody = try! encoder.encode(value)
        return jsonBody
    }
    
    private func toData(_ value: [String: Any]) -> Data {
        let jsonBody = try! JSONSerialization.data(withJSONObject: value)
        return jsonBody
    }
    
    
    private func newRequest(url: URL, method: String, jsonBody: Data?, _ anonymous: Bool = false) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        
        if method != "GET" {
            request.httpBody = jsonBody
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("1.0", forHTTPHeaderField: "X-Version")
        
        if !anonymous {
            if let token = StorageManager.token {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
        }
        
        return request
    }
    
    private func refreshAuthenticate(continuation: @escaping (Bool) -> Void) -> Void {
        
        guard let refreshToken = StorageManager.refreshToken else {
            continuation(false)
            return
        }
        
        let body: [String: String] = ["refreshToken": refreshToken]
        let jsonBody = try! JSONSerialization.data(withJSONObject: body)
        let request = newRequest(url: refreshAuthenticateUrl, method: "POST", jsonBody: jsonBody, true)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                StorageManager.refreshToken = nil
                continuation(false)
                return
            }
            
            let authenticateModel = try? JSONDecoder().decode(AuthenticateResponse.self, from: data)
            
            if let authenticateModel = authenticateModel {
                StorageManager.token = authenticateModel.token
                StorageManager.refreshToken = authenticateModel.refreshToken
                continuation(true)
            } else {
                continuation(false)
            }
            return
        }.resume()
    }
    
    private func sendBase<T>(url: URL,
                             method: String,
                             callback: @escaping (Result<T, NetworkError>) -> Void,
                             body: Data? = nil,
                             _ anonymous: Bool = false,
                             _ maxRetryCount: Int = 2,
                             decoder: @escaping (Data, Int) -> T?) -> Void {
        if maxRetryCount < 0 {
            callback(.failure(.authError))
            return
        }
        
        let request = newRequest(url: url, method: method, jsonBody: body, anonymous)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                callback(.failure(.unknownError))
                return
            }
            
            guard let data = data else {
                callback(.failure(.unknownError))
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                callback(.failure(.unknownError))
                return
            }
            
            guard statusCode <= 400 else {
                callback(.failure(.unknownError))
                return
            }
            
            if statusCode == 401 {
                
                guard maxRetryCount > 0 else {
                    callback(.failure(.authError))
                    return
                }
                
                
                self.refreshAuthenticate { _ in
                    self.sendBase(url: url,
                                  method: method,
                                  callback: callback,
                                  body: body,
                                  anonymous,
                                  maxRetryCount - 1,
                                  decoder: decoder)
                }
                return
            }
            
            guard let decodedResponse = decoder(data, statusCode) else {
                let jsonString = String(decoding: data, as: UTF8.self)
                if let prettyPrint = data.prettyPrintedJSONString {
                    print(prettyPrint)
                }
                callback(.failure(.decodingError(jsonString, statusCode)))
                return
            }
            
            callback(.success(decodedResponse))
        }.resume()
        
    }
    
    private func send(url: URL,
                      method: String,
                      callback: @escaping (Result<Bool, NetworkError>) -> Void,
                      body: Data? = nil,
                      _ anonymous: Bool = false,
                      _ maxRetryCount: Int = 2) -> Void {
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now().advanced(by: DispatchTimeInterval.seconds(ApiManager.delaySeconds))) {
            self.sendBase(url: url,
                          method: method,
                          callback: callback,
                          body: body,
                          anonymous,
                          maxRetryCount) { data, statusCode in
                return 200 <= statusCode && statusCode <= 300
            }
        }
    }
    
    private func send<T: Decodable>(url: URL,
                                    method: String,
                                    callback: @escaping (Result<T, NetworkError>) -> Void,
                                    body: Data? = nil,
                                    _ anonymous: Bool = false,
                                    _ maxRetryCount: Int = 2) -> Void {
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now().advanced(by: DispatchTimeInterval.seconds(ApiManager.delaySeconds))) {
            self.sendBase(url: url,
                          method: method,
                          callback: callback,
                          body: body,
                          anonymous,
                          maxRetryCount) { data, statusCode in
                if T.self == Data.self {
                    return data as? T
                }
                
                let decoder = JSONDecoder()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                formatter.timeZone = TimeZone(identifier: "UTC")
                decoder.dateDecodingStrategy = .formatted(formatter)
                
                do {
                    let jsonResponse = try decoder.decode(T.self, from: data)
                    return jsonResponse
                } catch {
                    print(error)
                    return nil
                }
            }
        }
    }
    
    private func storeUserInfo(continuation: @escaping (Bool) -> Void) -> Void {
        send(url: getUserInfoUrl(), method: "GET") { (result: Result<UserInfoResponse, NetworkError>) in
            switch result {
            case .success(let userInfoModel):
                StorageManager.userId = userInfoModel.userId
                StorageManager.userName = userInfoModel.userName
                continuation(true)
            case .failure:
                continuation(false)
            }
        }
    }
    
    func tryAuthenticate(completion: @escaping (Bool) -> Void) -> Void {
        self.refreshAuthenticate { authSuccess in
            guard authSuccess else {
                completion(false)
                return
            }
            
            self.storeUserInfo { userInfoSuccess in
                if userInfoSuccess {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    func authenticate(_ email: String,
                      _ password: String,
                      completion: @escaping (Result<Bool, NetworkError>) -> Void) -> Void {
        let body = toData(AuthenticateRequest(email: email, password: password))
        
        send(url: authenticateUrl, method: "POST", callback: { (result: Result<AuthenticateResponse, NetworkError>) in
            switch result {
            case .success(let authenticateModel):
                StorageManager.token = authenticateModel.token
                StorageManager.refreshToken = authenticateModel.refreshToken
                
                self.storeUserInfo { success in
                    if success {
                        completion(.success(true))
                    }
                    else {
                        completion(.failure(.unknownError))
                    }
                }
                
                return
            case .failure(let error):
                completion(.failure(error))
                return
            }
        }, body: body, true, 0)
    }
    
    func getPosts(latitude: Double,
                  longitude: Double,
                  maxDistance: Double,
                  completion: @escaping (Result<[PostModel], NetworkError>) -> Void) -> Void {
        let url = self.getPostsUrl(latitude: latitude, longitude: longitude, maxDistance: maxDistance)
        send(url: url, method: "GET", callback: { (result: Result<[PostModel], NetworkError>) in
            switch result {
            case .success(let postModels):
                completion(.success(postModels))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }, body: nil, true, 1)
    }
    
    func getPost(by postId: String,
                 completion: @escaping (PostModel?) -> Void) -> Void {
        let url = self.getPostUrl(postId: postId)
        
        send(url: url, method: "GET") { (result: Result<PostModel, NetworkError>) in
            switch result {
            case .success(let postModel):
                completion(postModel)
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
    
    func getPostImage(post: PostModel, completion: @escaping (Result<PostModel, NetworkError>) -> Void) -> Void {
        guard let imagePath = post.imagePath else {
            completion(.failure(.unknownError))
            return
        }
        
        //let url = post.imagePath != nil ? self.getPostImageUrl(imagePath: post.imagePath!) : post.faviconUri
        
        let url = self.getPostImageUrl(imagePath: imagePath)
        
        send(url: url, method: "GET", callback: { (result: Result<Data, NetworkError>) in
            switch result {
            case .success(let image):
                let updatedPost = PostModel(id: post.id,
                                            ownerUserName: post.ownerUserName,
                                            createdAt: post.createdAt,
                                            createdAtTimeZone: post.createdAtTimeZone,
                                            latitudePickupLocation: post.latitudePickupLocation,
                                            longitudePickupLocation: post.longitudePickupLocation,
                                            offerValueTitle: post.offerValueTitle,
                                            description: post.description,
                                            storeOrProductUri: post.storeOrProductUri,
                                            shippingCost: post.shippingCost,
                                            currency: post.currency,
                                            tags: post.tags,
                                            faviconUri: post.faviconUri,
                                            metersToPickupLocation: post.metersToPickupLocation,
                                            imagePath: post.imagePath,
                                            imageData: image)
                completion(.success(updatedPost))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }, body: nil, true, 1)
    }
    
    func createPost(_ createPostRequest: CreatePostRequest, completion: @escaping (Bool) -> Void) -> Void {
        send(url: postsUrl, method: "POST", callback: { (result: Result<Bool, NetworkError>) in
            switch result {
            case .success(let success):
                completion(success)
            case .failure(_):
                completion(false)
            }
        }, body: toData(createPostRequest))
    }
    
    func createChat(for postId: String, completion: @escaping (Bool) -> Void) -> Void {
        let url = getChatByPostIdUrl(postId: postId)
        
        send(url: url, method: "POST", callback: { (result: Result<Bool, NetworkError>) in
            switch result {
            case .success(let success):
                completion(success)
            case .failure(let error):
                print(error)
                completion(false)
            }
        })
    }
    
    func getChat(for postId: String, messagesCount: Int = 10, completion: @escaping (ChatModel?, Bool) -> Void) -> Void {
        let url = getChatByPostIdUrl(postId: postId)
        
        send(url: url, method: "GET", callback: { (result: Result<PostChatResponse, NetworkError>) in
            switch result {
            case .success(let response):
                completion(response.chat, true)
            case .failure(let error):
                print(error)
                completion(nil, false)
            }
        })
    }
    
    func getChatRequests(completion: @escaping ([ChatRequestModel]) -> Void) -> Void {
        send(url: chatRequestsUrl, method: "GET", callback: { (result: Result<[ChatRequestModel], NetworkError>) in
            switch result {
            case .success(let requests):
                completion(requests)
            case .failure(let error):
                print(error)
                completion([])
            }
        })
    }
    
    func getSentChatRequest(for postId: String, completion: @escaping (ChatRequestModel?) -> Void) -> Void {
        let url = getSentChatRequestsUrl(postId: postId)
        
        send(url: url, method: "GET", callback: { (result: Result<ChatRequestModel, NetworkError>) in
            switch result {
            case .success(let chatRequest):
                completion(chatRequest)
            case .failure(let error):
                print(error)
                completion(nil)
            }
        })
    }
    
    func getSentChatRequests(completion: @escaping ([ChatRequestModel]) -> Void) -> Void {
        let url = getSentChatRequestsUrl()
        
        send(url: url, method: "GET", callback: { (result: Result<[ChatRequestModel], NetworkError>) in
            switch result {
            case .success(let models):
                completion(models)
            case .failure(let error):
                print(error)
                completion([])
            }
        })
    }
    
    func answerChatRequest(for chatRequestId: String, accept: Bool, completion: @escaping (Bool) -> Void) -> Void {
        send(url: chatRequestsUrl, method: "POST", callback: { (result: Result<Bool, NetworkError>) in
            switch result {
            case .success(let success):
                completion(success)
            case .failure(let error):
                print(error)
                completion(false)
            }
        }, body: toData(["chatrequestid": chatRequestId, "accept": accept]))
    }
    
    func getChats(messagesCount: Int = -1, completion: @escaping ([ChatModel]) -> Void) -> Void {
        send(url: getChatsUrl(messagesCount: messagesCount),
             method: "GET",
             callback: { (result: Result<[ChatModel], NetworkError>) in
                switch result {
                case .success(let models):
                    completion(models)
                case .failure(let error):
                    print(error)
                    completion([])
                }
             })
    }
    
    func getUserReviews(for userName: String,
                        reviewsCount: Int? = nil,
                        completion: @escaping (UserReviewsModel?) -> Void) -> Void {
        let url = getUserReviewsUrl(userName: userName, reviewsCount: reviewsCount)
        
        send(url: url, method: "GET", callback: { (result: Result<UserReviewsModel, NetworkError>) in
            switch result {
            case .success(let userReviewsModel):
                completion(userReviewsModel)
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }, body: nil, true, 1)
    }
    
    func deletePost(postId: String, completion: @escaping (Bool) -> Void) -> Void {
        let url = getDeletePostUrl(postId: postId)
        
        send(url: url, method: "POST", callback: { (result: Result<Bool, NetworkError>) in
            switch result {
            case .success(let success):
                completion(success)
            case .failure(let error):
                print(error)
                completion(false)
            }
        })
    }
    
    func getPostByChatId(chatId: String, completion: @escaping (PostModel?) -> Void) -> Void {
        let url = getPostByChatIdUrl(chatId: chatId)
        
        send(url: url, method: "GET", callback: { (result: Result<PostModel, NetworkError>) in
            switch result {
            case .success(let post):
                completion(post)
            case .failure(let error):
                print(error)
                completion(nil)
            }
        })
    }
    
    func getChat(chatId: String, messagesCount: Int = -1, completion: @escaping (ChatModel?) -> Void) -> Void {
        let url = getChatsUrl(messagesCount: messagesCount, chatId: chatId)
        
        send(url: url, method: "GET", callback: { (result: Result<ChatModel, NetworkError>) in
            switch result {
            case .success(let chat):
                completion(chat)
            case .failure(let error):
                print(error)
                completion(nil)
            }
        })
    }
    
    func sendChatMessage(for chatId: String, message: String, completion: @escaping (Bool) -> Void) -> Void {
        let url = chatMessageUrl
        let request = ChatMessageRequest(chatId: chatId, message: message)
        
        send(url: url, method: "POST", callback: { (result: Result<Bool, NetworkError>) in
            switch result {
            case .success(let success):
                completion(success)
            case .failure(let error):
                print(error)
                completion(false)
            }
        }, body: toData(request))
    }
    
    func canReview(postId: String, completion: @escaping (Bool) -> Void) -> Void {
        let url = getCanReviewPostUrl(postId: postId)
        
        send(url: url, method: "GET", callback: { (result: Result<CanReviewResponse, NetworkError>) in
            switch result {
            case .success(let response):
                print(response)
                completion(response.canReview)
            case .failure(let error):
                print(error)
                completion(false)
            }
        })
    }
    
    func review(postId: String, rating: Int, message: String, completion: @escaping (Bool) -> Void) -> Void {
        let url = getUserReviewsUrl()
        let request = ReviewRequest(postId: postId, rating: rating, message: message)
        
        send(url: url, method: "POST", callback: { (result: Result<Bool, NetworkError>) in
            switch result {
            case .success(let success):
                completion(success)
            case .failure(let error):
                print(error)
                completion(false)
            }
        }, body: toData(request))
    }
    
    func leaveChat(chatId: String, completion: @escaping (Bool) -> Void) -> Void {
        let url = leaveChatUrl
        
        send(url: url, method: "POST", callback: { (result: Result<Bool, NetworkError>) in
            switch result {
            case .success(let success):
                completion(success)
            case .failure(let error):
                print(error)
                completion(false)
            }
        }, body: toData(["chatId": chatId]))
    }
    
    func getUserPosts(userId: Int64, includeClosed: Bool = false, completion: @escaping ([PostModel]?) -> Void) -> Void {
        let url = getUserPostsUrl(userId: userId, includeClosed: includeClosed)
        
        send(url: url, method: "GET", callback: { (result: Result<[PostModel], NetworkError>) in
            switch result {
            case .success(let posts):
                completion(posts)
            case .failure(let error):
                print(error)
                completion(nil)
            }
        })
    }
    
    func register(email: String, userName: String, password: String, completion: @escaping (Bool) -> Void) -> Void {
        let url = usersUrl
        let request = CreateUserRequest(email: email, userName: userName, password: password)
        
        send(url: url, method: "POST", callback: { (result: Result<Bool, NetworkError>) in
            switch result {
            case .success(let success):
                completion(success)
            case .failure(let error):
                print(error)
                completion(false)
            }
        }, body: toData(request))
    }
    
    func resetPassword(email: String, completion: @escaping (Bool) -> Void) -> Void {
        let url = resetPasswordUrl
        let request = ["email": email]
        
        send(url: url, method: "POST", callback: { (result: Result<Bool, NetworkError>) in
            switch result {
            case .success(let success):
                completion(success)
            case .failure(let error):
                print(error)
                completion(false)
            }
        }, body: toData(request))
    }
    
    func getTimezones(completion: @escaping (Bool) -> Void) -> Void {
        
        let url = timezonesUrl
        
        send(url: url, method: "GET", callback: { (result: Result<Bool, NetworkError>) in
            switch result {
            case .success(_):
                completion(true)
            case .failure(let error):
                print(error)
                completion(false)
            }
        }, body: nil, false, 2)
    }
}
