//
//  SearchTableViewController.swift
//  Pincode
//
//  Created by Deepak Dewani on 20/02/16.
//  Copyright © 2016 Deepak Dewani. All rights reserved.
//

import UIKit
import CoreData

extension UITabBarController {
    
    func setTabBarVisible(visible:Bool, animated:Bool) {
        
        // bail if the current state matches the desired state
        if (tabBarIsVisible() == visible) { return }
        
        // get a frame calculation ready
        let frame = self.tabBar.frame
        let height = frame.size.height
        let offsetY = (visible ? -height : height)
        
        // animate the tabBar
        UIView.animateWithDuration(animated ? 0.5 : 0.0) {
            self.tabBar.frame = CGRectOffset(frame, 0, offsetY)
            self.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height + offsetY)
            self.view.setNeedsDisplay()
            self.view.layoutIfNeeded()
        }
    }
    
    func tabBarIsVisible() ->Bool {
        return self.tabBar.frame.origin.y < CGRectGetMaxY(self.view.frame)
    }
}


extension SearchTableViewController: UISearchResultsUpdating, UITextFieldDelegate {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        //        if searchController.searchBar.text!.isEmpty {
        //            self.tableView.reloadData()
        //        }
        //
        //        let searchBar = searchController.searchBar
        //        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        //
        //        NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: "filterContentForSearchText:", object: [searchBar.text!,scope] )
        //
        //        self.performSelector("filterContentForSearchText:", withObject: [searchBar.text!,scope], afterDelay: 0.8)
        
        
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchBar.text!, scope: scope)
        
        
    }
    
    //    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
    //        print("end")
    //
    //    }
    //
    //
    //
    //    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
    //        print("cancel")
    //        self.tableView.reloadData()
    //    }
}

extension SearchTableViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        //        filterContentForSearchText([searchBar.text!,searchBar.scopeButtonTitles![selectedScope]])
        
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
        
        
        //        searchBarSearchButtonClicked(searchBar, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

class SearchTableViewController: UITableViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var pinCode = [NSManagedObject]()
    var filtered = [NSManagedObject]()
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    let label = UILabel()
    
    let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.setTabBarVisible(false, animated: false)
        
        tabBarController?.tabBar.alpha = 0
        
        button.backgroundColor = .greenColor()
        button.setTitle("Tap to open", forState: .Normal)
        
        var center = self.tabBarController?.tabBar.center
        center!.y = center!.y - 150
        self.button.center = center!

        
        button.addTarget(self, action: #selector(buttonAction), forControlEvents: .TouchUpInside)
        
        
        self.view.addSubview(button)
        

        
        defaults.setBool(true, forKey: "viewDidLoad")
        
        
        self.tableView.reloadData()
        
        //to make the navigation title dynamic
        self.title = "Pincode"
        let tlabel: UILabel = UILabel(frame: CGRectMake(0, 0, 50, 40))
        tlabel.text = self.navigationItem.title
        tlabel.textColor = UIColor.whiteColor()
        tlabel.font = UIFont(name: "Futura", size: 25)
        tlabel.adjustsFontSizeToFitWidth = true
        self.navigationItem.titleView = tlabel
        
        searchController.searchBar.placeholder = "e.g. Start Searching"
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.scopeButtonTitles = ["Pincode", "Officename", "Districtname"]
        searchController.searchBar.delegate = self
        
        label.frame = CGRectMake(0, 0, 300, 200)
        label.text = "Search for\n Pincode, Office-name/Area-name, or District-name"
        label.font = UIFont(name: "Futura", size: 20)
        label.textAlignment = NSTextAlignment.Center
        label.adjustsFontSizeToFitWidth = true
        label.center.x = self.view.frame.width / 2
        label.center.y = self.view.frame.height / 2
        label.numberOfLines = 0
        self.view.addSubview(label)
        
        loadData()
        
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        searchController.searchBar.becomeFirstResponder()
    }
    override func viewDidDisappear(animated: Bool) {
        defaults.setBool(false, forKey: "viewDidLoad")
        
        //        //reference to our app delegate
        //        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //
        //        //reference managed object context
        //        let context : NSManagedObjectContext = appDelegate.managedObjectContext
        //
        //        context.reset()
        
        
    }
    
    func buttonAction(sender: UIButton!) {
        
        if tabBarController!.tabBarIsVisible() {
            
            self.tabBarController?.setTabBarVisible(false, animated: true)
            UIView.animateWithDuration(0.4, animations: {
                self.tabBarController?.tabBar.alpha = 0
                var center = self.tabBarController?.tabBar.center
                center!.y = center!.y - 150
                self.button.center = center!
            })
           
        }
        else {
            UIView.animateWithDuration(0.4, animations: {
                
                
                self.tabBarController?.setTabBarVisible(true, animated: true)
                
                self.tabBarController?.tabBar.alpha = 1
                var center = self.tabBarController?.tabBar.center
                center!.y = center!.y - 100
                self.button.center = center!
            })
        }
        
    }
    
    
    
    func animateTable() {
        
        let cells = tableView.visibleCells
        
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for cell in cells {
            let cell: UITableViewCell = cell as UITableViewCell
            cell.transform = CGAffineTransformMakeTranslation(0, tableHeight)
        }
        
        var index = 0
        
        for cell in cells {
            let cell: UITableViewCell = cell as UITableViewCell
            UIView.animateWithDuration(0.3, delay: 0.01 * Double(index), usingSpringWithDamping: 2, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                cell.transform = CGAffineTransformMakeTranslation(0, 0)
                }, completion: nil)
            
            index += 1
        }
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filtered.count
        }
        else {
            return 1
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("searchCell", forIndexPath: indexPath) as! SearchTableViewCell
        
        // Configure the cell...
        
        let pin: NSManagedObject
        
        if searchController.active {
            
            if searchController.searchBar.text != "" {
                label.alpha = 0
                
            }
            else {
                label.alpha = 1
                //                UIView.animateWithDuration(0.0, animations: {
                //                    self.label.alpha = 1
                //                })
            }
            UIView.animateWithDuration(0.6, animations: {
                self.label.center.y = 150
            })
        }
        else {
            label.alpha = 1
            UIView.animateWithDuration(0.6, animations: {
                self.label.center.y = self.view.frame.height / 2
            })
            
        }
        if searchController.active && searchController.searchBar.text != "" {
            pin = filtered[indexPath.row]
            cell.pincodeLabel.text = pin.valueForKey("pincode") as? String
            cell.officeNameLabel.text = pin.valueForKey("officeName") as? String
            cell.divisionNameLabel.text = pin.valueForKey("divisionName") as? String
            tableView.separatorColor = UIColor.candyGreen()
            cell.userInteractionEnabled = true
            
            
        } else {
            cell.pincodeLabel.text = ""
            cell.officeNameLabel.text = ""
            cell.divisionNameLabel.text = ""
            tableView.separatorColor = UIColor.clearColor()
            cell.userInteractionEnabled = false
            self.filtered.removeAll()
            
            
        }
        
        return cell
    }
    func filterContentForSearchText(searchText: String, scope: String = "Pincode") {
        //    func filterContentForSearchText(arguments: NSArray) {
        
        //        let searchText = arguments[0]
        //        let scope = arguments[1] as! String
        
        var myScope = ""
        
        if scope == "Pincode" {
            myScope = "pincode"
        }
        else if scope == "Officename" {
            myScope = "officeName"
        }
        else {
            myScope = "districtName"
        }
        let predicate = NSPredicate(format: "\(myScope) BEGINSWITH[c] %@",searchText.lowercaseString)
        //
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            //
            //            //reference to our app delegate
            //            let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            //
            //            //reference managed object context
            //            let context : NSManagedObjectContext = appDelegate.managedObjectContext
            //
            //            //initialising the request
            //            let fetch = NSFetchRequest(entityName: "Details")
            //
            //            fetch.predicate = predicate
            //
            ////        fetch.propertiesToFetch = ["pincode","officeName","divisionName"]
            ////        fetch.resultType = NSFetchRequestResultType.DictionaryResultType
            //
            //
            //            fetch.fetchBatchSize = 50
            //
            //            // Initialize Asynchronous Fetch Request
            //            let asynchronousFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetch) { (asynchronousFetchResult) -> Void in
            //                //                print("world")
            //                self.processAsynchronousFetchResult(asynchronousFetchResult)
            //            }
            //            do {
            //                // Execute Asynchronous Fetch Request
            //                //                print("hello")
            //                let asynchronousFetchResult = try context.executeRequest(asynchronousFetchRequest)
            //
            //            } catch {
            //                let fetchError = error as NSError
            //                print("\(fetchError), \(fetchError.userInfo)")
            //            }
            //            //
            
            self.filtered = (self.pinCode as NSArray).filteredArrayUsingPredicate(predicate) as! [NSManagedObject]
            
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
    }
    
    func loadData() {
        
        //        //reference to our app delegate
        //        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //
        //        //reference managed object context
        //        let context : NSManagedObjectContext = appDelegate.managedObjectContext
        //
        //        //initialising the request
        //        let fetch = NSFetchRequest(entityName: "Details")
        //
        ////                let predicate = NSPredicate(format: "\(myScope) BEGINSWITH[c] %@",searchText.lowercaseString)
        //
        ////                fetch.predicate = predicate
        ////        fetch.fetchBatchSize = 1000
        //
        //
        //
        //        //        var fetchResult = []
        //
        //        //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
        //
        //
        //        // Initialize Asynchronous Fetch Request
        //        let asynchronousFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetch) { (asynchronousFetchResult) -> Void in
        //            print("world")
        //            self.processAsynchronousFetchResult(asynchronousFetchResult)
        //        }
        //        do {
        //            // Execute Asynchronous Fetch Request
        //            print("hello")
        //            let asynchronousFetchResult = try context.executeRequest(asynchronousFetchRequest)
        //
        //        } catch {
        //            let fetchError = error as NSError
        //            print("\(fetchError), \(fetchError.userInfo)")
        //        }
        
        
        //        reference to our app delegate
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        //reference managed object context
        let context : NSManagedObjectContext = appDelegate.managedObjectContext
        
        //fetching the request
        let fetch = NSFetchRequest(entityName: "Details")
        
        
        do {
            let results = try (context.executeFetchRequest(fetch) as? [NSManagedObject])!
            self.pinCode = results
            fetch.returnsObjectsAsFaults = false
            //                    context.undoManager = nil // nil by default in iOS
            //                    context.reset()
            
        }
        catch let error as NSError {
            print(error)
        }
        
    }
    
    
    func processAsynchronousFetchResult(asynchronousFetchResult: NSAsynchronousFetchResult) {
        if let result = asynchronousFetchResult.finalResult {
            // Update Items
            
            pinCode = result as! [NSManagedObject]
            //            print(filtered.count)
            //            if filtered.count != 0 {
            //                print(filtered[0].valueForKey("districtName") as! String)
            //            }
            
            dispatch_async(dispatch_get_main_queue()) {
                // Reload Table View
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let pincode = filtered[tableView.indexPathForSelectedRow!.row]
        let detailVC = segue.destinationViewController as! DetailsTableViewController
        
        detailVC.officeName = pincode.valueForKey("officeName") as! String
        detailVC.pincode = pincode.valueForKey("pincode") as! String
        detailVC.divisionName = pincode.valueForKey("divisionName") as! String
        detailVC.regionName = pincode.valueForKey("regionName") as! String
        detailVC.talukName = pincode.valueForKey("taluqName") as! String
        detailVC.districtName = pincode.valueForKey("districtName") as! String
        detailVC.stateName = pincode.valueForKey("stateName") as! String
        
    }
    
    
}
