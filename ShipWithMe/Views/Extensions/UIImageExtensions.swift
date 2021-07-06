//
//  UIImageExtensions.swift
//  ShipWithMe
//
//  Created by Ludvig Westerdahl on 2021-05-10.
//

import Foundation
import UIKit

extension UIImage {
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func ensureUpOrientation() -> UIImage {
        switch imageOrientation {
        case .up:
            return self
        case .down:
            return imageRotatedByDegrees(degrees: 180, flip: false)
        case .left:
            return imageRotatedByDegrees(degrees: 90, flip: false)
        case .right:
            return imageRotatedByDegrees(degrees: -90, flip: false)
        case .upMirrored:
            return imageRotatedByDegrees(degrees: 0, flip: true)
        case .downMirrored:
            return imageRotatedByDegrees(degrees: 180, flip: true)
        case .leftMirrored:
            return imageRotatedByDegrees(degrees: 90, flip: true)
        case .rightMirrored:
            return imageRotatedByDegrees(degrees: -90, flip: true)
        default:
            return self
        }
    }
    
    func imageRotatedByDegrees(degrees: CGFloat, flip: Bool) -> UIImage {
        let degreesToRadians: (CGFloat) -> CGFloat = {
            return $0 / 180.0 * .pi
        }
        
        // calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox = CGRect(origin: CGPoint.zero, size: size)
            .applying(CGAffineTransform(rotationAngle: degreesToRadians(degrees)))

        let rotatedSize = rotatedViewBox.size
        
        // Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap = UIGraphicsGetCurrentContext()
        
        // Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap!.translateBy(x: rotatedSize.width / 2.0, y: rotatedSize.height / 2.0);
        
        //   // Rotate the image context
        bitmap!.rotate(by: degreesToRadians(degrees));
        
        // Now, draw the rotated/scaled image into the context
        var yFlip: CGFloat
        
        if(flip){
            yFlip = CGFloat(-1.0)
        } else {
            yFlip = CGFloat(1.0)
        }
        
        bitmap!.scaleBy(x: yFlip, y: -1.0)
        
        bitmap!.draw(cgImage!, in: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
