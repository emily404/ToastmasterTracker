//
//  SpeechTimerViewController.swift
//  TMTracker
//
//  Created by Emily Chen on 2016-05-25.
//  Copyright © 2016 Emily Chen. All rights reserved.
//

import UIKit
import Foundation

class SpeechTimerViewController: UIViewController {

    var counter = 0
    var timer = NSTimer()
    var secondsLeft = 450 // 07:30
    let lightChangeInterval = 60 // in seconds
    var speechTimeLeft = 420 // 7:00
    var minutesLabel = ""
    var secondsLabel = ""
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    @IBOutlet weak var trafficLight: UIImageView!
    @IBOutlet weak var timerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        
        trafficLight.backgroundColor = UIColor.greenColor()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        trafficLight.userInteractionEnabled = true
        trafficLight.addGestureRecognizer(tapGestureRecognizer)


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func timerAction() {
        displayLight()
        
        if(secondsLeft > 0) {
            secondsLeft -= 1
            speechTimeLeft -= 1
        } else {
            timer.invalidate()
        }
        minutesLabel = String(format: "%02d",(secondsLeft / 60) % 60)
        secondsLabel = String(format: "%02d", secondsLeft % 60)
        timerLabel.text = "\(minutesLabel)" + ":" + "\(secondsLabel)"
    }
    
    func displayLight() {
        if(speechTimeLeft > lightChangeInterval * 2) {
            // display green light
            trafficLight.backgroundColor = UIColor.greenColor()
        } else if(speechTimeLeft > lightChangeInterval && speechTimeLeft <= lightChangeInterval * 2) {
            // display yellow light
            trafficLight.backgroundColor = UIColor.yellowColor()
        } else if(speechTimeLeft == 0) {
            //display red light
            trafficLight.backgroundColor = UIColor.redColor()
        }
    }
    
    func imageTapped(sender: UITapGestureRecognizer) {
        timer.invalidate()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.navigationController?.navigationBarHidden = true
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
