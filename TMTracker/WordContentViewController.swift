//
//  WordContentViewController.swift
//  TMTracker
//
//  Created by Emily Chen on 2016-05-29.
//  Copyright © 2016 Emily Chen. All rights reserved.
//

import UIKit
import EZSwipeController
import Alamofire

class WordContentViewController: EZSwipeController {
    
    typealias CompletionHandler = (success:Bool) -> Void
    let dateFormatter = NSDateFormatter()
    var words = [String]()
    var definitions = [String]()
    var exampleSentences = [String]()

    override func setupView() {
        datasource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabels(stackVC)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension WordContentViewController: EZSwipeControllerDataSource {
    func viewControllerData() -> [UIViewController] {
        
        let redVC = SingleWordViewController()
        redVC.view.backgroundColor = UIColor.redColor()
        let blueVC = SingleWordViewController()
        blueVC.view.backgroundColor = UIColor.blueColor()
        let greenVC = SingleWordViewController()
        greenVC.view.backgroundColor = UIColor.brownColor()
        
        return [redVC, blueVC, greenVC]

    }
    
    func updateLabels(vcs: [UIViewController]) {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let today = NSDate()
        let yesterday = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: -1, toDate: today, options: NSCalendarOptions(rawValue: 0))
        let tomorrow = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: 1, toDate: today, options: NSCalendarOptions(rawValue: 0))
        
        let todayStr = dateFormatter.stringFromDate(today)
        let yesterdayStr = dateFormatter.stringFromDate(yesterday!)
        let tomorrowStr = dateFormatter.stringFromDate(tomorrow!)

        let dates = [yesterdayStr, todayStr, tomorrowStr]
        
        let requestGroup = dispatch_group_create()
        for date in dates {
            dispatch_group_enter(requestGroup)
            requestWord(date,
                        completionHandler: { (success) -> Void in
                            if(success){
                                dispatch_group_leave(requestGroup)
                            } else {
                                print("unsuccessful API request")
                            }
            })
        }
        
        dispatch_group_notify(requestGroup, dispatch_get_main_queue()) {
            for (index,vc) in vcs.enumerate() {
                if let castedVC = vc as? SingleWordViewController {
                    castedVC.word.text = self.words[index]
                    castedVC.definition.text = self.definitions[index]
                    castedVC.example.text = self.exampleSentences[index]
                    castedVC.pageControl.numberOfPages = vcs.count
                    castedVC.pageControl.currentPage = index
                }
            }
        }
    }
    
    
    func requestWord(date: String, completionHandler: CompletionHandler) {
        Alamofire.request(.GET, "http://api.wordnik.com:80/v4/words.json/wordOfTheDay", parameters: ["api_key": "abab1110bb9971ab2530a00333403761dc891454564ad2f28", "date": date])
            .responseJSON {
                response in
                
                if let JSON = response.result.value {
                    
                    guard let word = JSON["word"]!,
                        let definition = JSON["definitions"]!![0]["text"]!,
                        let example = JSON["examples"]!![0]["text"] else {
                            print("error parsing JSON from wordnik")
                            return;
                    }
                    
                    self.words.append(word as! String)
                    self.definitions.append(definition as! String)
                    self.exampleSentences.append(example as! String)
                    
                    completionHandler(success: true)
                }
        }
    }
    
}
