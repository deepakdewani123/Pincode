//
//  StateTableViewController.swift
//  Pincode
//
//  Created by Deepak Dewani on 02/03/16.
//  Copyright © 2016 Deepak Dewani. All rights reserved.
//

import UIKit
import CoreData

class StateTableViewController: UITableViewController {

    
    var results = []
    var stateNames = [String]()
    var sorted = [String]()
    
    var sections : [(index: Int, length :Int, title: String)] = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
//        print("load")
        tableView.sectionIndexColor = UIColor.darkRed()
        tableView.sectionHeaderHeight = 25
        
        //to make the navigation title dynamic
        let title = "Pincode"
        let tlabel: UILabel = UILabel(frame: CGRectMake(0, 0, 50, 40))
        tlabel.text = title
        tlabel.textColor = UIColor.whiteColor()
        tlabel.font = UIFont(name: "Futura", size: 25)
//        tlabel.adjustsFontSizeToFitWidth = true
        self.navigationItem.titleView = tlabel
        
        
        //reference to our app delegate
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        //reference managed object context
        let context : NSManagedObjectContext = appDelegate.managedObjectContext
        
        //initialising the request
        let fetch = NSFetchRequest(entityName: "Details")
        
        fetch.returnsDistinctResults = true
        fetch.resultType = NSFetchRequestResultType.DictionaryResultType
        fetch.propertiesToFetch = ["stateName"]
        
        do {
            results = try context.executeFetchRequest(fetch)
            
        }
        catch {
            let error = error as NSError
                print(error)
        }
        
        for result in results {
            stateNames.append((result["stateName"] as! String).capitalizedString)
        }
        
        //sorting the stateNames
        sorted = stateNames.sort {
            return $0 < $1
        }

        //sectioning the 'sorted' array according to the first character
        var index = 0;
        
        for i in 0 ..< sorted.count {
            
            let commonPrefix = sorted[i].commonPrefixWithString(sorted[index], options:.CaseInsensitiveSearch)
            
            if commonPrefix.characters.count == 0 {
                
                let string = sorted[index].uppercaseString;
                
                let firstCharacter = string[string.startIndex]
                
                let title = "\(firstCharacter)"
                
                let newSection = (index: index, length: i - index, title: title)
                
                
                sections.append(newSection)
                
                index = i
                
            }
            
        }
 
    }

    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sections.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sections[section].length
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("stateCell", forIndexPath: indexPath)

        // Configure the cell...
        
        
//        print(sections[indexPath.section].index + indexPath.row)
        cell.textLabel?.text = sorted[sections[indexPath.section].index + indexPath.row]

        return cell

    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//        print(sorted[sections[indexPath.section].index + indexPath.row])
//        print(indexPath.row)

    }
    
//    setting the title for the header in a given section
//    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String {
//        return sections[section].title
//    }
    
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let returnedView = UIView() //set these values as necessary
        returnedView.backgroundColor = UIColor.lightRed()
        
        let label = UILabel(frame: CGRectMake(17, 7, 13, 13))
        label.text = sections[section].title
        label.textAlignment = .Center
        label.textColor = UIColor.whiteColor()
        returnedView.addSubview(label)
        
        return returnedView
        
    }


    //setting the titles for the section index
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return sections.map { $0.title }
    }
    
    
//    override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
//        print(index)
//        return index
//    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let indexPath = tableView.indexPathForSelectedRow!
        let stateName = sorted[sections[indexPath.section].index + indexPath.row]

        let detailVC = segue.destinationViewController as! DistrictTableViewController
        detailVC.stateName = stateName
//

        
    }
    

}
