//
//  FPGallerySlideViewController.swift
//  FPKit
//
//  Created by Sruti Harikumar on 5/2/16.
//  Copyright © 2016 First Person. All rights reserved.


import Foundation
import UIKit

internal struct FPGallerySlideViewControllerConstants {
    static let defaultZoomFactor: CGFloat = 3.0
    static let dismissalFlickVelocityMagnitude: CGFloat = 1500
}


@objc protocol FPGallerySlideViewControllerDelegate {
    func didDismissViewController(slideController: FPGallerySlideViewController)
}

internal class FPGallerySlideViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {


//MARK:-Properties
    internal var pageIndex: Int!
    var delegate: FPGallerySlideViewControllerDelegate?
    
    private  var image: UIImage!
    private var maximumZoomFactor: Float!
    
    private var imageView: UIImageView!
    private var scrollView: UIScrollView!
    
    private var finalZoomFactor: CGFloat!
    private var finalViewAlpha: CGFloat!
    private var animator: UIDynamicAnimator!
    
    private var prevWidth: CGFloat!
    private var prevHeight: CGFloat!
    
    private var flickGestureRecognizer : UIGestureRecognizer!
    
    
//MARK:- Flags
    private var isPresented = false
    
//MARK:- View Controller Methods
    override internal func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
        self.animator = UIDynamicAnimator(referenceView: self.scrollView)
        
        //Hooking up the flick gesture and adding it to the Image View
        flickGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handleFlick:" )
        flickGestureRecognizer.delegate = self
        self.imageView.addGestureRecognizer(flickGestureRecognizer)

    }
    
    override internal func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override internal func prefersStatusBarHidden() -> Bool {
        return true;
    }
    
    override internal func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.AllButUpsideDown
    }


//MARK:- Initialization Methods
    internal func initWithImage(image: UIImage) {
        self.image = image
    }
    
//MARK:- User Interface Methods
    func setupUI() {
        
        self.scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        self.scrollView.delegate = self
        
        self.scrollView.directionalLockEnabled = true
        self.scrollView.scrollEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.backgroundColor = UIColor.clearColor()
        
        //Checking for passed zoomFactor
        if let factor = self.maximumZoomFactor{
            self.finalZoomFactor = CGFloat(factor)
        }
        else
        {
            self.finalZoomFactor = FPGallerySlideViewControllerConstants.defaultZoomFactor
        }
        
        
        self.scrollView.maximumZoomScale = self.finalZoomFactor
        self.view.addSubview(self.scrollView)
        
        
        if self.image != nil {
            let imageDimensions = self.getImageDisplayDimensions(self.image)
            let imageViewframe = CGRectMake(0, 0, imageDimensions.width, imageDimensions.height)
            self.imageView = UIImageView(frame: imageViewframe)
            self.imageView.center = self.view.center
            self.imageView.image = self.image
            self.imageView.contentMode = .ScaleToFill
            self.imageView.userInteractionEnabled = true
            self.imageView.layer.allowsEdgeAntialiasing = true
            self.scrollView.addSubview(self.imageView)
        }
        else {
            self.imageView = UIImageView()
            self.imageView.center = self.view.center
        }
        self.isPresented = true
    }
//MARK:- Orientation Change methods
    override internal func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
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

//MARK:- User Interaction Methods
    func handleFlick(recognizer:UIPanGestureRecognizer) {
        
        if isPresented && self.scrollView.zoomScale == self.scrollView.minimumZoomScale {
            
            switch recognizer.state {
            case .Changed:
                let translation = recognizer.translationInView(self.view)
                if let view = recognizer.view {
                    view.center = CGPoint(x:view.center.x + translation.x,
                        y:view.center.y + translation.y)
                }
                recognizer.setTranslation(CGPointZero, inView: self.view)
            case .Ended:
                let velocity = recognizer.velocityInView(self.view)
                let magnitude = sqrt((pow(velocity.x, 2.0) + pow(velocity.y, 2.0)))
                if magnitude > FPGallerySlideViewControllerConstants.dismissalFlickVelocityMagnitude {
                    let push = UIPushBehavior(items: [self.imageView], mode: UIPushBehaviorMode.Instantaneous)
                    push.pushDirection = CGVectorMake(velocity.x * 0.3, velocity.y * 0.3);
                    self.animator.addBehavior(push)
                    push.action = {
                        
                        if !CGRectIntersectsRect(self.view.frame, self.imageView.frame) {
                            
                            self.dismiss()
                        }
                    }
                }
                else {
                    UIView.animateWithDuration(FPLightBoxViewControllerConstants.fastAnimationDuration , delay: 0.0, options: .CurveLinear, animations: {
                        () -> Void in
                        self.imageView.center = self.view.center
                        }, completion: nil)
                }
            default:
                break
            }
        }
    }
    
    func dismiss() {
        self.animator.removeAllBehaviors()
        self.imageView.removeGestureRecognizer(self.flickGestureRecognizer)
        delegate?.didDismissViewController(self)
    }
    
//MARK:- Scroll View Delegate Methods
    internal func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    internal func scrollViewDidZoom(scrollView: UIScrollView) {
        self.centerScrollViewContents()
    }
    
    internal func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
    }

//MARK:- Gesture Recognizer delegate Methods
    internal func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if gestureRecognizer == self.flickGestureRecognizer {
            let panGestureRecognizer = gestureRecognizer as! UIPanGestureRecognizer
            let movement = panGestureRecognizer.translationInView(self.view)
            if abs(movement.x) > abs(movement.y) {
                return false
            }
        }
        return true
    }
//MARK:- Helper Methods
    func getImageDisplayDimensions(image: UIImage) -> CGSize {
        var widthImage: CGFloat
        var heightImage: CGFloat

        let deviceWidth = self.view.frame.size.width
        let deviceHeight = self.view.frame.size.height
        let deviceAspect = (deviceWidth/deviceHeight)
        
        
        var actualImageWidth: CGFloat = 0
        var actualImageHeight: CGFloat = 0
        
       
        actualImageWidth = image.size.width
        actualImageHeight = image.size.height
        let imageAspect = actualImageWidth / actualImageHeight
        
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
        
        return CGSizeMake(widthImage, heightImage)
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
        
        self.scrollView.frame = CGRectMake(0, 0, size.width, size.height)
        
        let imageDimensions = self.getImageDisplayDimensions(self.image)
        let widthImage = imageDimensions.width
        let heightImage = imageDimensions.height
        
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



    
}