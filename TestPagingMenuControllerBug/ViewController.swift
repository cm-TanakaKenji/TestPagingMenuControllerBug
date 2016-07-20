//
//  ViewController.swift
//  TestPagingMenuControllerBug
//
//  Created by tanaka.kenji on 2016/07/19.
//  Copyright © 2016年 tanaka.kenji. All rights reserved.
//

import UIKit
import PagingMenuController



extension UIView {
    func adjustConstraintsTo(toView: UIView, attributes: (top: CGFloat, trailing: CGFloat, leading: CGFloat, bottom:  CGFloat) = (0, 0, 0, 0)) -> [NSLayoutConstraint] {
        return [
            NSLayoutConstraint(
                item: self, attribute: .Top, relatedBy: .Equal,
                toItem: toView, attribute: .Top, multiplier: 1.0,
                constant: attributes.top
            ),
            NSLayoutConstraint(
                item: self, attribute: .Trailing, relatedBy: .Equal,
                toItem: toView, attribute: .Trailing, multiplier: 1.0,
                constant: attributes.trailing
            ),
            NSLayoutConstraint(
                item: self, attribute: .Leading, relatedBy: .Equal,
                toItem: toView, attribute: .Leading, multiplier: 1.0,
                constant: attributes.leading
            ),
            NSLayoutConstraint(
                item: self, attribute: .Bottom, relatedBy: .Equal,
                toItem: toView, attribute: .Bottom, multiplier: 1.0,
                constant: attributes.bottom
            )
        ]
    }
}




class ViewController: UIViewController {

    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var scrollingFollowView: ScrollingFollowView!
    
    @IBOutlet weak var containerView: UIView!
    var pagingMenuController: PagingMenuController!
    
    private func setupPagingMenuController() {
        struct MenuItem1: MenuItemViewCustomizable {
            var displayMode: MenuItemDisplayMode {
                return .Text(title: MenuItemText(text: "メニュー1", color: UIColor.blackColor(), selectedColor: UIColor.greenColor(), font: UIFont.systemFontOfSize(12), selectedFont: UIFont.systemFontOfSize(14)))
            }
        }
        struct MenuItem2: MenuItemViewCustomizable {
            var displayMode: MenuItemDisplayMode {
                return .Text(title: MenuItemText(text: "メニュー2", color: UIColor.blackColor(), selectedColor: UIColor.greenColor(), font: UIFont.systemFontOfSize(12), selectedFont: UIFont.systemFontOfSize(14)))
            }
        }
        struct MenuItem3: MenuItemViewCustomizable {
            var displayMode: MenuItemDisplayMode {
                return .Text(title: MenuItemText(text: "メニュー3", color: UIColor.blackColor(), selectedColor: UIColor.greenColor(), font: UIFont.systemFontOfSize(12), selectedFont: UIFont.systemFontOfSize(14)))
            }
        }
        
        struct MenuOptions: MenuViewCustomizable {
            
            var height: CGFloat {
                return 44
            }
            
            var displayMode: MenuDisplayMode {
                let width = UIScreen.mainScreen().bounds.size.width / 4
                
                return .Infinite(widthMode: .Fixed(width: width), scrollingMode: .ScrollEnabled)
            }
            
            var focusMode: MenuFocusMode {
                return .Underline(height: 4, color: UIColor.greenColor(), horizontalPadding: 0, verticalPadding: 0)
            }
            
            var itemsOptions: [MenuItemViewCustomizable] {
                return [MenuItem1(), MenuItem2(), MenuItem3()]
            }
        }
        
        struct PagingMenuOptions: PagingMenuControllerCustomizable {
            var componentType: ComponentType {
                return .All(menuOptions: MenuOptions(), pagingControllers: viewControllers)
            }
            
            var viewControllers: [UIViewController] = []
        }
        
        var options = PagingMenuOptions()
        
        let storyboard = UIStoryboard(name: "Sub", bundle: NSBundle.mainBundle())
        
        let vc1 = storyboard.instantiateViewControllerWithIdentifier("VC") as! SubViewController
        let vc2 = storyboard.instantiateViewControllerWithIdentifier("VC") as! SubViewController
        let vc3 = storyboard.instantiateViewControllerWithIdentifier("VC") as! SubViewController
        
        // ----- ScrollingFollowView -----
        let didChangeContentOffset: ((UIScrollView) -> (Void)) = { [weak self] scrollView in
            guard let `self` = self else { return }
            
            self.scrollingFollowView.didScrolled(scrollView)
        }
        
        vc1.didChangeContentOffset = didChangeContentOffset
        vc2.didChangeContentOffset = didChangeContentOffset
        vc3.didChangeContentOffset = didChangeContentOffset
        
        vc1.beginDragging = scrollingFollowView.beginDragging
        vc2.beginDragging = scrollingFollowView.beginDragging
        vc3.beginDragging = scrollingFollowView.beginDragging
        
        vc1.endDragging = scrollingFollowView.endDragging
        vc2.endDragging = scrollingFollowView.endDragging
        vc3.endDragging = scrollingFollowView.endDragging
        // ------------------------------
        
        options.viewControllers = [vc1, vc2, vc3]
        
        pagingMenuController = PagingMenuController(options: options)
        pagingMenuController?.delegate = self
        
        pagingMenuController?.menuView?.layer.borderWidth = 1.0
        pagingMenuController?.menuView?.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        addChildViewController(pagingMenuController!)
        containerView.addSubview(pagingMenuController!.view)
        pagingMenuController!.didMoveToParentViewController(self)

        // TabBarに被らないようにconstraintを修正
        pagingMenuController!.view.translatesAutoresizingMaskIntoConstraints = false
        let constraints = pagingMenuController!.view.adjustConstraintsTo(containerView)
        containerView.addConstraints(constraints)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollingFollowView.setup(constraint: topConstraint)
        
        setupPagingMenuController()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // 対応策
        // その１: setupPagingMenuController()をviewDidAppear()内で呼ぶ
//        setupPagingMenuController()
        
        // その２: pagingMenuControllerのmenuViewのcontentInsetを設定し直す
//        pagingMenuController.menuView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension ViewController: PagingMenuControllerDelegate {
    
}

