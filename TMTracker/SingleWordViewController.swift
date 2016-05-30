//
//  SingleWordViewController.swift
//  TMTracker
//
//  Created by Emily Chen on 2016-05-29.
//  Copyright © 2016 Emily Chen. All rights reserved.
//

import UIKit

class SingleWordViewController: UIViewController {

    @IBOutlet weak var word: UILabel!
    @IBOutlet weak var definition: UILabel!
    @IBOutlet weak var example: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pc = UIPageControl(frame: CGRectMake(0,0, 300, 100))
        pc.center = CGPointMake(200, 600)
        self.view.addSubview(pc)
        pageControl = pc
        
        let wordLabel = UILabel(frame: CGRectMake(0, 0, 300, 21))
        wordLabel.center = CGPointMake(200, 100)
        wordLabel.textAlignment = NSTextAlignment.Natural
        self.view.addSubview(wordLabel)
        word = wordLabel

        let defLabel = UILabel(frame: CGRectMake(0, 0, 300, 120))
        defLabel.center = CGPointMake(200, 200)
        defLabel.lineBreakMode = .ByWordWrapping
        defLabel.numberOfLines = 5
        defLabel.textAlignment = NSTextAlignment.Left
        self.view.addSubview(defLabel)
        definition = defLabel

        let exampleLabel = UILabel(frame: CGRectMake(0, 0, 300, 120))
        exampleLabel.center = CGPointMake(200, 400)
        exampleLabel.lineBreakMode = .ByWordWrapping
        exampleLabel.numberOfLines = 8
        exampleLabel.textAlignment = NSTextAlignment.Left
        self.view.addSubview(exampleLabel)
        example = exampleLabel

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
