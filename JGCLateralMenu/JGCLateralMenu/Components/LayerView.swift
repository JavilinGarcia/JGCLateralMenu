//
//  LayerView.swift
//  JGCLateralMenu
//
//  Created by Javier Garcia Castro on 24/9/17.
//  Copyright © 2017 Javier Garcia Castro. All rights reserved.
//

import UIKit
import Foundation

@objc enum LayerViewType : Int {
    case LayerViewTypeTopLayer
    case LayerViewTypeLeftLayer
    case LayerViewTypeRightLayer
    case LayerViewTypeBottomLayer
}

@IBDesignable
class LayerView: UIView {
    
    // MARK: - Init
    
    convenience init() {
        self.init()
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    // MARK: - Properties
    
    private var defaultLayerColor: UIColor = UIColor.darkGray
    @IBInspectable var layerColor: UIColor {
        get {
            return defaultLayerColor
        }
        set {
            defaultLayerColor = newValue
            configureLayers()
        }
    }
    
    private var defaultTopLayer: Bool = false
    @IBInspectable var topLayer: Bool {
        get {
            return defaultTopLayer
        }
        set {
            defaultTopLayer = newValue
            configureTopLayer()
        }
    }
    
    private var defaultBottomLayer: Bool = false
    @IBInspectable var bottomLayer: Bool {
        get {
            return defaultBottomLayer
        }
        set {
            defaultBottomLayer = newValue
            configureBottomLayer()
        }
    }
    
    private var defaultLeftLayer: Bool = false
    @IBInspectable var leftLayer: Bool {
        get {
            return defaultLeftLayer
        }
        set {
            defaultLeftLayer = newValue
            configureLeftLayer()
        }
    }
    
    private var defaultRightLayer: Bool = false
    @IBInspectable var rightLayer: Bool {
        get {
            return defaultRightLayer
        }
        set {
            defaultRightLayer = newValue
            configureRightLayer()
        }
    }
    
    private var defaultSizeLayers: CGFloat = 0.0
    @IBInspectable var sizeLayers: CGFloat {
        get {
            return defaultSizeLayers
        }
        set {
            defaultSizeLayers = newValue
            configureLayers()
        }
    }
    
    // MARK: - Private Methods
    
    func initialize() {
        configureLayers()
    }
    
    func configureLayers() {
        configureTopLayer()
        configureLeftLayer()
        configureRightLayer()
        configureBottomLayer()
    }
    
    func configureTopLayer() {
        if topLayer {
            configureConstraints(type:LayerViewType.LayerViewTypeTopLayer)
        }
    }
    
    func configureLeftLayer() {
        if leftLayer {
            configureConstraints(type:LayerViewType.LayerViewTypeLeftLayer)
        }
    }
    
    func configureRightLayer() {
        if rightLayer {
            configureConstraints(type:LayerViewType.LayerViewTypeRightLayer)
        }
    }
    
    func configureBottomLayer() {
        if bottomLayer {
            configureConstraints(type:LayerViewType.LayerViewTypeBottomLayer)
        }
        else {
            for view:UIView in self.subviews {
                if view.tag == LayerViewType.LayerViewTypeBottomLayer.rawValue {
                    view.removeFromSuperview()
                }
            }
        }
    }
    
    func configureConstraints(type: LayerViewType) {
        
        let view:UIView = UIView()
        view.backgroundColor = self.layerColor
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.tag = type.rawValue
        
        self.addSubview(view)
        
        let constraints:NSMutableArray = NSMutableArray()

        var size:Float
        if self.sizeLayers > 0.0 {
            size = Float(self.sizeLayers)
        }
        else {
            size = 0.5
        }
        
        switch type {
            case .LayerViewTypeTopLayer:
                constraints.addObjects(from: NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: ["view":view]))
                constraints.addObjects(from: NSLayoutConstraint.constraints(withVisualFormat: "V:|[view(size)]", options: [], metrics: ["size":size], views: ["view":view]))
                break
            case .LayerViewTypeLeftLayer:
                constraints.addObjects(from: NSLayoutConstraint.constraints(withVisualFormat: "H:|[view(size)]", options: [], metrics: ["size":size], views: ["view":view]))
                constraints.addObjects(from: NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: [], metrics: nil, views: ["view":view]))
                break
            case .LayerViewTypeRightLayer:
                constraints.addObjects(from: NSLayoutConstraint.constraints(withVisualFormat: "H:[view(size)]|", options: [], metrics: ["size":size], views: ["view":view]))
                constraints.addObjects(from: NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: [], metrics: nil, views: ["view":view]))
                break
            case .LayerViewTypeBottomLayer:
                constraints.addObjects(from: NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: ["view":view]))
                constraints.addObjects(from: NSLayoutConstraint.constraints(withVisualFormat: "V:[view(size)]|", options: [], metrics: ["size":size], views: ["view":view]))
                break
        }
        
        view.superview?.addConstraints(constraints as Array as! [NSLayoutConstraint])
    }
}
