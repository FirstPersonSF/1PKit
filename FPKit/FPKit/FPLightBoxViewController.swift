//
//  FPLightBoxViewController.swift
//  testingModalPresentation
//
//  Created by Sruti Harikumar on 26/1/16.
//  Copyright © 2016 Sruti. All rights reserved.
//

import Foundation
import UIKit

class FPLightBoxViewController : UIViewController,UIScrollViewDelegate {
    
//MARK:- Properties
    var scrollView: UIScrollView!
    var image: UIImage!
    var referenceImageView: UIImageView!
    var imageView: UIImageView!
    var backgroundView: UIView!
    
    var referenceFrame: CGRect!
    var imageWidth: CGFloat!
    var imageHeight: CGFloat!
    
//MARK:- View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.snapIntoPlace()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
    
    
    
//MARK:- Layout Methods
    func setupUI() {
        
        self.backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        self.backgroundView.backgroundColor = UIColor.blackColor()
        self.backgroundView.alpha = 0
        self.view.addSubview(self.backgroundView)
        
        self.scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        self.scrollView.delegate = self
        self.scrollView.maximumZoomScale = 5.0
        self.scrollView.directionalLockEnabled = true
        self.scrollView.scrollEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        
        self.scrollView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.0)
        self.view.addSubview(self.scrollView)
        
        
        if self.image != nil {
            if self.referenceImageView != nil {
                self.referenceFrame = self.referenceImageView.frame
                //Setting Reference frame
                self.setReferenceFrameForMode(self.referenceImageView.contentMode)
                
                //Using the reference frame to set Up ImageView
                self.imageView = UIImageView(frame: self.referenceFrame)
                self.imageView.image = self.image
                self.imageView.contentMode = self.referenceImageView.contentMode
                self.imageView.clipsToBounds = false
                self.imageView.userInteractionEnabled = true
                self.imageView.layer.allowsEdgeAntialiasing = true
                
            }
            else {
                self.imageView = UIImageView(image: self.image)
                self.imageView.center = self.view.center
            }
            print("Content size \(self.scrollView.contentSize)")
            self.scrollView.addSubview(self.imageView)
            
        }
        else {
            self.imageView = UIImageView()
            self.imageView.center = self.view.center
        }
    }
    
    
    func snapIntoPlace() {
        
        var widthImage: CGFloat
        var heightImage: CGFloat
        var heightRatio, widthRatio : CGFloat
        
        let currentWidth = self.imageView.frame.size.width
        let currentHeight = self.imageView.frame.size.height
        
        let imageAspect = self.imageWidth / self.imageHeight
        print("Image Aspect :\(imageAspect)")
        
        let deviceWidth = self.view.frame.size.width
        let deviceHeight = self.view.frame.size.height
        let deviceAspect = (deviceWidth/deviceHeight)
        
        
        
        if deviceAspect > 1 && imageAspect > 1 {
            heightImage = deviceHeight
            widthImage = imageAspect * heightImage
        }
        else {
            widthImage = deviceWidth
            heightImage = (widthImage / imageAspect)
        }
        
        
        heightRatio = heightImage / currentHeight
        widthRatio = widthImage / currentWidth
        
        print("Height Ratio :\(heightRatio)")
        print("Width Ratio :\(widthRatio)")
        
        self.imageView.contentMode = .ScaleToFill
        UIView.animateWithDuration(0.4, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
            ()-> Void in
            self.imageView.transform = CGAffineTransformMakeScale(widthRatio, heightRatio)
            self.imageView.center = self.view.center
            //self.imageView.clipsToBounds = true
            self.scrollView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)
            
            }, completion: nil)
        
        self.scrollView.minimumZoomScale = self.scrollView.zoomScale
        self.scrollView.contentSize = self.imageView.frame.size
        print("Scroll view content size after animation: \(self.scrollView.contentSize)")
        print("Current zoom scale: \(self.scrollView.zoomScale)")
        print("Image View size after animation \(self.imageView.frame.size)")
    }
    
//MARK:- Scroll View Delegate Methods
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        self.centerScrollViewContents()
        print("Image View size while zooming: \(self.imageView.frame.size)")
        print("Scroll view content size while zooming: \(self.scrollView.contentSize)")
    }
    
//MARK:- Helper Methods
    func setReferenceFrameForMode(mode: UIViewContentMode) {
        
        
        let widthRatio = self.referenceImageView.bounds.size.width / (self.referenceImageView.image != nil ? (self.referenceImageView.image?.size.width)! : self.referenceImageView.bounds.size.width)
        let heightRatio = self.referenceImageView.bounds.size.height / (self.referenceImageView.image != nil ? (self.referenceImageView.image?.size.height)! : self.referenceImageView.bounds.size.height)
        
        switch(mode) {
        case .ScaleAspectFit:
            let scale = min(widthRatio, heightRatio)
            self.imageWidth = scale * (self.referenceImageView.image != nil ? self.referenceImageView.image!.size.width : 0)
            self.imageHeight = scale * (self.referenceImageView.image != nil ? self.referenceImageView.image!.size.height : 0)
            let imageX = ((self.referenceFrame.size.width - self.imageWidth) / 2) + self.referenceFrame.origin.x
            let imageY = ((self.referenceFrame.size.height - self.imageHeight) / 2) + self.referenceFrame.origin.y
            self.referenceFrame = CGRectMake(imageX, imageY, self.imageWidth, self.imageHeight)
        case .ScaleAspectFill:
            let scale = max(widthRatio, heightRatio)
            self.imageWidth = scale * (self.referenceImageView.image != nil ? self.referenceImageView.image!.size.width : 0)
            self.imageHeight = scale * (self.referenceImageView.image != nil ? self.referenceImageView.image!.size.height : 0)
            let imageX = ((self.referenceFrame.size.width - self.imageWidth) / 2) + self.referenceFrame.origin.x
            let imageY = ((self.referenceFrame.size.height - self.imageHeight) / 2) + self.referenceFrame.origin.y
            self.referenceFrame = CGRectMake(imageX, imageY, self.imageWidth, self.imageHeight)
        case .ScaleToFill:
            self.imageWidth = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.width : 0
            self.imageHeight = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.height : 0
            self.referenceFrame = self.referenceImageView.frame
        case .Top:
            self.imageWidth = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.width : 0
            self.imageHeight = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.height : 0
            let imageX = ((self.referenceFrame.size.width - self.imageWidth) / 2) + self.referenceFrame.origin.x
            let imageY = self.referenceFrame.origin.y
            self.referenceFrame = CGRectMake(imageX, imageY, self.imageWidth, self.imageHeight)
        case .Bottom:
            self.imageWidth = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.width : 0
            self.imageHeight = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.height : 0
            let imageX = ((self.referenceFrame.size.width - self.imageWidth) / 2) + self.referenceFrame.origin.x
            let imageY = (self.referenceFrame.size.height + self.referenceFrame.origin.y) - self.imageHeight
            self.referenceFrame = CGRectMake(imageX, imageY, self.imageWidth, self.imageHeight)
        case .Left:
            self.imageWidth = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.width : 0
            self.imageHeight = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.height : 0
            let imageX = self.referenceFrame.origin.x
            let imageY = ((self.referenceFrame.size.height - self.imageHeight) / 2) + self.referenceFrame.origin.y
            self.referenceFrame = CGRectMake(imageX, imageY, self.imageWidth, self.imageHeight)
        case .Right:
            self.imageWidth = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.width : 0
            self.imageHeight = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.height : 0
            let imageX = (self.referenceFrame.origin.x + self.referenceFrame.size.width) - self.imageWidth
            let imageY = ((self.referenceFrame.size.height - self.imageHeight) / 2) + self.referenceFrame.origin.y
            self.referenceFrame = CGRectMake(imageX, imageY, self.imageWidth, self.imageHeight)
        case .Center:
            self.imageWidth = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.width : 0
            self.imageHeight = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.height : 0
            let imageX = self.referenceImageView.frame.origin.x + ((self.referenceImageView.frame.width - self.imageWidth) / 2)
            let imageY = self.referenceImageView.frame.origin.y + ((self.referenceImageView.frame.height - self.imageHeight) / 2)
            self.referenceFrame = CGRectMake(imageX, imageY, self.imageWidth, self.imageHeight)
        case .TopLeft:
            self.imageWidth = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.width : 0
            self.imageHeight = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.height : 0
            let imageX = self.referenceFrame.origin.x
            let imageY = self.referenceFrame.origin.y
            self.referenceFrame = CGRectMake(imageX, imageY, self.imageWidth, self.imageHeight)
        case .TopRight:
            self.imageWidth = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.width : 0
            self.imageHeight = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.height : 0
            let imageX = self.referenceFrame.origin.x + self.referenceFrame.size.width - self.imageWidth
            let imageY = self.referenceFrame.origin.y
            self.referenceFrame = CGRectMake(imageX, imageY, self.imageWidth, self.imageHeight)
        case .BottomLeft:
            self.imageWidth = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.width : 0
            self.imageHeight = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.height : 0
            let imageX = self.referenceFrame.origin.x
            let imageY = self.referenceFrame.origin.y + self.referenceFrame.size.height - self.imageHeight
            self.referenceFrame = CGRectMake(imageX, imageY, self.imageWidth, self.imageHeight)
        case .BottomRight:
            self.imageWidth = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.width : 0
            self.imageHeight = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.height : 0
            let imageX = self.referenceFrame.origin.x + self.referenceFrame.size.width - self.imageWidth
            let imageY = self.referenceFrame.origin.y + self.referenceFrame.size.height - self.imageHeight
            self.referenceFrame = CGRectMake(imageX, imageY, self.imageWidth, self.imageHeight)
        case .Redraw:
            self.imageWidth = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.width : 0
            self.imageHeight = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.height : 0
            self.referenceFrame = self.referenceImageView.frame
        }
        
    }
    func centerScrollViewContents() {
        let boundsSize = self.scrollView.bounds.size
        var contentsFrame = self.imageView.frame
        
        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        } else {
            contentsFrame.origin.x = 0.0
        }
        
        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
        } else {
            contentsFrame.origin.y = 0.0
        }
        self.imageView.frame = contentsFrame
    }
}