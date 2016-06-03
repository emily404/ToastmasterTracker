//
//  RoleResultPageViewController.swift
//  TMTracker
//
//  Created by Emily Chen on 2016-06-02.
//  Copyright © 2016 Emily Chen. All rights reserved.
//

import UIKit
import RealmSwift

class RoleResultPageViewController: UIPageViewController {

    var roles = [String]()
    var currentPage = 0
    var roleLogs = [RoleLog]()
    
    private func newViewController(id: String) -> UIViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewControllerWithIdentifier(id)
        return vc
    }
    
    private(set) lazy var viewControllersData: [UIViewController] = {
        let id = "ResultViewController"
        var vcList = [UIViewController]()
        for index in 0..<self.roles.count {
            let vc = self.newViewController(id)
            vc.title = self.roles[index]
            vcList.append(vc)
        }
        return vcList
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newButton = UIBarButtonItem(title: self.iterationButtonText(currentPage), style: UIBarButtonItemStyle.Done, target: self, action: #selector(saveResult))
        self.navigationItem.rightBarButtonItem = newButton;
        self.navigationItem.title = roles[currentPage]
        
        if let vc = viewControllersData.first {
            setViewControllers([vc],
                               direction: .Forward,
                               animated: true,
                               completion: nil)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func iterationButtonText(index: Int) -> String {
        if (index == viewControllersData.count - 1) {
            return "Done"
        } else {
            return "Next"
        }
    }
    
    func saveResult(sender: UIBarButtonItem) {
        if let vc = viewControllers!.first as? ResultViewController {
            // create db object
            let roleLog = RoleLog()
            roleLog.name = roles[currentPage]
            roleLog.minute = vc.min
            roleLog.second = vc.sec
            roleLog.fillerCount = vc.filler
            roleLog.dateAdded = vc.date
            
            // add to temperary array
            roleLogs.append(roleLog)
            
            // go to next log entry
            let nextPage = currentPage + 1
            if (nextPage < viewControllersData.count) {
                let nextVC = viewControllersData[nextPage]

                self.navigationItem.rightBarButtonItem?.title = iterationButtonText(nextPage)
                self.navigationItem.title = roles[nextPage]

                setViewControllers([nextVC],
                                   direction: .Forward,
                                   animated: true,
                                   completion: nil)

                currentPage = nextPage
                
            } else {
                // write all logs to local at once so that if user aborts halfway there will be no data write
                let realm = try! Realm()
                try! realm.write {
                    print("writing to Realm")
                    for roleLog in roleLogs {
                        print(roleLog)
                        realm.add(roleLog)
                    }
                }
                
                // finish logging, go back to main nav
                if let navController = self.navigationController {
                    navController.popToRootViewControllerAnimated(true)
                }

                
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
