//
//  AILoader.swift
//
//  Created by Ravi Alagiya on 13/05/17.
//  Copyright © 2016 Agile Infoways. All rights reserved.
//

import UIKit


let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
let SCREEN_WIDTH = UIScreen.main.bounds.size.width
private var activityRestorationIdentifier: String {
    return "NVActivityIndicatorViewContainer"
}

public func ShowLoaderWithMessage(message:String) {
    startActivityAnimating(size: CGSize(width:56, height:56), message: message, type: NVActivityIndicatorType.circleStrokeSpin, color: UIColor.white, padding: 2,isFromOnView: false)
}


//MARK:- ShowLoader
//Mark:-


public func SHOW_CUSTOM_LOADER() {
    startActivityAnimating(size: CGSize(width:56, height:56), message: nil, type: NVActivityIndicatorType.circleStrokeSpin, color: UIColor.white, padding: 2,isFromOnView: false)
}

//MARK:- Custom Red Loaders

var hud:MBProgressHUD = MBProgressHUD()
enum loadermodes {
    case progress
    case loading
}
func startCustomLoading(mode:loadermodes,Label:String,DetailLabel:String,intoview:UIView){
   DispatchQueue.main.async(execute: {
    hud = MBProgressHUD.showAdded(to:intoview, animated: true)
    hud.mode = mode == loadermodes.progress ? .determinate : .indeterminate
    hud.label.text = Label //"Please Wait"
    hud.detailsLabel.text = DetailLabel//"Downloading Frame Pack...":"Downloading Sticker Pack..."
    hud.bezelView.style = .solidColor
    hud.bezelView.color = UIColor.hexColour(hexValue: 0xFF5A60).withAlphaComponent(0.9)
    hud.contentColor = UIColor.white
})
}
func hideCustomLoading(){
    DispatchQueue.main.async(execute: {
        hud.hide(animated: true)
        hud.removeFromSuperview()
    })
 }
func didChangeLoaderProgress(progress: Double,mode:loadermodes,Label:String,DetailLabel:String) {
      //print("Sticker Download Progress:\(progress)")
     DispatchQueue.main.async(execute: {

    hud.mode = mode == loadermodes.progress ? .determinate : .indeterminate
    hud.progress = Float(progress/100.0)
    hud.detailsLabel.text = DetailLabel
    
     })

    }

//MARK:- Hide Loader
//MARK:-


public func HIDE_CUSTOM_LOADER() {
    stopActivityAnimating(isFromOnView: false)
}


//MARK:- ShowLoaderOnView
//Mark:-


public func ShowLoaderOnView() {
    startActivityAnimating(size: CGSize(width:56, height:56), message: nil, type: NVActivityIndicatorType.circleStrokeSpin, color: UIColor.white, padding: 2,isFromOnView: true)
}


//MARK:- HideLoaderOnView
//MARK:-


public func HideLoaderOnView() {
    stopActivityAnimating(isFromOnView: true)
}

private func startActivityAnimating(size: CGSize? = nil, message: String? = nil, type: NVActivityIndicatorType? = nil, color: UIColor? = nil, padding: CGFloat? = nil, isFromOnView:Bool) {
    DispatchQueue.main.async(execute: {
    
    let activityContainer: UIView = UIView(frame: CGRect(x:0, y:0,width:SCREEN_WIDTH, height:SCREEN_HEIGHT))
    activityContainer.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    activityContainer.restorationIdentifier = activityRestorationIdentifier
    
    activityContainer.isUserInteractionEnabled = false
    let actualSize = size ?? CGSize(width:56,height:56)
    
    let activityIndicatorView = NVActivityIndicatorView(
        frame: CGRect(x:0, y:0, width:actualSize.width, height:actualSize.height),
        type: type!,
        color: color!,
        padding: padding!)
        
    
    activityIndicatorView.center = activityContainer.center
    activityIndicatorView.startAnimating()
    activityContainer.addSubview(activityIndicatorView)
    
    
    if message != nil {
        let width = activityContainer.frame.size.width / 2
        if let message = message , !message.isEmpty {
            let label = UILabel(frame: CGRect(x:0, y:0,width:width, height:30))
            label.center = CGPoint(
                x:activityIndicatorView.center.x, y:
                activityIndicatorView.center.y + actualSize.height)
            label.textAlignment = .center
            label.text = message
            label.font = UIFont.systemFont(ofSize: 16.0)
            label.textColor = activityIndicatorView.color
            activityContainer.addSubview(label)
        }
    }
    UIApplication.shared.keyWindow?.isUserInteractionEnabled = false
    if isFromOnView == true {
        UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(activityContainer)
    }
    else {
        UIApplication.shared.keyWindow?.addSubview(activityContainer)
    }
    
})
}

/**
 Stop animation and remove from view hierarchy.
 */

private func stopActivityAnimating(isFromOnView:Bool) {
    DispatchQueue.main.async(execute: { // Correct
         
    UIApplication.shared.keyWindow?.isUserInteractionEnabled = true
    if isFromOnView == true {
        for item in (UIApplication.shared.keyWindow?.rootViewController?.view.subviews)!
            where item.restorationIdentifier == activityRestorationIdentifier {
                item.removeFromSuperview()
        }
    }
    else {
        for item in (UIApplication.shared.keyWindow?.subviews)!
            where item.restorationIdentifier == activityRestorationIdentifier {
                item.removeFromSuperview()
        }
    }
        })
}
