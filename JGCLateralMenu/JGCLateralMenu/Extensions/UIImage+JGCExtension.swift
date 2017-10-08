//
//  UIImage+JGCExtension.swift
//  JGCLateralMenu
//
//  Created by Javier Garcia Castro on 24/9/17.
//  Copyright © 2017 Javier Garcia Castro. All rights reserved.
//


import UIKit

extension UIImage {
    
    class func imageFromMaskImage(mask: UIImage?, withColor: UIColor?) -> UIImage? {
        
        if mask == nil {
            return nil
        }
        
        if withColor == nil {
            return mask
        }
        
        let image: UIImage = mask!
        let rect: CGRect = CGRect.init(x: 0, y: 0, width: image.size.width, height: image.size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, image.scale)
        
        let c: CGContext = UIGraphicsGetCurrentContext()!
        image.draw(in: rect)
        c.setFillColor((withColor?.cgColor)!)
        c.setBlendMode(.sourceAtop)
        c.fill(rect)
        
        let result: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return result
    }
    
    class func imageWithColor(color: UIColor) -> UIImage {
        
        let rect: CGRect = CGRect.init(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func imageWithSize(size: CGSize) -> UIImage {
        
        let widthRatio: CGFloat = size.width / self.size.width
        let heightRatio: CGFloat = size.height / self.size.height
        
        var newSize: CGSize?
        
        if widthRatio < heightRatio {
            newSize = CGSize.init(width: self.size.width*heightRatio, height: self.size.height*heightRatio)
        }
        else {
            newSize = CGSize.init(width: self.size.width*widthRatio, height: self.size.height*widthRatio)
        }
        
        UIGraphicsBeginImageContextWithOptions(newSize!, false, 0.0)
        self.draw(in: CGRect.init(x: 0, y: 0, width: (newSize?.width)!, height: (newSize?.height)!))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func trim(trimRect :CGRect) -> UIImage {
        if CGRect(origin: CGPoint.zero, size: self.size).contains(trimRect) {
            if let imageRef = self.cgImage?.cropping(to: trimRect) {
                return UIImage(cgImage: imageRef)
            }
        }
        
        UIGraphicsBeginImageContextWithOptions(trimRect.size, true, self.scale)
        self.draw(in: CGRect(x: -trimRect.minX, y: -trimRect.minY, width: self.size.width, height: self.size.height))
        let trimmedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let image = trimmedImage else { return self }
        
        return image
    }
}


