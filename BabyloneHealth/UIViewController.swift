//
//  UIViewController.swift
//  BabyloneHealth
//
//  Created by mac on 16/01/17.
//  Copyright © 2017 Ayoub NOURI. All rights reserved.
//
import UIKit
extension UIViewController{
    func setLoadingView(overlayView : UIView, activityIndicator : UIActivityIndicatorView) {
        
       
        
        
       
        
        overlayView.frame =  self.view.frame
        overlayView.frame.origin.x = 0
        overlayView.backgroundColor = UIColor.gray
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.center = CGPoint(x: overlayView.frame.width/2, y: overlayView.frame.height/2)
        
        overlayView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        self.view.addSubview(overlayView)
        self.view.isUserInteractionEnabled = false
      
        
    }
    func stopLoadingView(overlayView : UIView, activityIndicator : UIActivityIndicatorView) {

        self.view.isUserInteractionEnabled = true
        activityIndicator.stopAnimating()
        overlayView.removeFromSuperview()
        
    }
    

}
