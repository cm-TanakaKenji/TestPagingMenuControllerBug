//
//  SubViewController.swift
//  TestPagingMenuControllerBug
//
//  Created by tanaka.kenji on 2016/07/19.
//  Copyright © 2016年 tanaka.kenji. All rights reserved.
//

import UIKit

class SubViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var didChangeContentOffset: ((UIScrollView) -> (Void))?
    var beginDragging: (() -> ())?
    var endDragging: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
}

extension SubViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        cell?.textLabel?.text = "\(indexPath.row)"
        
        return cell!
    }
}

extension SubViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        didChangeContentOffset?(scrollView)
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        beginDragging?()
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        endDragging?()
    }
}