//
//  PostViewModel.swift
//  ShipWithMe
//
//  Created by Ludvig Westerdahl on 2021-05-15.
//

import Foundation

class PostViewModel: ObservableObject {
    
    @Published var loading: Bool = false
    
    @Published var canRequestToChat: Bool = false
    
    @Published var averageRating: String = ""
    
    @Published var userReviews: UserReviewsModel = UserReviewsModel.empty()
    
    init() {
        print("PostViewModel: init")
    }
    
    func load(post: PostModel, completion: @escaping () -> Void) -> Void {
        
        DispatchQueue.main.async {
            self.loading = true
        }
        
        ApiManager.shared.getSentChatRequest(for: post.id) { chatRequest in
            ApiManager.shared.getUserReviews(for: post.ownerUserName, reviewsCount: 0) { userReviews in
                
                let formatter = NumberFormatter()
                formatter.maximumFractionDigits = 1
                
                if let userReviews = userReviews {
                    DispatchQueue.main.async {
                        self.canRequestToChat = chatRequest == nil
                            && StorageManager.userName != nil
                            && post.ownerUserName != StorageManager.userName!
                        
                        print("Found userreviews: \(userReviews)")
                        self.userReviews = userReviews
                        
                        self.averageRating = formatter.string(from: self.userReviews.averageRating as NSNumber)!
                    }
                }
                
                DispatchQueue.main.async {
                    self.loading = false
                    completion()
                }
            }
        }
    }
    
    func loadImage(for post: PostModel, completion: @escaping (PostModel) -> Void) -> Void {
        ApiManager.shared.getPostImage(post: post) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let updatedPost):
                    completion(updatedPost)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func requestToChat(for post: PostModel) -> Void {
        print("PostViewModel: requestToChat")
        self.loading = true
        ApiManager.shared.createChat(for: post.id) { success in
            print("Success: \(success)")
            self.load(post: post) {
                
            }
        }
    }
    
    func delete(post: PostModel, completion: @escaping () -> Void) -> Void {
        self.loading = true
        ApiManager.shared.deletePost(postId: post.id) { success in
            DispatchQueue.main.async {
                self.loading = false
                if success {
                    completion()
                }
            }
        }
    }
}
