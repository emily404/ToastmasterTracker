//
//  WordsViewController.swift
//  TMTracker
//
//  Created by Emily Chen on 2016-05-27.
//  Copyright © 2016 Emily Chen. All rights reserved.
//


import UIKit
import Alamofire

class WordsViewController: UIPageViewController {
    
    var currentPageIndex = 0
    let words = ["aloha", "merci"]
    let definitions = ["hello", "thanks"]
    let sampleSentences = ["aloha aloha", "merci merci"]
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newColoredViewController("firstWord"),
                self.newColoredViewController("secondWord")]
    }()
    
    private func newColoredViewController(color: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewControllerWithIdentifier("\(color)ViewController")
            
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        requestWords()
        
        if let firstViewController = orderedViewControllers.first {
            
            setViewControllers([firstViewController],
                               direction: .Forward,
                               animated: true,
                               completion: nil)

            updateLabels(firstViewController)
        }
        
        // TODO
        // why is that when i try to update labels both controllers here
        // only the already accessed controller aka first has non nil labels
        // second one throws nil error
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func requestWords() {
        // TODO: request for word of day and set to variable arrays
        //        Alamofire.request(.GET, "http://api.wordnik.com:80/v4/words.json/wordOfTheDay", parameters: ["api_key": "abab1110bb9971ab2530a00333403761dc891454564ad2f28", "date": "2016-04-27"])
        //            .responseJSON { response in
        //                print(response.request)  // original URL request
        //                print(response.response) // URL response
        //                print(response.data)     // server data
        //                print(response.result)   // result of response serialization
        //
        //                if let JSON = response.result.value {
        //                    print("JSON: \(JSON)")
        //                }
        //        }
        
    }
    
    func updateLabels(vc: UIViewController) {
        if let firstvc = vc as? FirstWordViewController {
            firstvc.word.text = words[0]
            firstvc.definition.text = definitions[0]
            firstvc.sampleSentence.text = sampleSentences[0]
        }
        else if let secondvc = vc as? SecondWordViewController {
            secondvc.word.text = words[1]
            secondvc.definition.text = definitions[1]
            secondvc.sampleSentence.text = sampleSentences[1]
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

// MARK: UIPageViewControllerDelegate

extension WordsViewController: UIPageViewControllerDelegate {
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
        
        updateLabels(pendingViewControllers.first!)

    }
    
}

// MARK: UIPageViewControllerDataSource

extension WordsViewController: UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController,
                            viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        currentPageIndex = previousIndex
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(pageViewController: UIPageViewController,
                            viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        currentPageIndex = nextIndex
        
        return orderedViewControllers[nextIndex]
    }
    
    // The number of items reflected in the page indicator.
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }
    
    // The selected item reflected in the page indicator.
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return currentPageIndex
    }
    
}