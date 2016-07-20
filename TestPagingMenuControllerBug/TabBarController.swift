//
//  TabBarController.swift
//  TestPagingMenuControllerBug
//
//  Created by tanaka.kenji on 2016/07/19.
//  Copyright © 2016年 tanaka.kenji. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstViewController = UIStoryboard(name: "Sub", bundle: NSBundle.mainBundle()).instantiateInitialViewController()
        let secondViewController = UIStoryboard(name: "Sub", bundle: NSBundle.mainBundle()).instantiateInitialViewController()
        let thirdViewController = UIStoryboard(name: "Sub", bundle: NSBundle.mainBundle()).instantiateInitialViewController()
        
        guard let item1 = firstViewController else { fatalError("Empty first ViewController") }
        guard let item2 = secondViewController else { fatalError("Empty second ViewController") }
        guard let item3 = thirdViewController else { fatalError("Empty third ViewController") }
        
        item1.tabBarItem = UITabBarItem(title: "1", image: nil, selectedImage: nil)
        item2.tabBarItem = UITabBarItem(title: "2", image: nil, selectedImage: nil)
        item3.tabBarItem = UITabBarItem(title: "3", image: nil, selectedImage: nil)
        
        let viewControllers = [item1, item2, item3]
        
        setViewControllers(viewControllers, animated: true)
    }
    
}
