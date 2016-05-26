//
//  MasterViewController.swift
//  HospitalLocator
//
//  Created by Mikhail Sapozhnikov on 5/26/16.
//  Copyright © 2016 Mikhail Sapozhnikov. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate {
    
    // MARK:
    // MARK: Local Variables
    
    @IBOutlet weak var mapView: MKMapView!
    var detailViewController: DetailViewController? = nil
    var searchViewController: SearchViewController? = nil
    var apiUtility = APIUtility()
    var objects = [AnyObject]()

    // MARK:
    // MARK: Core Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Default to user's current location
        mapView.showsUserLocation = true
        
        print(apiUtility.performGetCall())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK:
    // MARK: Map Methods
    
    // Default to user's location when the GPSArrow is clicked.
    @IBAction func zoomToCurrentLocation(sender: AnyObject) {
        if let coordinate = mapView.userLocation.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(coordinate, 10000, 10000)
            mapView.setRegion(region, animated: true)
        }
    }

    
    // MARK:
    // MARK: Filter Methods
    
    // Action to display the search filters page.
    @IBAction func showSearchFilterPage(sender: AnyObject) {
        let searchViewController = SearchViewController()
        let navController = UINavigationController(rootViewController: searchViewController)
        
        self.presentViewController(navController, animated: false, completion: nil)
    }
}

