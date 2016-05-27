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
    
    static let sharedInstance = APIUtility() // Singleton
    weak var delegate : APIUtilityDelegate?
    
    func performGetRequest(radius: String, types: [String]) {
        
        let apiURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
        let apiKey = "AIzaSyB6xydv4He0Hj6SjWJDbghJOdghCuUx0p8"
        
        var locations: [[String:AnyObject]] = []
        
        // Pass an empty locations object to the delegate controller if no types were specified, don't bother making the call.
        if types.count == 0 {
            self.delegate?.didFinishRetrievingData(locations, sender: self)
            return
        }
        
        // Determine the current location to set as a query string parameter in the GET request below.
        var currentLocation = "33.7773798,-84.3914938" // Default location: Centergy One building
        let locationManager = CLLocationManager()
        if let currentCoordinate = locationManager.location?.coordinate {
            currentLocation = "\(currentCoordinate.latitude),\(currentCoordinate.longitude)"
        }
        
        // Additional passed in search criteria.
        let radius = Double(radius)! * 1609.34 // convert the radius to miles
        let type = types.joinWithSeparator("&type=")
        
        // Update the API URL manually with the type query string because AlamoFire's parameters argument requires a dictionary, so we can't pass it multiple types.
        let updatedURL = apiURL + "?type=" + type
        
        Alamofire.request(.GET, updatedURL, parameters: ["location": currentLocation, "key": apiKey, "radius": radius])
            .responseJSON { response in
                
                print (response.request)
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