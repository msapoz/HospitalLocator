//
//  SearchViewController.swift
//  HospitalLocator
//
//  Created by Mikhail Sapozhnikov on 5/26/16.
//  Copyright © 2016 Mikhail Sapozhnikov. All rights reserved.
//

import UIKit
import Foundation

class SearchViewController : UITableViewController {
    
    // MARK:
    // MARK: UI Element Outlets
    
    @IBOutlet weak var toggleDoctor: UISwitch!
    @IBOutlet weak var toggleHospital: UISwitch!
    @IBOutlet weak var segmentRadius: UISegmentedControl!
    
    // MARK:
    // MARK: Core Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Add view title
        self.navigationController?.navigationBar.topItem?.title = "Search Filters"
        
        // Close Button
        let closeButton = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Plain, target: self, action:#selector(SearchViewController.CloseView(_:)))
        self.navigationController?.navigationBar.topItem?.leftBarButtonItem = closeButton
        
        // Submit Button
        let submitButton = UIBarButtonItem(title: "Submit", style: UIBarButtonItemStyle.Plain, target: self, action:#selector(SearchViewController.PerformSearch(_:)))
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = submitButton
        
        // Remove default separator padding.
        self.tableView.separatorInset.left = 0
    }
    
    // MARK:
    // MARK: Button Handler Methods
    
    func CloseView(sender: UIBarButtonItem){
        self.dismissViewControllerAnimated(true, completion:nil)
    }
    
    func PerformSearch(sender: UIBarButtonItem){
        
        var searchTypes: [String] = []
       
        if toggleDoctor.on {
            searchTypes.append("doctor")
        }
        if toggleHospital.on {
            searchTypes.append("hospital")
        }
        
        let radius = segmentRadius.titleForSegmentAtIndex(segmentRadius.selectedSegmentIndex)
        
        APIUtility.sharedInstance.performGetRequest(radius!, types: searchTypes)
        
        self.dismissViewControllerAnimated(true, completion:nil)
    }
    
    // MARK
    // MARK: Filter IB Actions
    
    
}