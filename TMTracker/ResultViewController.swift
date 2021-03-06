//
//  ResultsViewController.swift
//  TMTracker
//
//  Created by Emily Chen on 2016-01-28.
//  Copyright © 2016 Em C. All rights reserved.
//

import UIKit

class ResultViewController: UITableViewController,UIPickerViewDataSource,UIPickerViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    var min: Int = 0
    var sec: Int = 0
    var filler: Int = 0
    var date = ""
    
    let timePickerData = [
        ["0m","1m","2m","3m","5m","6m","7m"],
        ["10s","20s","30s","40s","50s"]
    ]
    let fillerPickerData = [["0","1","2","3","4","5","10","15","20"]]
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var timePicker: UIPickerView!
    @IBOutlet weak var fillerCountPicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var imagePickerController : UIImagePickerController!
    @IBOutlet var commentsImage: UIImageView!
    @IBAction func seePhotos(sender: UIButton) {
        imagePickerController.sourceType = .PhotoLibrary
        //TODO: add option of taking photo from app
//        imagePickerController.sourceType = .Camera
        presentViewController(imagePickerController, animated: true){
            print("present camera view")
        }
    }
    
    //MARK -Instance Methods
    func pickerViewUpdate(){
        let minStr = timePickerData[0][timePicker.selectedRowInComponent(0)]
        let secStr = timePickerData[1][timePicker.selectedRowInComponent(1)]
        min = Int(minStr.stringByReplacingOccurrencesOfString("m", withString: ""))!
        sec = Int(secStr.stringByReplacingOccurrencesOfString("s", withString: ""))!
        
        let fillerStr = fillerPickerData[0][fillerCountPicker.selectedRowInComponent(0)]
        filler = Int(fillerStr)!
    }
    
    func datePickerUpdate() {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        date = dateFormatter.stringFromDate(datePicker.date)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timePicker.delegate = self
        timePicker.dataSource = self
        fillerCountPicker.delegate = self
        fillerCountPicker.dataSource = self

        timePicker.selectRow(4, inComponent: 0, animated: false)
        timePicker.selectRow(2, inComponent: 1, animated: false)
        fillerCountPicker.selectRow(5, inComponent: 0, animated: false)
        datePicker.addTarget(self, action: #selector(datePickerChanged), forControlEvents: UIControlEvents.ValueChanged)

        pickerViewUpdate()
        datePickerUpdate()
        
        imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        commentsImage.userInteractionEnabled = true
        commentsImage.addGestureRecognizer(tapGestureRecognizer)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            commentsImage.contentMode = .ScaleAspectFit
            commentsImage.image = pickedImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imageTapped(sender: UITapGestureRecognizer) {
        //TODO: zoom with UIScrollView
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        newImageView.contentMode = .ScaleAspectFit
        newImageView.frame = self.view.frame
        newImageView.backgroundColor = .blackColor()
        newImageView.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
    }
    
    func dismissFullscreenImage(sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }
    
    //MARK -Delgates and DataSource
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        if(pickerView == timePicker){
            return timePickerData.count
        }else{
            return fillerPickerData.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == timePicker){
            return timePickerData[component].count
        }else{
            return fillerPickerData[component].count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView == timePicker){
            return timePickerData[component][row]
        }else{
            return fillerPickerData[component][row]
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerViewUpdate()
    }
    
    func datePickerChanged(datePicker:UIDatePicker) {
        datePickerUpdate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

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
