//
//  MenuViewController.swift
//  JGCLateralMenu
//
//  Created by Javier Garcia Castro on 24/9/17.
//  Copyright © 2017 Javier Garcia Castro. All rights reserved.
//

import UIKit
import SideMenu

let kMenuTitle:String = "kMenuTitle"
let kIDSection:String = "kIdSeciton"
let kIsSubsection:String = "kIsSubsection"
let kIsSelected:String = "kIsSelected"
let kMenuSection:String = "kMenuSection"
let kTitle:String = "kTitle"
let kIsOpen:String = "kIsOpen"
let kMenuImage:String = "kMenuImage"
let kValue:String = "kValue"

class MenuViewController: UIViewController {
    
    var imageHeaderView: ImageHeaderView?
    var userName: String = "Lorem Ipsum Dolor"
    var userMail: String = "lorem.ipsum@dolor.sit"

    var menuView:MenuView? = nil
    var options:Array<Dictionary<String,AnyObject>>?
    var mOptions:Array<Dictionary<String,AnyObject>>?
    var headersView:Array<MenuSectionView>? = nil
    var titleSection:String? = nil
    var menuSection:Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mOptions = dataForMenu()
        addMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        imageHeaderView?.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 160)
        view.layoutIfNeeded()
    }
}

extension MenuViewController: MenuViewDataSource, MenuViewDelegate {
    
    func indexForMenuSection(menuSection: Int) -> Int {
        
        for i in 0...mOptions!.count {
            
            let dictionary = mOptions![i]
            
            if dictionary[kMenuSection] as! Int == menuSection {
                return i
            }
        }
        return -1
    }
    
    func isSectionSelected(array: Array<Dictionary<String,Int>>) -> Bool {
        
        for aDictionary:Dictionary<String,Int> in array {
            
            let sectionNumber = Int(aDictionary[kMenuSection]!)
            
            if sectionNumber == self.menuSection {
                return true
            }
        }
        return false
    }
    
    func menuSectionViewForMenuSection(menuSection: Int) -> MenuSectionView{
        return headersView![indexForMenuSection(menuSection: menuSection)]
    }
    
    func selectHeadersView(_ section: Int) {
        
        for i in 0..<headersView!.count {
            
            let sectionView:MenuSectionView = headersView![i]
            
            sectionView.backgroundColor = .darkGray
        }
    }
    
    func dataForMenu() -> Array<Dictionary<String,AnyObject>> {
        
        var menuSection:[String:AnyObject] = [String:AnyObject]()
        menuSection[kTitle] = "Section 0" as AnyObject
        menuSection[kMenuSection] = 0 as AnyObject
        menuSection[kIsOpen] = false as AnyObject
        menuSection[kMenuImage] = "menu_home" as AnyObject
        
        var subSection:[String:AnyObject] = [String:AnyObject]()
        subSection[kTitle] = "SubSection 0" as AnyObject
        subSection[kMenuSection] = 0 as AnyObject
        subSection[kIsOpen] = false as AnyObject
        
        menuSection[kValue] = [subSection] as AnyObject
        
        var menuSection1:[String:AnyObject] = [String:AnyObject]()
        menuSection1[kTitle] = "Section 1" as AnyObject
        menuSection1[kMenuSection] = 1 as AnyObject
        menuSection1[kIsOpen] = false as AnyObject
        menuSection1[kMenuImage] = "menu_power" as AnyObject

        let array = [menuSection, menuSection1]
        
        return array
    }
    
    func addMenu() {
        self.view.backgroundColor = .white
        let menu = MenuView.init(delegate: self, dataSource: self)
        
        menu.translatesAutoresizingMaskIntoConstraints = false
        
        let menuContainerView = UIView()
        
        menuContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(menuContainerView)
        
        let constraints:NSMutableArray = NSMutableArray()
        
        var w:Float
        
        w = 300.0
        
        SideMenuManager.menuWidth = CGFloat(w)
        
        constraints.addObjects(from: NSLayoutConstraint.constraints(withVisualFormat: "H:[menuContainerView(width)]|", options: [], metrics: ["width":w], views: ["menuContainerView":menuContainerView]))
        
        //200 with image header or 20 without it
        constraints.addObjects(from: NSLayoutConstraint.constraints(withVisualFormat: "V:|-220-[menuContainerView]|", options: [], metrics: nil, views: ["menuContainerView":menuContainerView]))
        
        menuContainerView.superview?.addConstraints(constraints as NSArray as! [NSLayoutConstraint])
        
        menuContainerView.layoutIfNeeded()
        menuContainerView.layoutSubviews()
        
        view.layoutIfNeeded()
        view.layoutSubviews()
        
        menuContainerView.addSubview(menu)
        
        UIView.embedView(view: menu)
        
        menuView = menu
    }
    
    // MARK: - MenuViewDataSource
    
    func viewForHeaderInSection(menuSection: MenuView, section: Int) -> UIView {
        
        let dictionary:Dictionary<String,AnyObject> = mOptions![section]
        
        let title = dictionary[kTitle] as! String
        
        let view:MenuSectionView = MenuSectionView.init()
        
        if section == 0 {
            view.topLayerView.isHidden = false
        }
        
        let isOpen = (dictionary as NSDictionary).boolForKey(key: kIsOpen)
        
        view.view.backgroundColor = (isOpen) ? .lightGray: .white
        
        view.layerView.backgroundColor = .gray
        
        view.titleLabel.text = title
        
        view.titleLabel.textColor = .gray
        
        let image: UIImage = UIImage.init(named: dictionary[kMenuImage] as! String)!
        
        view.imageView.image = UIImage.imageFromMaskImage(mask: image, withColor: .black)
        
        view.imageView.tintColor = (section == 1 && title == "Perfil") ? .white : view.imageView.tintColor
        
        headersView?.append(view)
        
        return view
    }
    
    func numberOfRowsInSection(menuSection: MenuView, section: Int) -> Int {
        
        let dictionary:Dictionary<String,AnyObject> = mOptions![section]
        
        if let elements = dictionary[kValue] {
            return elements.count
            
        }
        return 0
    }
    
    func viewForRowAtIndexPath(menuSection: MenuView, indexPath: IndexPath) -> UIView {
        
        let dictionary:Dictionary<String,AnyObject> = mOptions![(indexPath as NSIndexPath).section]
        
        let elements:NSArray = dictionary[kValue] as! NSArray
        
        let element = elements[(indexPath as NSIndexPath).row] as! Dictionary<String,AnyObject>
        
        let view:MenuSubsectionView = MenuSubsectionView.init()
        
        if self.menuSection == (element[kMenuSection] as! Int) {
            view.backgroundColor = .gray
        }
        else {
            view.backgroundColor = .white
        }
        
        view.layerView.backgroundColor = .darkGray
        
        view.titleLabel.textColor = .black
        
        view.titleLabel.text = (element[kTitle] as! String)
        
        view.imageView.removeFromSuperview()
        
        return view
    }
    
    func numberOfSectionsInMenuSection() -> Int {
        return mOptions!.count
    }
    
    // MARK: - MenuViewDelegate
    
    func heightForRowAtIndexPath(menuSection: MenuView, indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
    
    func heightForHeaderInSection(menuSection: MenuView, section: Int) -> CGFloat {
        return 55.0
    }
    
    func didSelectRowAtIndexPath(menuSection: MenuView, indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.present(vcString: "FirstViewController")
        }
    }
    
    func didSelectSection(menuSection: MenuView, section: Int) {
        
        if mOptions![section][kValue] == nil {
            switch section {
            case 0:
//                self.present(vcString: "FirstViewController")
                break
            case 1:
                self.present(vcString: "SecondViewController")
                break
            default:
                break
            }
        }

    }
    
    func showSection() -> Int {
        
        for i in 0..<mOptions!.count {
            
            let dictionary = mOptions![i]
            
            if (dictionary[kIsOpen] != nil) {
                //                return i
            }
        }
        return -1
    }
    
    func subsectionActive(menuSection: MenuView, indexPath: IndexPath) -> Bool {
        return true
    }
    
    func sectionActive(menuSection: MenuView, section: Int) -> Bool {
        return true
    }
}

extension MenuViewController: ImageHeaderViewProtocol {
    
    func userDidTapCameraButton() {

    }
    
    func present(vcString: String) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: vcString)
        
        self.navigationController?.pushViewController(resultViewController, animated: false)
    }
}

