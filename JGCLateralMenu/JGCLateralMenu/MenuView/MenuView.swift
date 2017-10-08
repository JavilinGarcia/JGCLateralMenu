//
//  MenuView.swift
//  JGCLateralMenu
//
//  Created by Javier Garcia Castro on 24/9/17.
//  Copyright © 2017 Javier Garcia Castro. All rights reserved.
//

import UIKit
import Foundation

@objc protocol MenuViewDelegate {
    
    @objc optional func heightForRowAtIndexPath(menuSection: MenuView, indexPath: IndexPath) -> CGFloat
    @objc optional func heightForHeaderInSection(menuSection: MenuView, section: Int) -> CGFloat
    @objc optional func didSelectRowAtIndexPath(menuSection: MenuView, indexPath: IndexPath)
    @objc optional func didSelectSection(menuSection: MenuView, section: Int)
    
    @objc optional func showSection() -> Int
    @objc optional func sectionActive(menuSection: MenuView, section: Int) -> Bool
    @objc optional func subsectionActive(menuSection: MenuView, indexPath: IndexPath) -> Bool
}

@objc protocol MenuViewDataSource {
    
    @objc optional func viewForHeaderInSection(menuSection: MenuView, section: Int) -> UIView
    @objc optional func numberOfRowsInSection(menuSection: MenuView, section: Int) -> Int
    @objc optional func viewForRowAtIndexPath(menuSection: MenuView, indexPath: IndexPath) -> UIView
    
    @objc optional func numberOfSectionsInMenuSection() -> Int
}


class MenuView: UIView {

    let dataSource:MenuViewDataSource?
    let delegate: MenuViewDelegate?
    
    var scrollView:MenuScrollView?
    var subsectionsContainers:NSMutableArray = NSMutableArray()
    
    var dVerticalConstraints:NSMutableDictionary?
    var dVerticalViews:NSMutableDictionary?
    
    // MARK: - Init
    
    init() {
        self.delegate = nil
        self.dataSource = nil
        super.init(frame: CGRect.zero)
    }
    
    init(delegate: MenuViewDelegate, dataSource: MenuViewDataSource) {
        
        self.delegate = delegate
        self.dataSource = dataSource
        
        super.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        self.delegate = nil
        self.dataSource = nil
        
        super.init(frame: frame)
        self.initialize()
    }
    
    required init(coder aDecoder: NSCoder) {
        self.delegate = nil
        self.dataSource = nil
        super.init(coder: aDecoder)!
        self.initialize()
    }
    
    override func didMoveToSuperview() {
        self.initialize()
    }
    
    // MARK: - Public Methods
    
    func showSection(section: Int, init: Bool, completion: ((Bool) -> Swift.Void)? = nil) {
        
        var auxView:UIView?

        self.updateSubsectionConstraints(section: section)

        for subsectionContainerView:UIView in self.subsectionsContainers as NSArray as! [UIView] {

            if subsectionContainerView.tag == section {
                auxView = subsectionContainerView
            }
        }

        let sections:Int = (self.dataSource?.numberOfSectionsInMenuSection!())!
        
        for i in 0 ..< sections {

            let key = "subsectionContainerView\(i)"

            if i != section { //Collapse all open sections

                let constraints:[NSLayoutConstraint]? = self.dVerticalConstraints?.object(forKey: key) as! [NSLayoutConstraint]?

                if (constraints != nil) {

                    for constraint in constraints! {

                        constraint.isActive = false
                    }
                }
            }
            else { // Open/Close section

                let constraints:[NSLayoutConstraint]? = self.dVerticalConstraints?.object(forKey: key) as! [NSLayoutConstraint]?

                if (constraints != nil) {

                    for constraint in constraints! {

                        constraint.isActive = !constraint.isActive
                    }
                }
            }
        }

        if auxView == nil {
            if((completion) != nil) {
                completion!(true)
            }
            return
        }
        
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            
            self.layoutIfNeeded()
            }, completion: {(finished: Bool) -> Void in
                
                auxView?.frame = CGRect.init(x: (auxView?.frame.origin.x)!, y: (auxView?.frame.origin.y)!, width: (auxView?.frame.size.width)!, height: (auxView?.frame.size.height)! + 54.0)
                
                self.scrollView!.scrollRectToVisible((auxView?.frame)!, animated: true)

                self.isUserInteractionEnabled = true

                if((completion) != nil) {
                    completion!(true)
                }
            })
    }
    
    // MARK: - Actions
    
    @objc func userDidTapHeaderButton(sender:UIButton) {
        
        self.isUserInteractionEnabled = false

        let section:Int = sender.tag

        var auxView:UIView? = nil

        for subsectionContainerView:UIView in self.subsectionsContainers as NSArray as! [UIView] {

            if subsectionContainerView.tag == section {
                auxView = subsectionContainerView
            }
        }

        self.delegate?.didSelectSection!(menuSection: self, section: section)

        if auxView == nil {
            self.isUserInteractionEnabled = true
            return
        }

        self.showSection(section: section, init: true, completion: { (finished) in
            //..
        })
    }
    
    @objc func userDidTapCellButton(sender: UIButton) {
        
        let superView:UIView? = sender.superview!
        
        let indexPath: IndexPath = IndexPath.init(row: superView!.tag, section: sender.tag)
        
        self.delegate?.didSelectRowAtIndexPath!(menuSection: self, indexPath: indexPath)
//        self.delegate?.didSelectRowAtIndexPath(self, indexPath: NSIndexPath.init(forRow: superView!.tag, inSection: sender.tag))
    }
    
     func updateSubsectionConstraints(section: Int) {
        
        let key:String = "subsectionContainerView\(section)"

        let constraints:[NSLayoutConstraint] = self.dVerticalConstraints?[key] as! [NSLayoutConstraint]

        for i in 0 ..< constraints.count {

            let constraint: NSLayoutConstraint = constraints[i]

            if constraint.firstAttribute == NSLayoutAttribute.height {

                let indexPath: IndexPath = IndexPath.init(row: i, section: section)

                constraint.constant = self.delegate!.heightForRowAtIndexPath!(menuSection: self, indexPath: indexPath)
                
//                constraint.constant = self.delegate!.heightForRowAtIndexPath(self, indexPath: NSIndexPath.init(forRow: i, inSection: section))
            }
        }
    }
    
    // MARK: - Private Methods
    
     func initialize() {
        
        self.subsectionsContainers = NSMutableArray()
        self.dVerticalConstraints = NSMutableDictionary()
        self.dVerticalViews = NSMutableDictionary()
        
        if self.scrollView != nil {
            self.scrollView!.removeFromSuperview()
            self.scrollView = nil
        }
        
        if self.scrollView == nil {
            
            self.scrollView = MenuScrollView()
            self.scrollView!.isHidden = false
            self.scrollView!.isScrollEnabled = true
            self.scrollView!.showsVerticalScrollIndicator = false
            scrollView!.backgroundColor = .white
            
            addSubview(self.scrollView!)
            
            UIView.embedView(view: self.scrollView!)
            
        }
        else {
            for view:UIView in self.scrollView!.subviews {
                view.removeFromSuperview()
            }
        }
        
        self.addSectionConstraints()
        
        if ((self.delegate?.showSection!()) != nil) {
            
            let section:Int = (self.delegate?.showSection!())!
            
            if section != -1 {
                self.showSection(section: section, init: true, completion: { (finished) in
                    //..
                })
            }
        }
        self.scrollView?.isHidden = false
    }
    
     func reloadData() {
        self.initialize()
    }
    
     func addButton(view: UIView, index:Int, header:Bool) {
        
        if self.delegate!.sectionActive != nil {
            
            let active:Bool = self.delegate!.sectionActive!(menuSection: self, section: index)
            
            if header == false &&  active == false {
                return
            }
        }
        
        if self.delegate!.subsectionActive != nil {
            
            let active:Bool = self.delegate!.subsectionActive!(menuSection: self, indexPath: IndexPath.init(row: view.tag, section: index))
            
            if header == false &&  active == false {
                return
            }
        }
        
        let button:UIButton = UIButton()
        button.tag = index
        
        view.addSubview(button)
        
        UIView.embedView(view: button)
        
        if header == true {
            button.addTarget(self, action: #selector(userDidTapHeaderButton), for: UIControlEvents.touchUpInside)
        }
        else {
            button.addTarget(self, action: #selector(userDidTapCellButton), for: UIControlEvents.touchUpInside)
        }
    }
    
     func addSectionConstraints() {
        
        let views:NSMutableDictionary = NSMutableDictionary()
        var heightVisualFormat:String = "V:|"
        var metrics:Dictionary<String,AnyObject>? = Dictionary<String,AnyObject>()
        
        let sections:Int = (self.dataSource?.numberOfSectionsInMenuSection!())!
        
        if sections > 0 {
            var view:UIView?
            for i in 0 ..< sections {
                
                view = self.dataSource?.viewForHeaderInSection!(menuSection: self, section: i)
                
                if view != nil {
                    
                    self.addButton(view: view!, index: i, header: true)
                    
                    let rows:Int = (self.dataSource?.numberOfRowsInSection!(menuSection: self, section: i))!
                    
                    var formatString:String = "[view\(i)(height\(i))]"
                    
                    if rows > 0 {
                        
                        let subsectionContainerView:UIView = self.createSubsectionContainer(section: i)
                        
                        let indiceSub:String = "subsectionContainerView\(i)"
                        
                        views[indiceSub] = subsectionContainerView
                        
                        formatString += "[subsectionContainerView\(i)]"
                    }
                    
                    let indice:String = "view\(i)"
                    
                    views[indice] = view
                    
                    view?.translatesAutoresizingMaskIntoConstraints = false
                    
                    scrollView?.addSubview(view!)
                    
                    heightVisualFormat += "\(formatString)"
                    
                    let widthConstraints:NSMutableArray = NSMutableArray()
                    
                    let width = (self.superview?.frame.size.width)!

                    widthConstraints.addObjects(from: NSLayoutConstraint.constraints(withVisualFormat: "H:|[view(width)]|", options:[], metrics: ["width":width], views: ["view":view!]))
                    
                    let metricsIndexString:String = "height\(i)"
                    
                    metrics![metricsIndexString] = NSNumber.init(value: Float((self.delegate?.heightForHeaderInSection!(menuSection: self, section: i))!))
                    
//                    view?.backgroundColor = UIColor.green
                    
                    scrollView?.addConstraints(widthConstraints as NSArray as! [NSLayoutConstraint])
                }
            }
            
            heightVisualFormat = "\(heightVisualFormat)|"
            
            let heightConstraints:[NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: heightVisualFormat, options: [], metrics: metrics, views: ((views as NSDictionary) as? [String:AnyObject])!)

            self.scrollView?.addConstraints(heightConstraints)
        }
    }
    
     func createSubsectionContainer(section:Int) -> UIView {
        
        let subsectionContainerView:UIView? = UIView()
        
        subsectionContainerView?.translatesAutoresizingMaskIntoConstraints = false
        subsectionContainerView?.tag = section
        
        self.scrollView!.addSubview(subsectionContainerView!)
        
        self.subsectionsContainers.add(subsectionContainerView!)
        
        var views:Dictionary<String,AnyObject>? = Dictionary()
        
        let mViews:NSMutableArray = NSMutableArray()
        
        var metricsSubsection:Dictionary<String,AnyObject>?  = Dictionary()
        
        var heightVisualFormat:String = "V:|"
        
//        let widthConstraints:[NSLayoutConstraint] = [NSLayoutConstraint]()
        
        let rows:Int = self.dataSource!.numberOfRowsInSection!(menuSection: self, section: section)
        
        if rows > 0  {
            
            for i in 0..<rows {
                
                let view:UIView = self.dataSource!.viewForRowAtIndexPath!(menuSection: self, indexPath: IndexPath.init(row: i, section: section))
                
                view.tag = i
                
                self.addButton(view: view, index: section, header: false)
                
                var indexString:String = "view\(i)"
                
                views![indexString] = view
                
                indexString = "height\(i)"
                
                let numAux = self.delegate!.heightForRowAtIndexPath!(menuSection: self, indexPath: IndexPath.init(row: i, section: section))
                
                metricsSubsection![indexString] = numAux as AnyObject?
                
                view.translatesAutoresizingMaskIntoConstraints = false
                
                subsectionContainerView?.addSubview(view)
                
                heightVisualFormat += "[view\(i)(height\(i))]"
                
                
                let widthConstraints:NSMutableArray = NSMutableArray()
                
                let width = (self.superview?.frame.size.width)!
                
                widthConstraints.addObjects(from: NSLayoutConstraint.constraints(withVisualFormat: "H:|[view(width)]|", options:[], metrics: ["width":width], views: ["view":view]))

                subsectionContainerView?.superview?.addConstraints(widthConstraints as NSArray as! [NSLayoutConstraint])
                
                mViews.add(view)
                
            }
        }
        
        heightVisualFormat = "\(heightVisualFormat)|"
        
//        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: heightVisualFormat, options: [], metrics: metricsSubsection, views: ["view":views!])
        let verticalConstraints:[NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: heightVisualFormat, options: [], metrics: metricsSubsection, views:views!)

        subsectionContainerView?.addConstraints(verticalConstraints)
        
        self.dVerticalConstraints!["subsectionContainerView\(section)"] = verticalConstraints
        self.dVerticalViews!["subsectionContainerView\(section)"] = mViews.copy()
        
        NSLayoutConstraint.deactivate(verticalConstraints)
        
        subsectionContainerView?.clipsToBounds = true
        
        var dictSubsectionCV:Dictionary<String,AnyObject> = Dictionary()
        
        dictSubsectionCV["subsectionContainerView"] = subsectionContainerView
        
        let metrics: [String: AnyObject]? = nil
        
        let horizontalConstraints:[NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "H:|[subsectionContainerView]|", options: [], metrics: metrics, views: dictSubsectionCV)

        self.scrollView?.addConstraints(horizontalConstraints)
        
        return subsectionContainerView!
    }
    
     func totalHeightSection(section: Int) -> CGFloat {
        
        var totalHeight:CGFloat = 0.0
        
        if let rows:Int = self.dataSource?.numberOfRowsInSection!(menuSection: self, section: section) {
            
            for i in 0..<rows {
                
                let indexPath = IndexPath.init(row: i, section: section)
                
                if let height:CGFloat = self.delegate?.heightForRowAtIndexPath!(menuSection: self, indexPath: indexPath) {
                    
                    totalHeight += height
                }
            }
        }
        return totalHeight
    }
}
