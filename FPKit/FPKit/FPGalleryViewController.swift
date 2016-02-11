//
//  FPGalleryViewController.swift
//  FPKit
//
//  Created by Sruti Harikumar on 5/2/16.
//  Copyright © 2016 First Person. All rights reserved.
//

import Foundation
import UIKit

public struct FPGalleryViewControllerConstants {
    static let mediumAnimationDuration = 0.4
    static let fastAnimationDuration = 0.2
    static let defaultBackgroundAlpha : Float = 0.9
}

public class FPGalleryViewController: UIViewController, FPGallerySlideViewControllerDelegate, UIPageViewControllerDataSource {
  
//MARK:- Properties
    public var backgroundViewColor: UIColor!
    public var backgroundViewAlpha: Float!
    
    private var images: [UIImage]!
    private var backgroundView: UIView!
    private var pageViewController: UIPageViewController!
    private var referenceImageView: UIImageView!
    private var startIndex: Int!
    private var imageView: UIImageView!
    private var referenceFrame: CGRect!
    
    
//MARK:- View Controller Methods
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.placeOverlayImage()
    }
    
    override public func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.snapImageIntoPlace()
        
    }
//MARK:- Initializer Methods
    public func initWithImages(images: [UIImage], andReferenceImageView referenceImageView: UIImageView, andIndex index: Int) {
        self.images = images
        self.referenceImageView = referenceImageView
        if index > (self.images.count - 1) {
            self.startIndex = self.images.count - 1
        }
        else if index < 0 {
            self.startIndex = 0
        }
        else {
            self.startIndex = index
        }
    }
    
//MARK:- User Interface Methods
    func setupUI() {
        self.imageView = UIImageView()
        
        self.pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        self.pageViewController.dataSource = self

        if self.backgroundViewColor == nil {
            self.backgroundViewColor = UIColor.blackColor()
        }
        if self.backgroundViewAlpha == nil {
            self.backgroundViewAlpha = FPGalleryViewControllerConstants.defaultBackgroundAlpha
        }
        
        self.backgroundView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        self.backgroundView.backgroundColor = self.backgroundViewColor
        self.backgroundView.alpha = CGFloat(self.backgroundViewAlpha)
        self.view.addSubview(self.backgroundView)
    }
    
    func placeOverlayImage() {
        
        if self.referenceImageView != nil {
            //Initializing ReferenceFrame
            self.referenceFrame = self.referenceImageView.frame
            //self.referenceFrame = self.referenceImageView.convertRect(self.referenceImageView.frame, toView: nil)
            //Setting Reference frame
            self.referenceFrame = self.setReferenceFrameForMode(self.referenceImageView.contentMode)
                
            //Using the reference frame to set Up ImageView
            self.imageView = UIImageView(frame: self.referenceFrame)
            self.imageView.image = self.images[self.startIndex]
            self.imageView.contentMode = self.referenceImageView.contentMode
            self.imageView.clipsToBounds = false
            self.imageView.userInteractionEnabled = true
            self.imageView.layer.allowsEdgeAntialiasing = true
        }
        else {
            self.imageView = UIImageView(image: self.images[self.startIndex])
            self.imageView.center = self.view.center
        }
        self.view.addSubview(self.imageView)
    }
    
    func snapImageIntoPlace() {
        let imageDimensions = self.getImageDisplayDimensions(self.images[self.startIndex])
        
        self.imageView.contentMode = .ScaleToFill
        
        UIView.animateWithDuration(FPGalleryViewControllerConstants.mediumAnimationDuration, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
            ()-> Void in
            
            self.imageView.frame = CGRectMake(0,0,imageDimensions.width,imageDimensions.height)
            self.imageView.center = self.view.center
            }, completion: {
                completed in
                
                self.imageView.removeFromSuperview()
                self.addPageViewController()
        })
        
    }
    
    func addPageViewController() {
        
        let startingSlideViewController : FPGallerySlideViewController = self.viewControllerAtIndex(self.startIndex)!
        let viewControllersArray = [startingSlideViewController]
        self.pageViewController.setViewControllers(viewControllersArray, direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        self.pageViewController.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        
        //Removing image view as it wont be used anymore
        self.imageView.removeFromSuperview()
    }
    
//MARK:- PageViewController Data Source Methods
    
    public func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let gallerySlideController = viewController as! FPGallerySlideViewController
        var index = Int(gallerySlideController.pageIndex)
        if index == 0 || index == NSNotFound {
            return nil
        }
        index--
        return self.viewControllerAtIndex(index)
    }
    
    
    public func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let gallerySlideController = viewController as! FPGallerySlideViewController
        /*let imageInViewController = gallerySlideController.image
        let index = self.images.indexOf(imageInViewController)*/
        var index = Int(gallerySlideController.pageIndex)
        if index == (self.images.count - 1) || index == NSNotFound {
            return nil
        }
        index++
        return self.viewControllerAtIndex(index)

    }
    
    internal func viewControllerAtIndex(index: Int) -> FPGallerySlideViewController?{
        if (self.images.count == 0 ) || (index >= self.images.count) {
            return nil
        }
        let gallerySlideViewController = FPGallerySlideViewController()
        gallerySlideViewController.initWithImage(self.images[index])
        gallerySlideViewController.pageIndex = index
        gallerySlideViewController.delegate = self
        return gallerySlideViewController
    }
    
//MARK:- Helper Methods

func setReferenceFrameForMode(mode: UIViewContentMode) -> CGRect{
    
    let widthRatio = self.referenceImageView.bounds.size.width / (self.referenceImageView.image != nil ? (self.referenceImageView.image?.size.width)! : self.referenceImageView.bounds.size.width)
    let heightRatio = self.referenceImageView.bounds.size.height / (self.referenceImageView.image != nil ? (self.referenceImageView.image?.size.height)! : self.referenceImageView.bounds.size.height)
    let referenceFrame : CGRect
    
    switch(mode) {
    case .ScaleAspectFit:
        let scale = min(widthRatio, heightRatio)
        let imageWidth = scale * (self.referenceImageView.image != nil ? self.referenceImageView.image!.size.width : 0)
        let imageHeight = scale * (self.referenceImageView.image != nil ? self.referenceImageView.image!.size.height : 0)
        let imageX = ((self.referenceFrame.size.width -  imageWidth) / 2) + self.referenceFrame.origin.x
        let imageY = ((self.referenceFrame.size.height - imageHeight) / 2) + self.referenceFrame.origin.y
        referenceFrame = CGRectMake(imageX, imageY, imageWidth, imageHeight)
    case .ScaleAspectFill:
        let scale = max(widthRatio, heightRatio)
        let imageWidth = scale * (self.referenceImageView.image != nil ? self.referenceImageView.image!.size.width : 0)
        let imageHeight = scale * (self.referenceImageView.image != nil ? self.referenceImageView.image!.size.height : 0)
        let imageX = ((self.referenceFrame.size.width -  imageWidth) / 2) + self.referenceFrame.origin.x
        let imageY = ((self.referenceFrame.size.height - imageHeight) / 2) + self.referenceFrame.origin.y
        referenceFrame = CGRectMake(imageX, imageY, imageWidth, imageHeight)
    case .ScaleToFill:
        referenceFrame = self.referenceImageView.frame
    case .Top:
        let imageWidth = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.width : 0
        let imageHeight = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.height : 0
        let imageX = ((self.referenceFrame.size.width - imageWidth) / 2) + self.referenceFrame.origin.x
        let imageY = self.referenceFrame.origin.y
        referenceFrame = CGRectMake(imageX, imageY, imageWidth, imageHeight)
    case .Bottom:
        let imageWidth = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.width : 0
        let imageHeight = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.height : 0
        let imageX = ((self.referenceFrame.size.width -  imageWidth) / 2) + self.referenceFrame.origin.x
        let imageY = (self.referenceFrame.size.height + self.referenceFrame.origin.y) - imageHeight
        referenceFrame = CGRectMake(imageX, imageY, imageWidth, imageHeight)
    case .Left:
        let imageWidth = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.width : 0
        let imageHeight = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.height : 0
        let imageX = self.referenceFrame.origin.x
        let imageY = ((self.referenceFrame.size.height - imageHeight) / 2) + self.referenceFrame.origin.y
        referenceFrame = CGRectMake(imageX, imageY, imageWidth, imageHeight)
    case .Right:
        let imageWidth = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.width : 0
        let imageHeight = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.height : 0
        let imageX = (self.referenceFrame.origin.x + self.referenceFrame.size.width) - imageWidth
        let imageY = ((self.referenceFrame.size.height - imageHeight) / 2) + self.referenceFrame.origin.y
        referenceFrame = CGRectMake(imageX, imageY, imageWidth, imageHeight)
    case .Center:
        let imageWidth = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.width : 0
        let imageHeight = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.height : 0
        let imageX = self.referenceImageView.frame.origin.x + ((self.referenceImageView.frame.width - imageWidth) / 2)
        let imageY = self.referenceImageView.frame.origin.y + ((self.referenceImageView.frame.height - imageHeight) / 2)
        referenceFrame = CGRectMake(imageX, imageY, imageWidth, imageHeight)
    case .TopLeft:
        let imageWidth = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.width : 0
        let imageHeight = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.height : 0
        let imageX = self.referenceFrame.origin.x
        let imageY = self.referenceFrame.origin.y
        referenceFrame = CGRectMake(imageX, imageY, imageWidth, imageHeight)
    case .TopRight:
        let imageWidth = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.width : 0
        let imageHeight = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.height : 0
        let imageX = self.referenceFrame.origin.x + self.referenceFrame.size.width - imageWidth
        let imageY = self.referenceFrame.origin.y
        referenceFrame = CGRectMake(imageX, imageY, imageWidth, imageHeight)
    case .BottomLeft:
        let imageWidth = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.width : 0
        let imageHeight = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.height : 0
        let imageX = self.referenceFrame.origin.x
        let imageY = self.referenceFrame.origin.y + self.referenceFrame.size.height - imageHeight
        referenceFrame = CGRectMake(imageX, imageY, imageWidth, imageHeight)
    case .BottomRight:
        let imageWidth = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.width : 0
        let imageHeight = self.referenceImageView.image != nil ? self.referenceImageView.image!.size.height : 0
        let imageX = self.referenceFrame.origin.x + self.referenceFrame.size.width - imageWidth
        let imageY = self.referenceFrame.origin.y + self.referenceFrame.size.height - imageHeight
        referenceFrame = CGRectMake(imageX, imageY, imageWidth, imageHeight)
    case .Redraw:
        referenceFrame = self.referenceImageView.frame
    }
    
    return referenceFrame
    
}

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
    
    
//MARK:- FPGallerySlideViewControllerDelegate Methods
    func didDismissViewController(slideController: FPGallerySlideViewController) {
        
        UIView.animateWithDuration(FPGalleryViewControllerConstants.mediumAnimationDuration, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
            
            self.backgroundView.alpha = 0
            
            
            }, completion: {
                completed in
                NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: "dismiss", userInfo: nil, repeats: false)
                
        })
        
    }
    func dismiss() {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
//MARK:- Responding to Orientation change
    override public func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        //Before rotation
        
        coordinator.animateAlongsideTransition({
            (context: UIViewControllerTransitionCoordinatorContext ) -> Void in
            
            //During rotation
            UIView.animateWithDuration(FPGalleryViewControllerConstants.mediumAnimationDuration, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
                
                    self.backgroundView.frame = CGRectMake(0, 0, size.width, size.height)
                
                }, completion: nil)
            
            })
            {
                (context: UIViewControllerTransitionCoordinatorContext) -> Void in
                
                //After rotation
        }
    }


}