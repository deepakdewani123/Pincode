//
//  OfficeTableViewController.swift
//  Pincode
//
//  Created by Deepak Dewani on 03/03/16.
//  Copyright © 2016 Deepak Dewani. All rights reserved.
//

import UIKit
import CoreData

class OfficeTableViewController: UITableViewController {

    var results = []
    var sorted = [String]()
    var officeNames = [String]()
    var pincodes = [String]()
    
    var offPin = [String:String]()
    
    var districtName = ""
    
    var sections : [(index: Int, length :Int, title: String)] = Array()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.sectionIndexColor = UIColor.darkRed()

        
        if traitCollection.forceTouchCapability == .Available {
            registerForPreviewingWithDelegate(self, sourceView: tableView)
        }
        
        self.navigationController?.navigationBar.topItem?.title = ""
        
        //to make the navigation title dynamic
        self.title = districtName
        let tlabel: UILabel = UILabel(frame: CGRectMake(0, 0, 50, 40))
        tlabel.text = self.navigationItem.title
        tlabel.textColor = UIColor.whiteColor()
        tlabel.font = UIFont(name: "Futura", size: 22)
        tlabel.sizeToFit()
        tlabel.adjustsFontSizeToFitWidth = true
        self.navigationItem.titleView = tlabel

        //reference to our app delegate
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        //reference managed object context
        let context : NSManagedObjectContext = appDelegate.managedObjectContext
        
        //initialising the request
        let fetch = NSFetchRequest(entityName: "Details")
        
        let predicate = NSPredicate(format: "districtName BEGINSWITH[c] %@",districtName.lowercaseString)
        
        fetch.predicate = predicate
        fetch.returnsDistinctResults = true
        fetch.resultType = NSFetchRequestResultType.DictionaryResultType
        fetch.propertiesToFetch = ["officeName","pincode"]
        
        do {
            results = try context.executeFetchRequest(fetch)
        }
        catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
        
        for result in results {
            officeNames.append((result["officeName"] as! String))
            pincodes.append((result["pincode"] as! String))
        }

        //sorting the stateNames
        sorted = officeNames.sort { (name1, name2) -> Bool in
            return name1 < name2
        }
        
        //setting the 'pincode' as value and 'officename' as key
        for i in 0 ..< results.count {
            offPin[officeNames[i]] = pincodes[i]
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
        let cell = tableView.dequeueReusableCellWithIdentifier("officeCell", forIndexPath: indexPath) as! OfficeTableViewCell
        
        // Configure the cell...
        
        cell.officeName.text = sorted[sections[indexPath.section].index + indexPath.row]
        cell.pincode.text = offPin[sorted[sections[indexPath.section].index + indexPath.row]]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        //        print(sorted[sections[indexPath.section].index + indexPath.row])
        //        print(indexPath.row)
        
    }
    
    //setting the title for the header in a given section
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String {
        return sections[section].title
    }
    
    //setting the titles for the section index
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return sections.map { $0.title }
    }
    


}
