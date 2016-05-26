//
//  APIUtility.swift
//  HospitalLocator
//
//  Created by Mikhail Sapozhnikov on 5/26/16.
//  Copyright © 2016 Mikhail Sapozhnikov. All rights reserved.
//

import Foundation

class APIUtility {
    
    func performGetCall() -> AnyObject? {
        
        let apiURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=AIzaSyB6xydv4He0Hj6SjWJDbghJOdghCuUx0p8&location=33.7753208,-84.3909989&radius=10000&keyword=coffee"
        var response : AnyObject?
        let manager = AFHTTPSessionManager()
        
        manager.GET(apiURL,
                    parameters: nil,
                    progress: nil,
                    success: {
                        (task: NSURLSessionDataTask?, responseObject: AnyObject?) in
                        print("success")
                        response = responseObject
                        },
                    failure: {
                        (task: NSURLSessionDataTask?, error: NSError?) in
                        print("error")
        })
        
        return response
    }
}