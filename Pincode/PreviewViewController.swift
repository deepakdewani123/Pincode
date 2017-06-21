//
//  PreviewViewController.swift
//  Pincode
//
//  Created by Deepak Dewani on 20/04/16.
//  Copyright © 2016 Deepak Dewani. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {

    var selectedItem:String!
    
    var pincode = ""
    var officeName = ""
    var stateName = ""
    
    @IBOutlet weak var pincodeLabel: UILabel!
    @IBOutlet weak var officeNameLabel: UILabel!
    @IBOutlet weak var stateNameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        pincodeLabel.text = pincode
        officeNameLabel.text = officeName
        stateNameLabel.text = stateName
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
