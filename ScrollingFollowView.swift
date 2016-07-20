//
//  ScrollingFollowView.swift
//  TestPagingMenuControllerBug
//
//  Created by tanaka.kenji on 2016/07/19.
//  Copyright © 2016年 tanaka.kenji. All rights reserved.
//

import UIKit

class ScrollingFollowView: UIView {
    
    private var previousPoint: CGFloat = 0
    private var isDragging = false
    
    weak var constraint: NSLayoutConstraint!
    
    func setup(constraint cons: NSLayoutConstraint) {
        constraint = cons
    }
    
    func didScrolled(scrollView: UIScrollView) {
        let currentPoint = -scrollView.contentOffset.y
        let minPoint: CGFloat = -frame.size.height
        let maxPoint: CGFloat = 0
        
        let differencePoint = currentPoint - previousPoint
        let nextPoint = constraint.constant + differencePoint
        
        // contentOffsetの下端、上端で余計なconstraint.constantの値の変更をさせない処理
        if isTopOrBottomEdge(currentPoint, scrollView: scrollView) { return }
        
        if nextPoint < minPoint {
            constraint.constant = minPoint
        } else if nextPoint > maxPoint {
            constraint.constant = maxPoint
        } else {
            if isDragging {
                constraint.constant += differencePoint
            }
        }
        
        previousPoint = currentPoint
    }
    
    private func isTopOrBottomEdge(currentPoint: CGFloat, scrollView: UIScrollView) -> Bool {
        if -currentPoint >= scrollView.contentSize.height - scrollView.bounds.size.height || -currentPoint <= 0 {
            return true
        }
        
        return false
    }
    
    func resetPreviousPoint(scrollView: UIScrollView) {
        previousPoint = -scrollView.contentOffset.y
    }
    
    func beginDragging() {
        isDragging = true
    }
    
    func endDragging() {
        isDragging = false
    }
    
}
