//
//  FPGallerySlideViewController.swift
//  FPKit
//
//  Created by Sruti Harikumar on 5/2/16.
//  Copyright © 2016 First Person. All rights reserved.
//

import Foundation
import UIKit

class FPGallerySlideViewController: UIViewController, UIScrollViewDelegate {


//MARK:-Properties
    private var image: UIImage!
    private var backgroundViewColor: UIColor!
    private var backgroundViewAlpha: Float!
    private var maximumZoomFactor: Float!
    
    private var imageView: UIImageView!
    private var backgroundView: UIView!
    private var scrollView: UIScrollView!
    
    private var finalZoomFactor: CGFloat!
    private var finalViewAlpha: CGFloat!
    private var animator: UIDynamicAnimator!
    
//MARK:- View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

//MARK:- InitializationMethods
    func initWithImage(image: UIImage,andBackgroundViewColor backgroundViewColor: UIColor?, andBackgroundViewAlpha backgroundViewAlpha: Float?) {
        self.image = image
        self.backgroundViewColor = backgroundViewColor
        self.backgroundViewAlpha = backgroundViewAlpha
    }
    
//MARK:- User Interface Methods
    func setupUI() {
        self.backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        self.backgroundView.backgroundColor = UIColor.blackColor()
        
        
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
        
        self.backgroundView.alpha = self.finalViewAlpha
        self.view.addSubview(self.backgroundView)
        
        //Checking for passed zoomFactor
        if let factor = self.maximumZoomFactor{
            self.finalZoomFactor = CGFloat(factor)
        }
        else
        {
            self.finalZoomFactor = 5.0
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


    
}