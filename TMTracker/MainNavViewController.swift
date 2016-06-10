//
//  MainNavViewController.swift
//  TMTracker
//
//  Created by Emily Chen on 2016-05-24.
//  Copyright © 2016 Emily Chen. All rights reserved.
//

import UIKit


class MainNavViewController: UICollectionViewController {

    let navMenuItem = [["TimerTool", "WordOfTheDay", "LogResult", "GrammarianTool"]]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let flow = collectionViewLayout as? UICollectionViewFlowLayout {
            flow.itemSize = CGSize(width: 60, height: 60)
            // margin of the collection of cells
            flow.sectionInset = UIEdgeInsets(top: 60.0, left: 60.0, bottom: 60.0, right: 60.0)
            flow.minimumLineSpacing = 50 // cell spacing
        }


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes 
        // uncomment if using custom cell xib
        // self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "TimerTool")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return navMenuItem.count
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return navMenuItem[section].count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let reuseIdentifier = navMenuItem[indexPath.section][indexPath.item]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
    
        // Configure the cell
        let title = UILabel(frame: CGRectMake(0, 0, cell.bounds.size.width, 40))
        title.lineBreakMode = .ByClipping
        title.text = reuseIdentifier
        title.font = UIFont(name: "Arial", size: 15)
        cell.contentView.addSubview(title)
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
