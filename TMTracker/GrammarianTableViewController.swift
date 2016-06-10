//
//  GrammarianTableViewController.swift
//  TMTracker
//
//  Created by Emily Chen on 2016-06-03.
//  Copyright © 2016 Emily Chen. All rights reserved.
//

import UIKit
import RealmSwift

class GrammarianTableViewController: UITableViewController {
    
    var role = ""
    let dateFormatter = NSDateFormatter()
    
    @IBOutlet weak var segment1: UISegmentedControl!
    @IBOutlet weak var segment2: UISegmentedControl!
    @IBOutlet weak var segment3: UISegmentedControl!
    @IBOutlet weak var segment4: UISegmentedControl!
    
    @IBOutlet weak var ahCountStepper: UIStepper!
    @IBOutlet weak var ahCountLabel: UILabel!
    @IBOutlet weak var umCountStepper: UIStepper!
    @IBOutlet weak var umCountLabel: UILabel!
    @IBOutlet weak var youKnowCountStepper: UIStepper!
    @IBOutlet weak var youKnowCountLabel: UILabel!
    @IBOutlet weak var doubleWordCountStepper: UIStepper!
    @IBOutlet weak var doubleWordCountLabel: UILabel!
    @IBOutlet weak var andCountStepper: UIStepper!
    @IBOutlet weak var andCountLabel: UILabel!
    
    @IBAction func saveFillerCount(sender: UIBarButtonItem) {
        if(role != ""){
            let fillerCountLog = FillerCountLog()
            fillerCountLog.date = dateFormatter.stringFromDate(NSDate())
            fillerCountLog.role = role
            fillerCountLog.ahCount = ahCountLabel.text!
            fillerCountLog.umCount = umCountLabel.text!
            fillerCountLog.youKnowCount = youKnowCountLabel.text!
            fillerCountLog.doubleWordCount = doubleWordCountLabel.text!
            fillerCountLog.andCount = andCountLabel.text!
            
            let realm = try! Realm()
            try! realm.write {
                print("writing grammarian count to Realm")
                realm.add(fillerCountLog)
            }
            
            // pop controller
            if let navController = self.navigationController {
                navController.popViewControllerAnimated(true)
            }
        } else {
            let alert = UIAlertController(title: "Choose a role", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    private(set) lazy var segments: [UISegmentedControl] = {
        return [self.segment1, self.segment2, self.segment3, self.segment4]
    }()
    
    private(set) lazy var stepperLabelDict: [UIStepper : UILabel] = {
        return [self.ahCountStepper : self.ahCountLabel,
                self.umCountStepper : self.umCountLabel,
                self.youKnowCountStepper : self.youKnowCountLabel,
                self.doubleWordCountStepper : self.doubleWordCountLabel,
                self.andCountStepper : self.andCountLabel]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        for seg in segments {
            seg.selectedSegmentIndex = -1
            seg.addTarget(self, action: #selector(disableOtherSegmentedControl), forControlEvents: UIControlEvents.ValueChanged)
        }
        
        for stepper in stepperLabelDict.keys {
        
            stepper.addTarget(self, action: #selector(updateStepperLabel), forControlEvents: UIControlEvents.ValueChanged)
        
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func disableOtherSegmentedControl(sender: UISegmentedControl) {
        role = sender.titleForSegmentAtIndex(sender.selectedSegmentIndex)!
        for seg in segments {
            if (!seg.isEqual(sender)) {
                seg.selectedSegmentIndex = -1
            }
        }
    }

    func updateStepperLabel(sender: UIStepper) {
        let count = "\(Int(sender.value))"
        stepperLabelDict[sender]?.text = count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
