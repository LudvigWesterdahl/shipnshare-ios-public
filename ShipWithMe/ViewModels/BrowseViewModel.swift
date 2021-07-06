//
//  BrowseViewModel.swift
//  ShipWithMe
//
//  Created by Ludvig Westerdahl on 2021-04-17.
//

import Foundation
import MapKit

class BrowseViewModel: ObservableObject {
    
    @Published var loading: Bool = false
    
    @Published var posts: [PostModel] = []
    
    @Published var searchResultString: String = ""
    
    @Published var distanceIndex: Int = 2
    
    private var distance: Double {
        if distanceIndex == 0 {
            return 100
        }
        
        if distanceIndex == 1 {
            return 500
        }
        
        //return 1000 * 1000
        return 1000
    }
    
    init() {
        loadPostsFromStorage()
    }
    
    private func includePost(post: PostModel) -> Bool {
        return post.metersToPickupLocation! <= distance
        /*
        if distanceIndex == 0 {
            return post.metersToPickupLocation <= distance
        }
        
        if distanceIndex == 1 {
            return 100 < post.metersToPickupLocation && post.metersToPickupLocation <= distance
        }
        
        return 500 < post.metersToPickupLocation && post.metersToPickupLocation <= distance
         */
    }
    
    func loadPostsFromStorage() -> Void {
        if let recentSearch = StorageManager.addressCoordinates.first {
            searchResultString = recentSearch.readableAddress
            loadPosts(latitude: recentSearch.latitude, longitude: recentSearch.longitude)
        }
    }
    
    func loadPosts(location: MKPlacemark) -> Void {
        loadPosts(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
    
    private func updatePost(post: PostModel) -> Void {
        if let index = posts.firstIndex(where: { $0.id == post.id }) {
            posts.remove(at: index)
            posts.insert(post, at: index)
        }
    }
    
    func loadPosts(latitude: Double, longitude: Double) -> Void {
        loading = true
        
        ApiManager.shared.getPosts(latitude: latitude,
                                   longitude: longitude,
                                   maxDistance: distance) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let postModels):
                    self.posts = postModels
                        .filter(self.includePost)
                        .sorted(by: { $0.metersToPickupLocation! < $1.metersToPickupLocation! })
                case .failure(let error):
                    print(error)
                    self.posts = []
                }
                self.loading = false
                
                self.loadImages()
            }
        }
    }
    
    func loadImages() -> Void {
        
        for post in posts {
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
}
