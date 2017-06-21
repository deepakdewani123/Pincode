//
//  ViewController.swift
//  Pincode
//
//  Created by Deepak Dewani on 18/02/16.
//  Copyright © 2016 Deepak Dewani. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var pincode = ""
    var pinCode = [NSManagedObject]()
    var filtered = [NSManagedObject]()

    @IBOutlet weak var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {

//        self.jsonParsingFromURL()

        print("view")
        
            //reference to our app delegate
            let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            //reference managed object context
            let context : NSManagedObjectContext = appDelegate.managedObjectContext
            
            //fetching the request
            let fetch = NSFetchRequest(entityName: "Details")
            do {
                let results = try (context.executeFetchRequest(fetch) as? [NSManagedObject])!
                pinCode = results 
            }
            catch let error as NSError {
                
            }
//        print(pinCode[154822])
//        let pin = pinCode[0].valueForKeyPath("pincode") as! NSArray
//        print(pin.count)
        
//        })

        filtered = pinCode.filter { pincode in
            return pincode.valueForKey("pincode")!.containsString("421002")
        }
//        for filter in filtered {
//            print(filter.valueForKey("circleName") as! String,filter.valueForKey("deliveryStatus") as! String,filter.valueForKey("districtName") as! String,filter.valueForKey("divisionName") as! String,filter.valueForKey("officeName") as! String,filter.valueForKey("officeType") as! String,filter.valueForKey("pincode") as! String,filter.valueForKey("regionName") as! String,filter.valueForKey("stateName") as! String,filter.valueForKey("taluqName") as! String)
//        }
//            print(filter.valueForKey("circleName") as! String)
//            print(filter.valueForKey("districtName") as! String)
//            print(filter.valueForKey("divisionName") as! String)
//            print(filter.valueForKey("officeName") as! String)
//            print(filter.valueForKey("officeType") as! String)
//            print(filter.valueForKey("pincode") as! String)
//            print(filter.valueForKey("regionName") as! String)
//            print(filter.valueForKey("stateName") as! String)
//            print(filter.valueForKey("deliveryStatus") as! String)
//            print(filter.valueForKey("taluqName") as! String)


        
        
        
//        for i in pinCode {
//            let on = String(i.valueForKey("officeName")!)
//            if i.valueForKey("officeName")!.containsString("Moguluru B.O") {
//                print(on)
//
//            }
//        }
        
//        print(pinCode[0].valueForKey("pincode")!)
//        print(pinCode[1].valueForKey("officeName")!)

        
    }
    func jsonParsingFromURL () {
    
//        let url = NSURL(string: url)
//        let request = NSURLRequest(URL: url)
//        
//        
//        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
//            if(error==nil){
//                
//                self.startParsing(data!)
//                
//            }
//                
//            else{
//                print(error)
//            }
//            
//        }
        let contentsOfURL = NSBundle.mainBundle().URLForResource("myjson", withExtension: "json")

//        let data : NSData = try! NSData(contentsOfFile: contentsOfURL as String , options: NSDataReadingOptions.DataReadingMapped)
        do {
        let data = try NSData(contentsOfURL: contentsOfURL!, options: NSDataReadingOptions.DataReadingMapped)
        self.startParsing(data)

    }
        catch let error as NSError {
            
        }
    }
    
    func startParsing(data :NSData)
    {

        do{
            let dict :NSDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
            print(dict.valueForKey("records")?.count)
            
            for var index = 0 ; index < (dict.valueForKey("records") as! NSArray).count ; index += 1 {
                let temp: AnyObject = (dict.valueForKey("records") as! NSArray).objectAtIndex(index)
//                print(temp.valueForKey("pincode"))

//                print("hello")
                //reference to our app delegate
                let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                //reference managed object context
                let context : NSManagedObjectContext = appDelegate.managedObjectContext
                
//                let entity = NSEntityDescription.entityForName("Details", inManagedObjectContext: context) as! Model
                let entity =  NSEntityDescription.entityForName("Details",
                    inManagedObjectContext:context)
                
                let newItem = Model(entity: entity!,
                    insertIntoManagedObjectContext: context)
                
                //create instance of our data model and initialize
//                let newItem = Model(entity: entity!, insertIntoManagedObjectContext: context)
//                
                newItem.officeName = temp.valueForKey("officename") as? String
                newItem.officeType = temp.valueForKey("officeType") as? String
                newItem.deliveryStatus = temp.valueForKey("Deliverystatus") as? String
                newItem.divisionName = temp.valueForKey("divisionname") as? String
                newItem.circleName = temp.valueForKey("circlename") as? String
                newItem.taluqName = temp.valueForKey("Taluk") as? String
                newItem.districtName = temp.valueForKey("Districtname") as? String
                newItem.stateName = temp.valueForKey("statename") as? String
                newItem.pincode = String(temp.valueForKey("pincode")!)
                newItem.regionName = temp.valueForKey("regionname") as? String


                do {
                try context.save()
                }
                catch let error as NSError {
                    print(error)
                }
//             print(temp.valueForKey("officename")!,temp.valueForKey("pincode")!,temp.valueForKey("officeType")!,temp.valueForKey("Deliverystatus")!,temp.valueForKey("divisionname")!,temp.valueForKey("regionname")!,temp.valueForKey("circlename")!,temp.valueForKey("Taluk")!,temp.valueForKey("Districtname")!,temp.valueForKey("statename")!)

                
                
            }
        }
            
        catch let error as NSError{
            print(error.localizedDescription)
        }
    
        
    }
    
    
    @IBAction func findPinCode(sender: AnyObject) {
        
        pincode = textField.text!
        
//        let contentsOfURL = NSBundle.mainBundle().URLForResource("pincode", withExtension: "json")
        
//        jsonParsingFromURL("https://data.gov.in/api/datastore/resource.json?resource_id=6176ee09-3d56-4a3b-8115-21841576b2f6&api-key=f542b17cf53ff8777a808d3d1ccea668&limit=100&filters[pincode]=\(pincode)")
        
        
        jsonParsingFromURL()

        
    }
    
}






