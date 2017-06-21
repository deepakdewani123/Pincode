//
//  OfficeTableViewController+UIViewControllerPreviewing.swift
//  Pincode
//
//  Created by Deepak Dewani on 20/04/16.
//  Copyright © 2016 Deepak Dewani. All rights reserved.
//

import UIKit
import CoreData


extension OfficeTableViewController: UIViewControllerPreviewingDelegate {
    
    // PEEK
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
//        let result
        
        guard let indexPath = tableView.indexPathForRowAtPoint(location),
            cell = tableView.cellForRowAtIndexPath(indexPath) as? OfficeTableViewCell else {return nil}
        let office = cell.officeName.text
        
        guard let previewVC = storyboard?.instantiateViewControllerWithIdentifier("PreviewVC") as? PreviewViewController else {return nil}
        
        //reference to our app delegate
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        //reference managed object context
        let context : NSManagedObjectContext = appDelegate.managedObjectContext
        
        //initialising the request
        let fetch = NSFetchRequest(entityName: "Details")
        
        let predicate = NSPredicate(format: "officeName BEGINSWITH[c] %@",office!.lowercaseString)
        
        fetch.predicate = predicate
        fetch.returnsDistinctResults = true
        fetch.resultType = NSFetchRequestResultType.DictionaryResultType
        fetch.propertiesToFetch = ["officeName","pincode","stateName"]
        
        do {
            results = try context.executeFetchRequest(fetch)
        }
        catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
        
        previewVC.pincode = results[0].valueForKey("pincode") as! String
        previewVC.stateName = results[0].valueForKey("stateName") as! String
        previewVC.officeName = results[0].valueForKey("officeName") as! String
     
        
        previewVC.preferredContentSize = CGSize(width: 0, height: 150)
        
        previewingContext.sourceRect = cell.frame
        
        
        return previewVC
    }
    
    // POP
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        
//        if let stuffVC = storyboard?.instantiateViewControllerWithIdentifier("AddStuffVC") as? AddStuffViewController{
//            stuffVC.detailInfo = quickActionString
//            
//            showViewController(stuffVC, sender: self)
//        }
        
        
    }
}