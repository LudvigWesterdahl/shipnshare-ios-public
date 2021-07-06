//
//  AccountViewModel.swift
//  ShipWithMe
//
//  Created by Ludvig Westerdahl on 2021-06-05.
//

import Foundation

class AccountViewModel: ObservableObject  {
    
    @Published var userName: String = ""
    
    @Published var userEmail: String = ""
    
    @Published var userPosts: [PostModel] = []
    
    @Published var numberOfCreatedPosts: Float = 0
    
    @Published var reviews: [ReviewModel] = []
    
    @Published var averageRatingString: String = ""
    
    @Published var userReviews: UserReviewsModel = UserReviewsModel.empty()
    
    private var userId: Int64
    
    var progressLevel: Float {
        for i in 1...10 {
            let c: Float = Float(truncating: pow(10.0, i) as NSNumber)
            
            if numberOfCreatedPosts < c {
                return c
            }
        }
        
        return numberOfCreatedPosts
    }
    
    
    init() {
        userName = StorageManager.userName!
        userEmail = StorageManager.email!
        userId = StorageManager.userId!
    }
    
    func load() -> Void {
        loadPosts()
        loadReviews()
        loadPostsCount()
    }
    
    private func updatePost(post: PostModel) -> Void {
        if let index = userPosts.firstIndex(where: { $0.id == post.id }) {
            userPosts.remove(at: index)
            userPosts.insert(post, at: index)
        }
    }
    
    private func loadPostsCount() -> Void {
        ApiManager.shared.getUserPosts(userId: userId, includeClosed: true) { posts in
            if let posts = posts {
                DispatchQueue.main.async {
                    self.numberOfCreatedPosts = Float(posts.count)
                }
            }
        }
    }
    
    private func loadPosts() -> Void {
        ApiManager.shared.getUserPosts(userId: userId) { posts in
            if let posts = posts {
                DispatchQueue.main.async {
                    self.userPosts = posts
                    self.loadImages()
                }
            }
        }
    }
    
    func loadImages() -> Void {
        for post in userPosts {
            ApiManager.shared.getPostImage(post: post) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let updatedPost):
                        self.updatePost(post: updatedPost)
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
    
    private func loadReviews() -> Void {
        ApiManager.shared.getUserReviews(for: userName) { userReviews in
            
            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 1
            
            if let userReviews = userReviews {
                DispatchQueue.main.async {
                    self.userReviews = userReviews
                    
                    self.reviews = self.userReviews.reviews
                        .sorted(by: { $0.createdAt > $1.createdAt })
                    
                    self.averageRatingString = formatter.string(from: self.userReviews.averageRating as NSNumber)!
                }
            }
        }
    }
    
    func delete(post: PostModel, completion: @escaping (Bool) -> Void) {
        ApiManager.shared.deletePost(postId: post.id) { succcess in
            if succcess {
                DispatchQueue.main.async {
                    self.userPosts.removeAll(where: { $0.id == post.id })
                    completion(true)
                }
            } else {
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
    
    func logOut(completion: @escaping () -> Void) -> Void {
        StorageManager.reset()
        completion()
    }
    
    func deleteSearches(completion: @escaping () -> Void) -> Void {
        StorageManager.addressCoordinates = []
        completion()
    }
}
