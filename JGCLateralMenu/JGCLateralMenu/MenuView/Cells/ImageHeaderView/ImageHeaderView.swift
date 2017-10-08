//
//  ImageHeaderView.swift
//  JGCLateralMenu
//
//  Created by Javier Garcia Castro on 24/9/17.
//  Copyright © 2017 Javier Garcia Castro. All rights reserved.
//

import UIKit
import Foundation

@objc protocol ImageHeaderViewProtocol {
    @objc optional func userDidTapCameraButton()
}

class ImageHeaderView: UIView {
    
    @IBOutlet weak var profileImage : UIImageView!
    @IBOutlet weak var backgroundImage : UIImageView!
    @IBOutlet weak var cameraContainerView: UIView!
    @IBOutlet weak var cameraButton : UIButton!
    @IBOutlet weak var cameraImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userMailLabel: UILabel!
    
    var delegate: ImageHeaderViewProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.layoutIfNeeded()
        profileImage.layer.cornerRadius = profileImage.bounds.size.height / 2 
        profileImage.clipsToBounds = true
        profileImage.layer.borderWidth = 1
        profileImage.layer.borderColor = UIColor.white.cgColor
        
        
//        profileImage.setRandomDownloadImage(80, height: 80)
//        backgroundImage.setRandomDownloadImage(Int(bounds.size.width), height: 160)
        
        profileImage.backgroundColor = UIColor.green
        let image: UIImage = UIImage.init(named: "user_img")!
        profileImage.image = image// UIImage.imageFromMaskImage(mask: image, withColor: UIColor.init(hex: kconsultasGreen, alpha: 1.0))
        
        backgroundColor = UIColor.green
        
        userNameLabel.font = UIFont.init(name: userNameLabel.font.fontName, size: 16.0)
        userMailLabel.font = UIFont.init(name: userMailLabel.font.fontName, size: 13.0)
        
        cameraContainerView.cornerRadius = cameraContainerView.height / 2
        
        cameraImageView.image = UIImage.imageFromMaskImage(mask: cameraImageView.image, withColor: UIColor.green)
    }
    
    @IBAction func userDidTapCameraButton(_ sender: Any) {
        delegate?.userDidTapCameraButton?()
    }
}

