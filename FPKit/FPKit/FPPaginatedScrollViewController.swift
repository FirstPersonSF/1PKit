//
//  FPPaginatedScrollViewController.swift
//  FPKit
//
//  Created by Sruti Harikumar on 25/1/16.
//  Copyright © 2016 First Person. All rights reserved.
//

import Foundation
import UIKit



/*class FPPaginatedScrollViewController : UIViewController {
    
    var scrollView: UIScrollView!
    var pageViewController: UIPageViewController!
    var horizontalStackView: UIStackView!
    
//MARK:- Init Methods
    //Overriding initWithNibName
    required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.paginatedScrollViewControllerCommonInit()
    }
    
    //Overriding initWithCoder
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.paginatedScrollViewControllerCommonInit()
    }
    
    //Common/ Default Init Method
    func paginatedScrollViewControllerCommonInit() {
        
        scrollView = UIScrollView()
        pageViewController = UIPageViewController()
        horizontalStackView = UIStackView()
        
        scrollView.addSubview(horizontalStackView)
        
        self.addDefaultConstraints()
    }
    
    func addDefaultConstraints() {
        
        
        //Adding constraints to Scroll View
        let leadingSpaceConstraintScrollView = NSLayoutConstraint(item: self.scrollView, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1.0, constant: 0)
        let trailingSpaceConstraintScrollView = NSLayoutConstraint(item: self.scrollView, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .Trailing, multiplier: 1.0, constant: 0)
        let topSpaceConstraintScrollView = NSLayoutConstraint(item: self.scrollView, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1.0, constant: 0)
        let bottomSpaceConstraintScrollView = NSLayoutConstraint(item: self.scrollView, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: 0)
        
        let scrollViewConstraints : [NSLayoutConstraint] = [leadingSpaceConstraintScrollView, trailingSpaceConstraintScrollView, topSpaceConstraintScrollView, bottomSpaceConstraintScrollView]
        self.scrollView.addConstraints(scrollViewConstraints)
        
        
        //Adding constraints to Stack View
        let leadingSpaceConstraintStackView = NSLayoutConstraint(item: self.horizontalStackView, attribute: .Leading, relatedBy: .Equal, toItem: self.scrollView, attribute: .Leading, multiplier: 1.0, constant: 0)
        let trailingSpaceConstraintStackView = NSLayoutConstraint(item: self.horizontalStackView, attribute: .Trailing, relatedBy: .Equal, toItem: self.scrollView, attribute: .Trailing, multiplier: 1.0, constant: 0)
        let topSpaceConstraintStackView = NSLayoutConstraint(item: self.horizontalStackView, attribute: .Top, relatedBy: .Equal, toItem: self.scrollView, attribute: .Top, multiplier: 1.0, constant: 0)
        let bottomSpaceConstraintStackView = NSLayoutConstraint(item: self.horizontalStackView, attribute: .Bottom, relatedBy: .Equal, toItem: self.scrollView, attribute: .Bottom, multiplier: 1.0, constant: 0)
        let heightConstraintStackView = NSLayoutConstraint(item: self.horizontalStackView, attribute: .Width, relatedBy: .Equal, toItem: self.view, attribute: .Width, multiplier: 1.0, constant: 0)
        
        let stackViewConstraints : [NSLayoutConstraint] = [leadingSpaceConstraintStackView, trailingSpaceConstraintStackView, topSpaceConstraintStackView, bottomSpaceConstraintStackView, heightConstraintStackView]
        self.horizontalStackView.addConstraints(stackViewConstraints)
        
    }
    
    
    
    
}*/