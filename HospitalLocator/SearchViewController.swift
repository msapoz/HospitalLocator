//
//  SearchViewController.swift
//  HospitalLocator
//
//  Created by Mikhail Sapozhnikov on 5/26/16.
//  Copyright © 2016 Mikhail Sapozhnikov. All rights reserved.
//

import UIKit

class SearchViewController : UITableViewController {
    
    // MARK:
    // MARK: Core Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add view title
        self.navigationController?.navigationBar.topItem?.title = "Search Filters"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Add the close button navigation item.
        let closeButton = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Plain, target: self, action:#selector(SearchViewController.CloseView(_:)))
        self.navigationController?.navigationBar.topItem?.leftBarButtonItem = closeButton
    }
    
    //MARK:
    //MARK: Button Handler Methods
    
    func CloseView(sender: UIBarButtonItem){
        self.dismissViewControllerAnimated(true, completion:nil)
    }
    
    
    
}