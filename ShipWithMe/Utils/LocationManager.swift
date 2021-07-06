//
//  LocationManager.swift
//  ShipWithMe
//
//  Created by Ludvig Westerdahl on 2021-05-08.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    
    private var listener: ((Double, Double) -> Void)?
    
    private var isAuthorized: Bool = false
    
    private var location: CLLocation?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
  
    private func updateListener() -> Void {
        if let location = self.location, isAuthorized {
            listener?(location.coordinate.latitude, location.coordinate.longitude)
        }
    }
 
    func onLocation(listener: @escaping (Double, Double) -> Void) -> Void {
        self.listener = listener
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways,
             .authorizedWhenInUse:
            isAuthorized = true
        default:
            isAuthorized = false
        }
        
        updateListener()
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        self.location = locations.last
        
        updateListener()
    }
    
    func addressFromCoordinates(_ latitude: Double,
                                _ longitude: Double,
                                completionHandler: @escaping (CLPlacemark?) -> Void ) {
        // Use the last reported location.
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        // Look up the location and pass it to the completion handler
        geocoder.reverseGeocodeLocation(location,
                                        completionHandler: { (placemarks, error) in
                                            if error == nil {
                                                let firstLocation = placemarks?[0]
                                                completionHandler(firstLocation)
                                            }
                                            else {
                                                // An error occurred during geocoding.
                                                completionHandler(nil)
                                            }
                                        })
    }
    
    func getCoordinate(addressString : String,
                       completionHandler: @escaping(String?, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    let name = placemark.name!
                    
                    let result = "\(name) (\(location.coordinate.latitude), \(location.coordinate.longitude))"
                    
                    completionHandler(result, nil)
                    return
                }
            }
            
            completionHandler(nil, error as NSError?)
        }
    }
}
