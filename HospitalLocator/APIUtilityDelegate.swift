//
//  APIUtilityDelegate.swift
//  HospitalLocator
//
//  Created by Mikhail Sapozhnikov on 5/26/16.
//  Copyright © 2016 Mikhail Sapozhnikov. All rights reserved.
//

import UIKit

protocol APIUtilityDelegate: class {
    
    // The delegate implementer will be passed along a result set of the API call in the APIUtility.
    func didFinishRetrievingData(results:[[String:AnyObject]]?, sender: AnyObject)
}
