//
//  WordsPageViewController.swift
//  TMTracker
//
//  Created by Emily Chen on 2016-06-02.
//  Copyright © 2016 Emily Chen. All rights reserved.
//

import UIKit
import Alamofire

class WordsPageViewController: UIPageViewController {
    
    typealias CompletionHandler = (success:Bool) -> Void
    var words = [String]()
    var definitions = [String]()
    var exampleSentences = [String]()
    var currentPage = 0
    
    private func newViewController(id: String) -> UIViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil) .
        instantiateViewControllerWithIdentifier(id)
        return vc
    }
    
    private(set) lazy var viewControllersData: [UIViewController] = {
        let id = "WordViewController"
        return [self.newViewController(id), self.newViewController(id), self.newViewController(id)]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setWordData()
        
        if let vc = viewControllersData.first {
            setViewControllers([vc],
                               direction: .Forward,
                               animated: true,
                               completion: nil)
        }
        
        dataSource = self
        delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setWordData() {
        let dateFormatter = NSDateFormatter()
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
            self.updateLabel(self.currentPage)
        }
    }
    
    func updateLabel(currentPage: Int) {
        let vc = viewControllersData[currentPage]
        if let wordViewVC = vc as? WordViewController {
            wordViewVC.word.text = self.words[currentPage]
            wordViewVC.definition.text = self.definitions[currentPage]
            wordViewVC.exampleSentence.text = self.exampleSentences[currentPage]
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
                    print(word)
                    self.words.append(word as! String)
                    self.definitions.append(definition as! String)
                    self.exampleSentences.append(example as! String)
                    
                    completionHandler(success: true)
                }
        }
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

extension WordsPageViewController: UIPageViewControllerDelegate {

    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
        updateLabel(viewControllersData.indexOf(pendingViewControllers.first!)!)
    }
}

extension WordsPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController,
                            viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = viewControllersData.indexOf(viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 && previousIndex < viewControllersData.count else {
            return nil
        }
        
        currentPage = previousIndex
        
        return viewControllersData[previousIndex]
    }
    
    func pageViewController(pageViewController: UIPageViewController,
                            viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = viewControllersData.indexOf(viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < viewControllersData.count else {
            return nil
        }
        
        currentPage = nextIndex
        
        return viewControllersData[nextIndex]
    }
    
    // The number of items reflected in the page indicator.
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return viewControllersData.count
    }
    
    // The selected item reflected in the page indicator.
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return currentPage
    }
    
}
