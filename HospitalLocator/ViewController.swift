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

class ViewController: UIViewController, MKMapViewDelegate, APIUtilityDelegate, CLLocationManagerDelegate {
    
    // MARK:
    // MARK: Local Variables
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var detailViewController: DetailViewController? = nil
    var searchViewController: SearchViewController? = nil
    var objects = [AnyObject]()

    // MARK:
    // MARK: Core Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize delegate that retrieves API call result set.
        APIUtility.sharedInstance.delegate = self
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
        
        self.mapView.showsUserLocation = true;
        
        APIUtility.sharedInstance.performGetRequest("0.5", types: ["Hospital"])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK:
    // MARK: Map Methods
    
    // Interface builder action for zooming to current location
    @IBAction func zoomToCurrentLocationAction(sender: AnyObject) {
        [self .zoomToCurrentLocation(self)]
    }
    
    // Default to user's location when the GPSArrow is clicked.
    func zoomToCurrentLocation(sender: AnyObject) {
        if let coordinate = mapView.userLocation.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(coordinate, 10000, 10000)
            mapView.setRegion(region, animated: true)
        }
    }

    // MARK:
    // MARK: Filter Methods
    
    // Action to display the search filters page.
    @IBAction func showSearchFilterPage(sender: AnyObject) {
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let svc : SearchViewController = storyboard.instantiateViewControllerWithIdentifier("SearchViewController") as! SearchViewController
        let navController = UINavigationController(rootViewController: svc)
        
        self.presentViewController(navController, animated: false, completion: nil)
    }
    
    // MARK:
    // MARK: Delegate Implementations
    
    func didFinishRetrievingData(results: [[String : AnyObject]]?, sender: AnyObject) {
        
        mapView.removeAnnotations( mapView.annotations )
        
        if (results != nil) {
            
            // Populate map with pin locations using the callback.
            for result in results! {
                
                let lat = result["latitude"] as! Double
                let lng = result["longitude"] as! Double
                
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                
                // Drop an annotation
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = result["name"] as? String
                
                if let rating = result["rating"] as? String {
                    annotation.subtitle = "Rating: " + rating
                }
                
                self.mapView?.addAnnotation(annotation)
            }
        }
        else {
            
            // Otherwise display an alert.
            DisplayAlert("Not Found", message: "No Results Found!", viewController: self)
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
            APIUtility.sharedInstance.performGetRequest("0.5", types: ["Hospital"])
        }
    }
}

