//
//  IpLoader.swift
//  GalleryApp_o2h
//
//  Created by Apple on 04/02/24.
//

import UIKit
import DGActivityIndicatorView

class IPLoader {
    
    static let shared = IPLoader()
    
    var view : UIView?
    
    static let scrWidth = UIScreen.main.bounds.width
    static let scrHeight = UIScreen.main.bounds.height
    
    class func showLoaderWithBG(viewObj: UIView, boolShow: Bool, enableInteraction: Bool) -> UIView? {
        let width : CGFloat = (54 * scrWidth)/320
        let viewSpinnerBg = UIView(frame: CGRect(x: 0, y: 0, width: scrWidth, height: scrHeight))
        viewSpinnerBg.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.2)
        viewSpinnerBg.layer.masksToBounds = true
        viewSpinnerBg.layer.cornerRadius = 5.0
        viewObj.addSubview(viewSpinnerBg)
        
        if boolShow {
            viewSpinnerBg.isHidden = false
        }
        else {
            viewSpinnerBg.isHidden = true
        }
        
        if !enableInteraction {
            viewObj.isUserInteractionEnabled = false
        }
        
        let activityIndicatorView : DGActivityIndicatorView = DGActivityIndicatorView.init(type: DGActivityIndicatorAnimationType(rawValue: 9)!, tintColor: UIColor.white, size:width)
        activityIndicatorView.center = CGPoint(x: -width, y: scrHeight / 2.0)
        
        UIView.animate(withDuration: 0.5, animations: {
            activityIndicatorView.center = CGPoint(x: scrWidth / 2.0, y: scrHeight / 2.0)
        }) { (isTrue) in
            activityIndicatorView.startAnimating()
        }
        
        activityIndicatorView.tag = 999
        viewSpinnerBg.addSubview(activityIndicatorView)
        return viewSpinnerBg
    }
    
    class func hideRemoveLoaderFromView(removableView: UIView, mainView: UIView) {
        let activityIndicatorView = removableView.viewWithTag(999)
        UIView.animate(withDuration: 0.2, animations: {
            activityIndicatorView?.center = CGPoint(x: scrWidth + CGFloat(activityIndicatorView!.frame.size.width) , y: scrHeight / 2.0)
        }) { (isTrue) in
            removableView.isHidden = true
            removableView.removeFromSuperview()
            mainView.isUserInteractionEnabled = true
        }
    }
}
