//
//  DistrictTableViewController.swift
//  Pods
//
//  Created by Deepak Dewani on 02/03/16.
//
//

import UIKit
import CoreData


class DistrictTableViewController: UITableViewController {
    
    var results = []
    var districtNames = [String]()
    var sorted = [String]()
    var newArray = [String]()
    var uniqueArray = [String]()
    var counts:[String:Int] = [:]
    
    var stateName = ""
    
    var sections : [(index: Int, length :Int, title: String)] = Array()
    
    var newSection = (index: 0, length: 0, title: "")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.topItem?.title = ""
        
        tableView.sectionIndexColor = UIColor.darkRed()

        
        //to make the navigation title dynamic
        self.title = stateName
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
        
        let predicate = NSPredicate(format: "stateName BEGINSWITH[c] %@",stateName.lowercaseString)
        
        fetch.predicate = predicate
        fetch.returnsDistinctResults = true
        fetch.resultType = NSFetchRequestResultType.DictionaryResultType
        fetch.propertiesToFetch = ["districtName"]
        
        do {
            results = try context.executeFetchRequest(fetch)
        }
        catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
        
        for result in results {
            districtNames.append((result["districtName"] as! String))
        }
        
        
        //sorting the stateNames
        sorted = districtNames.sort { (name1, name2) -> Bool in
            return name1 < name2
        }
        
        print(sorted)
        
        for sort in sorted {
            newArray.append(String(sort[sort.startIndex]))
        }
        
        uniqueArray = unique(newArray)
        print(uniqueArray)
        
        
        for item in newArray {
            counts[item] = (counts[item] ?? 0) + 1
        }
        
//        for u in uniqueArray {
//            print(counts[u])
//        }
        
//        //sectioning the 'sorted' array according to the first character
//      
        var index = 0
        
        for i in 0 ..< uniqueArray.count {
            
            let firstCharacter = uniqueArray[i]
            
            let title = "\(firstCharacter)"
            
            newSection = (index: index, length: counts[uniqueArray[i]]!, title: title)
            
            sections.append(newSection)
            
            index = index + counts[uniqueArray[i]]!
            
        }
//
        
        //sectioning the 'sorted' array according to the first character
//                var index = 0
//        
//                for var i = 0; i < sorted.count; i++ {
//        
//                    let commonPrefix = sorted[i].commonPrefixWithString(sorted[index], options:.CaseInsensitiveSearch)
//        
//        
//        //            print(commonPrefix.characters.count)
//        
//                    if stateName.lowercaseString == "daman & diu" {
//                        let string = "Daman & Diu"
//                        let firstCharacter = string[string.startIndex]
//                        let title = "\(firstCharacter)"
//                        newSection = (index: index, length: i + 1 - index, title: title)
//                        sections.append(newSection)
//                    }
//                    else if commonPrefix.characters.count == 0 || sorted.count == 1 {
//        
//                        let string = sorted[index].uppercaseString;
//        
//                        let firstCharacter = string[string.startIndex]
//        
//                        let title = "\(firstCharacter)"
//        
//                        if sorted.count == 1 {
//                            newSection = (index: index, length: 1, title: title)
//                        }
//                        else {
//                            newSection = (index: index, length: i - index, title: title)
//        //                    print(newSection.length)
//        
//                        }
//                        sections.append(newSection)
//        
//                        index = i
//        //                print("index=",index)
//        
//                    }
//                }
        
//        print(sections[3].index)
//
        
        
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
        let cell = tableView.dequeueReusableCellWithIdentifier("districtCell", forIndexPath: indexPath)
        
        // Configure the cell...
        
        cell.textLabel?.text = sorted[sections[indexPath.section].index + indexPath.row]
        
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
        
        var titles = [String]()
        
        if sorted.count > 10 {
            titles = sections.map { $0.title }
        }
        else {
            titles = []
        }
        
        return titles
    }
    
    func unique<S : SequenceType, T : Hashable where S.Generator.Element == T>(source: S) -> [T] {
        var buffer = [T]()
        var added = Set<T>()
        for elem in source {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let indexPath = tableView.indexPathForSelectedRow!
        let districtName = sorted[sections[indexPath.section].index + indexPath.row]
        
        let detailVC = segue.destinationViewController as! OfficeTableViewController
        detailVC.districtName = districtName
    }
    
    
}
