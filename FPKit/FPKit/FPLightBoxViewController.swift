//
//  FPLightBoxViewController.swift
//  testingModalPresentation
//
//  Created by Sruti Harikumar on 26/1/16.
//  Copyright © 2016 Sruti. All rights reserved.
//

import Foundation
import UIKit

struct FPLightBoxViewControllerConstants {
    static let dismissalFlickVelocityMagnitude: CGFloat = 2000.0
    static let mediumAnimationDuration = 0.4
    static let fastAnimationDuration = 0.2
    static let defaultZoomFactor: CGFloat = 3.0
}

public class FPLightBoxViewController : UIViewController,UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    //MARK:- Properties
    
    public var image: UIImage!
    public var referenceImageView: UIImageView!
    public var backgroundViewColor: UIColor!
    public var backgroundViewAlpha: Float!
    public var maximumZoomFactor: Float!
    
    private var imageView: UIImageView!
    private var finalViewAlpha: CGFloat!
    private var backgroundView: UIView!
    private var scrollView: UIScrollView!
    private var animator: UIDynamicAnimator!
    private var referenceFrame: CGRect!
    private var imageWidth: CGFloat!
    private var imageHeight: CGFloat!
    private var prevWidth: CGFloat!
    private var prevHeight: CGFloat!
    private var finalZoomFactor: CGFloat!
    
    //MARK:- Flags
    private var isPresented = false
    
    //MARK:- View Controller Methods
    override  public func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
        self.animator = UIDynamicAnimator(referenceView: self.scrollView)
        
        //Hooking up the flick gesture and adding it to the Image View
        let flickGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handleFlick:" )
        flickGestureRecognizer.delegate = self
        self.imageView.addGestureRecognizer(flickGestureRecognizer)
        
    }
    
    override public func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.snapIntoPlace()
    }
    
    override public func prefersStatusBarHidden() -> Bool {
        return true;
    }
    
    override public func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.AllButUpsideDown
    }
    
    //MARK:- Orientation change
    
    override public func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        //Before rotation
        self.prevWidth = self.imageView.frame.size.width
        self.prevHeight = self.imageView.frame.size.height
        
        let midPoint = CGPointMake((size.height/2), (size.width/2))
        var point = self.view.convertPoint(midPoint, toView: self.imageView)
        point.x = point.x * self.scrollView.zoomScale
        point.y = point.y * self.scrollView.zoomScale
        let xRatio = (point.x / self.imageView.frame.size.width)
        let yRatio = (point.y / self.imageView.frame.size.height)
        
        coordinator.animateAlongsideTransition({
            (context: UIViewControllerTransitionCoordinatorContext ) -> Void in
            
            //During rotation
            self.switchingToSize(size, xRatio : xRatio,yRatio: yRatio)
            
            })
            {
                (context: UIViewControllerTransitionCoordinatorContext) -> Void in
                
                //After rotation
        }
    }
    
    //MARK:- Layout Methods
    func setupUI() {
        
        self.backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        self.backgroundView.backgroundColor = UIColor.blackColor()
        self.backgroundView.alpha = 0
        self.view.addSubview(self.backgroundView)
        
        self.scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        self.scrollView.delegate = self
        
        self.scrollView.directionalLockEnabled = true
        self.scrollView.scrollEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.backgroundColor = UIColor.clearColor()
        
        if let color = self.backgroundViewColor {
            self.backgroundView.backgroundColor = color
        }
        else {
            self.backgroundView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.8)
        }
        
        if let alpha = self.backgroundViewAlpha {
            self.finalViewAlpha = CGFloat(alpha)
        }
        else {
            self.finalViewAlpha = 1.0
        }
        
        //Checking for passed zoomFactor
        if let factor = self.maximumZoomFactor{
            self.finalZoomFactor = CGFloat(factor)
        }
        else
        {
            self.finalZoomFactor = FPLightBoxViewControllerConstants.defaultZoomFactor
        }
        
        
        self.scrollView.maximumZoomScale = self.finalZoomFactor
        self.view.addSubview(self.scrollView)
        
        
        if self.image != nil {
            if self.referenceImageView != nil {
                //Initializing ReferenceFrame
                self.referenceFrame = self.referenceImageView.convertRect(self.referenceImageView.frame, toView: nil)
                //Setting Reference frame
                self.referenceFrame = self.setReferenceFrameForMode(self.referenceImageView.contentMode)
                
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

        
        let imageAspect = self.imageWidth / self.imageHeight
        
        
        let deviceWidth = self.view.frame.size.width
        let deviceHeight = self.view.frame.size.height
        let deviceAspect = (deviceWidth/deviceHeight)
        
        
        var actualImageWidth: CGFloat = 0
        var actualImageHeight: CGFloat = 0
        
        if let image = self.referenceImageView.image {
            actualImageWidth = image.size.width
            actualImageHeight = image.size.height
        }
        
        
        if deviceAspect > 1 {
            if actualImageHeight > 0  && actualImageHeight >= deviceHeight {
                heightImage = deviceHeight
            }
            else {
                heightImage = actualImageWidth
            }
            
            widthImage = imageAspect * heightImage
        }
        else {
            if actualImageWidth > 0  && actualImageWidth >= deviceWidth {
                widthImage = deviceWidth
            }
            else {
                widthImage = actualImageWidth
            }
            heightImage = (widthImage / imageAspect)
        }
        
        
        UIView.animateWithDuration(FPLightBoxViewControllerConstants.mediumAnimationDuration, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
            ()-> Void in
            
            self.imageView.frame = CGRectMake(0,0,widthImage,heightImage)
            self.imageView.center = self.view.center
            self.backgroundView.alpha = self.finalViewAlpha
            
            }, completion: nil)
        self.imageView.contentMode = .ScaleToFill
        self.scrollView.minimumZoomScale = self.scrollView.zoomScale
        self.scrollView.maximumZoomScale = self.scrollView.minimumZoomScale * self.finalZoomFactor
        self.scrollView.contentSize = self.imageView.frame.size
        self.isPresented = true
    }
    
    //MARK:- Scroll View Delegate Methods
    public func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    public func scrollViewDidZoom(scrollView: UIScrollView) {
        self.centerScrollViewContents()
    }
    
    public func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
    }
    
    //MARK:- Helper Methods
    
    func setReferenceFrameForMode(mode: UIViewContentMode) -> CGRect{
        
        let widthRatio = self.referenceImageView.bounds.size.width / (self.referenceImageView.image != nil ? (self.referenceImageView.image?.size.width)! : self.referenceImageView.bounds.size.width)
        let heightRatio = self.referenceImageView.bounds.size.height / (self.referenceImageView.image != nil ? (self.referenceImageView.image?.size.height)! : self.referenceImageView.bounds.size.height)
        let referenceFrame : CGRect
        
        switch(mode) {
        case .ScaleAspectFit:
            let scale = min(widthRatio, heightRatio)
            self.imageWidth = scale * (self.referenceImageView.image != nil ? self.referenceImageView.image!.size.width : 0)
            self.imageHeight = scale * (self.referenceImageView.image != nil ? self.referenceImageView.image!.size.height : 0)
            let imageX = ((self.referenceFrame.size.width - self.imageWidth) / 2) + self.referenceFrame.origin.x
            let imageY = ((self.referenceFrame.size.height - self.imageHeight) / 2) + self.referenceFrame.origin.y
            referenceFrame = CGRectMake(imageX, imageY, self.imageWidth, self.imageHeight)
        case .ScaleAspectFill:
            let scale = max(widthRatio, heightRatio)
            self.imageWidth = scale * (self.referenceImageView.image != nil ? self.referenceImageView.image!.size.width : 0)
            self.imageHeight = scale * (self.referenceImageView.image != nil ? self.referenceImageView.image!.size.height : 0)
            let imageX = ((self.referenceFrame.size.width - self.imageWidth) / 2) + self.referenceFrame.origin.x
            let imageY = ((self.referenceFrame.size.height - self.imageHeight) / 2) + self.referenceFrame.origin.y
            referenceFrame = CGRectMake(imageX, imageY, self.imageWidth, self.imageHeight)
        case .ScaleToFill:
            self.imageWidth = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.width : 0
            self.imageHeight = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.height : 0
            referenceFrame = self.referenceImageView.frame
        case .Top:
            self.imageWidth = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.width : 0
            self.imageHeight = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.height : 0
            let imageX = ((self.referenceFrame.size.width - self.imageWidth) / 2) + self.referenceFrame.origin.x
            let imageY = self.referenceFrame.origin.y
            referenceFrame = CGRectMake(imageX, imageY, self.imageWidth, self.imageHeight)
        case .Bottom:
            self.imageWidth = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.width : 0
            self.imageHeight = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.height : 0
            let imageX = ((self.referenceFrame.size.width - self.imageWidth) / 2) + self.referenceFrame.origin.x
            let imageY = (self.referenceFrame.size.height + self.referenceFrame.origin.y) - self.imageHeight
            referenceFrame = CGRectMake(imageX, imageY, self.imageWidth, self.imageHeight)
        case .Left:
            self.imageWidth = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.width : 0
            self.imageHeight = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.height : 0
            let imageX = self.referenceFrame.origin.x
            let imageY = ((self.referenceFrame.size.height - self.imageHeight) / 2) + self.referenceFrame.origin.y
            referenceFrame = CGRectMake(imageX, imageY, self.imageWidth, self.imageHeight)
        case .Right:
            self.imageWidth = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.width : 0
            self.imageHeight = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.height : 0
            let imageX = (self.referenceFrame.origin.x + self.referenceFrame.size.width) - self.imageWidth
            let imageY = ((self.referenceFrame.size.height - self.imageHeight) / 2) + self.referenceFrame.origin.y
            referenceFrame = CGRectMake(imageX, imageY, self.imageWidth, self.imageHeight)
        case .Center:
            self.imageWidth = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.width : 0
            self.imageHeight = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.height : 0
            let imageX = self.referenceImageView.frame.origin.x + ((self.referenceImageView.frame.width - self.imageWidth) / 2)
            let imageY = self.referenceImageView.frame.origin.y + ((self.referenceImageView.frame.height - self.imageHeight) / 2)
            referenceFrame = CGRectMake(imageX, imageY, self.imageWidth, self.imageHeight)
        case .TopLeft:
            self.imageWidth = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.width : 0
            self.imageHeight = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.height : 0
            let imageX = self.referenceFrame.origin.x
            let imageY = self.referenceFrame.origin.y
            referenceFrame = CGRectMake(imageX, imageY, self.imageWidth, self.imageHeight)
        case .TopRight:
            self.imageWidth = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.width : 0
            self.imageHeight = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.height : 0
            let imageX = self.referenceFrame.origin.x + self.referenceFrame.size.width - self.imageWidth
            let imageY = self.referenceFrame.origin.y
            referenceFrame = CGRectMake(imageX, imageY, self.imageWidth, self.imageHeight)
        case .BottomLeft:
            self.imageWidth = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.width : 0
            self.imageHeight = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.height : 0
            let imageX = self.referenceFrame.origin.x
            let imageY = self.referenceFrame.origin.y + self.referenceFrame.size.height - self.imageHeight
            referenceFrame = CGRectMake(imageX, imageY, self.imageWidth, self.imageHeight)
        case .BottomRight:
            self.imageWidth = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.width : 0
            self.imageHeight = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.height : 0
            let imageX = self.referenceFrame.origin.x + self.referenceFrame.size.width - self.imageWidth
            let imageY = self.referenceFrame.origin.y + self.referenceFrame.size.height - self.imageHeight
            referenceFrame = CGRectMake(imageX, imageY, self.imageWidth, self.imageHeight)
        case .Redraw:
            self.imageWidth = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.width : 0
            self.imageHeight = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.height : 0
            referenceFrame = self.referenceImageView.frame
        }
        
        return referenceFrame
        
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
    
    func switchingToSize(size: CGSize,xRatio: CGFloat, yRatio: CGFloat) {
        
        self.backgroundView.frame = CGRectMake(0, 0, size.width, size.height)
        self.scrollView.frame = CGRectMake(0, 0, size.width, size.height)
        
        var heightImage: CGFloat
        var widthImage: CGFloat
        
        let imageAspect = self.imageWidth / self.imageHeight
        
        let deviceWidth = size.width
        let deviceHeight = size.height
        let deviceAspect = (deviceWidth/deviceHeight)
        
        var actualImageWidth: CGFloat = 0
        var actualImageHeight: CGFloat = 0
        
        if let image = self.referenceImageView.image {
            actualImageWidth = image.size.width
            actualImageHeight = image.size.height
        }
        
        
        if deviceAspect > 1 {
            if actualImageHeight > 0  && actualImageHeight >= deviceHeight {
                heightImage = deviceHeight
            }
            else {
                heightImage = actualImageWidth
            }
            
            widthImage = imageAspect * heightImage
        }
        else {
            if actualImageWidth > 0  && actualImageWidth >= deviceWidth {
                widthImage = deviceWidth
            }
            else {
                widthImage = actualImageWidth
            }
            heightImage = (widthImage / imageAspect)
        }
        
        let newWidth = widthImage * self.scrollView.zoomScale
        let newHeight = heightImage * self.scrollView.zoomScale
        
        UIView.animateWithDuration(FPLightBoxViewControllerConstants.mediumAnimationDuration, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
            
            ()-> Void in
            
            self.imageView.frame = CGRectMake(0, 0, newWidth, newHeight)
            self.imageView.center = self.view.center
            
            }, completion: nil)
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = self.scrollView.minimumZoomScale * self.finalZoomFactor
        self.scrollView.contentSize = self.imageView.frame.size
        
        
        
        //Calculating center point and scrollviews contentoffset to center the point on orirntation change
        if self.scrollView.zoomScale > self.scrollView.minimumZoomScale {
            if (self.prevHeight != newHeight || self.prevWidth != newWidth) {
                let pointCenter = CGPointMake(self.imageView.frame.size.width * xRatio, self.imageView.frame.size.height * yRatio)
                self.scrollView.contentOffset = CGPointMake(0,0)
                self.scrollView.contentSize = self.imageView.frame.size
                var pointX : CGFloat = 0
                var pointY : CGFloat = 0
                pointX = pointCenter.x - (size.width * 0.5)
                
                pointY = pointCenter.y - (size.height * 0.5)
                
                if pointX < 0 {
                    pointX = 0
                }
                if pointY < 0 {
                    pointY = 0
                }
                
                if pointY > abs(newHeight - (size.height)) {
                    pointY = abs(newHeight - (size.height))
                }
                
                if pointX > abs(newWidth - (size.width)) {
                    pointX = abs(newWidth - (size.width))
                }
                let newContentOffset = CGPointMake(pointX, pointY)
                UIView.animateWithDuration(FPLightBoxViewControllerConstants.fastAnimationDuration, animations: { () -> Void in
                    self.scrollView.contentOffset = newContentOffset
                })
                
            }
            
        }
        self.centerScrollViewContents()
    }
    
    //MARK:- Gesture Recognizer methods
    func handleFlick(recognizer:UIPanGestureRecognizer) {
        if isPresented && self.scrollView.zoomScale == self.scrollView.minimumZoomScale {
            
            if recognizer.state == UIGestureRecognizerState.Began {
                
            }
            else if recognizer.state == UIGestureRecognizerState.Changed {
                let translation = recognizer.translationInView(self.view)
                if let view = recognizer.view {
                    view.center = CGPoint(x:view.center.x + translation.x,
                        y:view.center.y + translation.y)
                }
                recognizer.setTranslation(CGPointZero, inView: self.view)
                
            }
            else if recognizer.state == UIGestureRecognizerState.Ended {
                
                
                let velocity = recognizer.velocityInView(self.view)
                let magnitude = sqrt((pow(velocity.x, 2.0) + pow(velocity.y, 2.0)))
                if magnitude > FPLightBoxViewControllerConstants.dismissalFlickVelocityMagnitude {
                    let push = UIPushBehavior(items: [self.imageView], mode: UIPushBehaviorMode.Instantaneous)
                    push.pushDirection = CGVectorMake(velocity.x * 0.3, velocity.y * 0.3);
                    self.animator.addBehavior(push)
                    push.action = {
                        if !CGRectIntersectsRect(self.view.frame, self.imageView.frame) {
                            UIView.animateWithDuration(FPLightBoxViewControllerConstants.mediumAnimationDuration , delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
                                self.backgroundView.alpha = 0
                                }, completion: {
                                    (completed) in
                                    NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: "dismiss", userInfo: nil, repeats: false)
                            })
                        }
                    }
                }
                else {
                    UIView.animateWithDuration(FPLightBoxViewControllerConstants.fastAnimationDuration , delay: 0.0, options: .CurveLinear, animations: {
                        () -> Void in
                        self.imageView.center = self.view.center
                        }, completion: nil)
                }
            }
            
        }
    }
    
    func dismiss() {
        self.dismissViewControllerAnimated(false, completion: {
            (completed) in
            print("Completed")
        })
    }
}