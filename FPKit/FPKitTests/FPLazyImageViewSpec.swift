//
//  FPLazyImageViewSpec.swift
//  FPKit
//
//  Created by Fernando Toledo on 1/21/16.
//  Copyright © 2016 First Person. All rights reserved.
//

import Foundation
import Quick
import Nimble
import FPKit

class FPLazyImageViewSpec: QuickSpec {
    
    override func spec() {
        
        describe("a lazy image view", closure: {
            
            let validImageURL = NSURL(string: "http://assets.firstperson.is/img/global/1P_logo_redorange_meta.png")
            let invalidImageURL = NSURL(string: "http://firstperson.is/")
            let invalidServerURL = NSURL(string: "http://nonexistentimagedomain.com")
            var lazyImage: FPLazyImageView!
            
            context("when loading from a valid image URL", closure: {
                
                beforeEach({
                    lazyImage = FPLazyImageView(imageURL: validImageURL!, placeholderImage: nil)
                    lazyImage.startDownload()
                })
                
                it("has no image", closure: {
                    expect(lazyImage.image).to(beNil())
                })
                
                it("starts downloading an image", closure: {
                    expect(lazyImage.downloading).to(beTrue())
                })
                
                it("finishes downloading the image", closure: {
                    expect(lazyImage.downloaded).toEventually(beTrue())
                })
                
                it("sets the downloaded image as the UIImage source", closure: {
                    expect(lazyImage.image).toEventuallyNot(beNil())
                })
                
            })
            
            context("when loading from an invalid image URL", closure: {
                
                beforeEach({
                    lazyImage = FPLazyImageView(imageURL: invalidImageURL!, placeholderImage: nil)
                    lazyImage.startDownload()
                })
                
                it("has no image", closure: {
                    expect(lazyImage.image).to(beNil())
                })
                
                it("starts downloading an image", closure: {
                    expect(lazyImage.downloading).to(beTrue())
                })
                
                it("never downloads an image", closure: {
                    waitUntil(timeout: 5, action: { done in
                        lazyImage.completionHandler = { imageView, result in
                            expect(result.isFailure).to(beTrue())
                            expect(lazyImage.downloading).to(beFalse())
                            expect(lazyImage.downloaded).to(beFalse())
                            expect(lazyImage.image).to(beNil())
                            done()
                        }
                    })
                })
                
            })
            
            context("when loading from an invalid server URL", closure: {
                
                beforeEach({
                    lazyImage = FPLazyImageView(imageURL: invalidServerURL!, placeholderImage: nil)
                    lazyImage.startDownload()
                })
                
                it("has no image", closure: {
                    expect(lazyImage.image).to(beNil())
                })
                
                it("starts downloading an image", closure: {
                    expect(lazyImage.downloading).to(beTrue())
                })
                
                it("never downloads an image", closure: {
                    waitUntil(timeout: 5, action: { done in
                        lazyImage.completionHandler = { imageView, result in
                            expect(result.isFailure).to(beTrue())
                            expect(lazyImage.downloading).to(beFalse())
                            expect(lazyImage.downloaded).to(beFalse())
                            expect(lazyImage.image).to(beNil())
                            done()
                        }
                    })
                })
                
            })
            
        })
    }
    
}