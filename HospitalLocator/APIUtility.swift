//
//  APIUtility.swift
//  HospitalLocator
//
//  Created by Mikhail Sapozhnikov on 5/26/16.
//  Copyright © 2016 Mikhail Sapozhnikov. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire

class APIUtility {
    
    weak var delegate : APIUtilityDelegate?
    
    func performGetRequest() {
        
        let apiURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
        let apiKey = "AIzaSyB6xydv4He0Hj6SjWJDbghJOdghCuUx0p8"
        
        // Determine the current location to set as a query string parameter in the GET request below.
        let locationManager = CLLocationManager()
        let currentCoordinate = locationManager.location?.coordinate
        let currentLocation = "\(currentCoordinate!.latitude),\(currentCoordinate!.longitude)"
        
        // Additional passed in search criteria.
        let type = "restaurant"
        let radius = "10000"
        
        var locations: [[String:AnyObject]] = []
        
        Alamofire.request(.GET, apiURL, parameters: ["location": currentLocation, "key": apiKey, "radius": radius, "type": type])
            .responseJSON { response in

                if let JSON = response.result.value {
                    
                    // Parse the JSON object and extract name, rating and lat/lng location
                    if let results = JSON["results"] as? [[String: AnyObject]] {
                        for result in results {
                            var location: [String:AnyObject] = [:]
                            if let name = result["name"] as? String {
                                location["name"] = name
                            }
                            if let rating = result["rating"] as? Double {
                                location["rating"] = String(rating)
                            }
                            if let geometry = result["geometry"] as? [String:AnyObject] {
                                if let coords = geometry["location"] as? [String:AnyObject] {
                                    let lat = coords["lat"] as? Float
                                    let lon = coords["lng"] as? Float
                                    location["latitude"] = lat
                                    location["longitude"] = lon
                                }
                            }
                            locations.append(location)
                        }
                    }
                    
                    // Pass locations result set along to the controller that implements the delegate.
                    self.delegate?.didFinishRetrievingData(locations, sender: self)
                }
                else {
                    
                    // Otherwise pass an empty result set and allow the controller to handle it.
                    self.delegate?.didFinishRetrievingData(nil, sender: self)
                }
        }
    }
}