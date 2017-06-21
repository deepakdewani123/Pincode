//
//  DetailsTableViewController.swift
//  Pincode
//
//  Created by Deepak Dewani on 28/02/16.
//  Copyright © 2016 Deepak Dewani. All rights reserved.
//

import UIKit
import CoreData

class DetailsTableViewController: UITableViewController {

    var officeName = ""
    var pincode = ""
    var divisionName = ""
    var regionName = ""
    var talukName = ""
    var districtName = ""
    var stateName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 7
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("detailCell", forIndexPath: indexPath) as! DetailsTableViewCell

        // Configure the cell...

        
        if indexPath.row == 0 {
            cell.keyLabel.text = "Office Name"
            cell.valueLabel.text = officeName
        }
        else if indexPath.row == 1 {
            cell.keyLabel.text = "Pincode"
            cell.valueLabel.text = pincode
        }
        else if indexPath.row == 2 {
            cell.keyLabel.text = "Division Name"
            cell.valueLabel.text = divisionName
        }
        else if indexPath.row == 3 {
            cell.keyLabel.text = "Region Name"
            cell.valueLabel.text = regionName
        }
        else if indexPath.row == 4 {
            cell.keyLabel.text = "Taluk"
            cell.valueLabel.text = talukName
        }
        else if indexPath.row == 5 {
            cell.keyLabel.text = "District Name"
            cell.valueLabel.text = divisionName
        }
        else if indexPath.row == 6 {
            cell.keyLabel.text = "State Name"
            cell.valueLabel.text = stateName
        }

        return cell
    }


      /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
