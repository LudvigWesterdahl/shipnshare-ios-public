//
//  CreatePostViewModel.swift
//  ShipWithMe
//
//  Created by Ludvig Westerdahl on 2021-04-24.
//

import Foundation
import CoreLocation
import SwiftUI

class CreatePostViewModel: ObservableObject {
    
    @Published var image: UIImage?
    
    @Published var title: String = ""
    
    @Published var description: String = ""
    
    @Published var shippingAddress: String = ""
    
    @Published var shippingCost: String = ""
    
    @Published var currency: String = Locale.current.currencyCode ?? Locale.isoCurrencyCodes[0]
    
    @Published var tags: [String] = []
    
    @Published var isLoading: Bool = false
    
    @Published var wasPostUploaded: Bool = false
    
    var postUploadSuccess: Bool? = nil
    
    // Uncomment this if user coordinates is needed.
    //private var locationManager: LocationManager = LocationManager()
    
    private var userLatitude: Double?
    
    private var userLongitude: Double?
    
    init() {
        // Uncomment this if user coordinates is needed.
        /*
        locationManager.onLocation { latitude, longitude in
            self.userLatitude = latitude
            self.userLongitude = longitude
        }
        */
    }
    
    var currencies: [String] = Locale.isoCurrencyCodes
    
    var isValid: Bool {
        return !title.isEmpty
            && !description.isEmpty
            && userLatitude != nil
            && userLongitude != nil
            && NumberFormatter().number(from: shippingCost) != nil
            && !currency.isEmpty
    }
    
    
    func onAddress() -> Void {
        if let recentSearch = StorageManager.addressCoordinates.first {
            userLatitude = recentSearch.latitude
            userLongitude = recentSearch.longitude
        }
    }
    
    func createPostRequest(timeZone: String) -> CreatePostRequest {
        
        let numberShippingCost = NumberFormatter().number(from: shippingCost)!
        let recentSearch = StorageManager.addressCoordinates.first!
        
        let imageType = image != nil ? "jpeg" : nil
        
        let imageString = image?
            //.ensureUpOrientation()
            .jpegData(compressionQuality: 0.0)?
            .base64EncodedString(options: .lineLength64Characters)
        
        return CreatePostRequest(createdAt: Date(),
                                 createdAtTimeZone: timeZone,
                                 latitudePickupLocation: recentSearch.latitude,
                                 longitudePickupLocation: recentSearch.longitude,
                                 offerValueTitle: title,
                                 description: description,
                                 shippingCost: numberShippingCost.decimalValue,
                                 currency: currency,
                                 imageType: imageType,
                                 image: imageString)
    }
    
    private func onPostUploaded(_ success: Bool) -> Void {
        DispatchQueue.main.async {
            self.postUploadSuccess = success
            self.isLoading = false
            self.wasPostUploaded = true
        }
    }
    
    func createPost() -> Void {
        guard !isLoading else {
            return
        }
        
        guard isValid else {
            return
        }
        
        self.isLoading = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            let postRequest = self.createPostRequest(timeZone: TimeZone.current.identifier)
            let defaultPostRequest = self.createPostRequest(timeZone: "UTC")
            
            ApiManager.shared.createPost(postRequest) { success in
                if !success {
                    ApiManager.shared.createPost(defaultPostRequest) { defaultSuccess in
                        self.onPostUploaded(defaultSuccess)
                    }
                } else {
                    self.onPostUploaded(true)
                }
            }
        }
        
    }
    
    func reset() -> Void {
        
        guard !isLoading else {
            return
        }
        
        image = nil
        title = ""
        description = ""
        shippingAddress = ""
        shippingCost = ""
        currency = Locale.current.currencyCode ?? Locale.isoCurrencyCodes[0]
        tags = []
        postUploadSuccess = nil
    }
}
