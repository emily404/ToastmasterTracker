//
//  SpeechTimerViewController.swift
//  TMTracker
//
//  Created by Emily Chen on 2016-05-25.
//  Copyright © 2016 Emily Chen. All rights reserved.
//

import UIKit
import AVFoundation

class SpeechTimerViewController: UIViewController {

    var counter = 0
    var timer = NSTimer()
    // original vars
    
//    var totalTime = 450
//    var secondsLeft = 450 // 07:30
//    let lightChangeInterval = 60 // in seconds
//    var speechTimeLeft = 420 // 7:00

    // test vars
    var totalTime = 3
    var secondsLeft = 3
    let lightChangeInterval = 1
    var speechTimeLeft = 2
    var speechTimeElapsed = 0
    
    var minutesLabel = ""
    var secondsLabel = ""
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    var audioPlayer: AVAudioPlayer?
    
    
    @IBOutlet weak var timerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTimerLabel()
        
        timer.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(exitTimer))
        self.view.userInteractionEnabled = true
        self.view.addGestureRecognizer(tapGestureRecognizer)


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
            clappingDown()
            timer.invalidate()
        }
        
        updateTimerLabel()
        
    }
    
    func clappingDown() {
        let bundle = NSBundle.mainBundle().pathForResource("applause", ofType: "wav")!
        let clap = NSURL(fileURLWithPath: bundle)
        
        do {
            
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOfURL: clap)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.play()
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func updateTimerLabel() {
        let timeElasped = totalTime - secondsLeft
        minutesLabel = String(format: "%02d",(timeElasped / 60) % 60)
        secondsLabel = String(format: "%02d", timeElasped % 60)
        timerLabel.text = "\(minutesLabel)" + ":" + "\(secondsLabel)"
    }
    
    func displayLight() {
        if(speechTimeLeft > lightChangeInterval * 2) {
            // display green light
            self.view.backgroundColor = UIColor.greenColor()
        } else if(speechTimeLeft > lightChangeInterval && speechTimeLeft <= lightChangeInterval * 2) {
            // display yellow light
            self.view.backgroundColor = UIColor.yellowColor()
        } else if(speechTimeLeft == 0) {
            //display red light
            self.view.backgroundColor = UIColor.redColor()
        }
    }
    
    func exitTimer(sender: UITapGestureRecognizer) {
        timer.invalidate()
        audioPlayer?.stop()
        
        self.navigationController?.popViewControllerAnimated(true)
        self.navigationController?.navigationBarHidden = false
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
