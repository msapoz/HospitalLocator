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
    
    func performGetCall(completion: (result: [[String:AnyObject]]?)->()) {
        
        let apiURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=AIzaSyB6xydv4He0Hj6SjWJDbghJOdghCuUx0p8&location=33.7753208,-84.3909989&radius=10000&keyword=coffee"
        
        var locations: [[String:AnyObject]] = []
        
        Alamofire.request(.GET, apiURL, parameters: nil)
            .responseJSON { response in

                if let JSON = response.result.value {
                    
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
                        print (locations)
                    }
                    
                    completion(result: locations)
                }
                else {
                    
                    // Caller will handle an empty result set
                    completion(result: nil)
                }
        }
    }
}