//
//  UtilityManager.swift
//  ITCC Practicle
//
//  Created by MAC on 29/11/21.
//

import Foundation

func IS_INTERNET_AVAILABLE() -> Bool{
    return AIReachabilityManager.sharedManager.isInternetAvailableForAllNetworks()
}

func SHOW_INTERNET_ALERT(){
    hideCustomLoading()
    HIDE_CUSTOM_LOADER()
    HIDE_NETWORK_ACTIVITY_INDICATOR()
    
    displayAlertWithTitle(APP_NAME, andMessage: NOINTERNETMSG, buttons: ["Dismiss"], completion: nil)
}

func displayAlertWithTitle(_ title:String, andMessage message:String, buttons:[String], completion:((_ index:Int) -> Void)!) -> Void {
    
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    for index in 0..<buttons.count    {
        
        //  let titleFont:UIFont = init(name: FONT_Raleway_Bold, size: 17)
        
        //App was crashing in oFfline mode because the font name Raleway-Bold so i changed it to system font.
        
        alertController.setValue(NSAttributedString(string: title, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17.0),NSAttributedString.Key.foregroundColor : APP_HEADER_TEXT_COLOR]), forKey: "attributedTitle")
        
        alertController.setValue(NSAttributedString(string: message, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14.0),NSAttributedString.Key.foregroundColor : UIColor.black]), forKey: "attributedMessage")
        
        
        let action = UIAlertAction(title: buttons[index], style: .default, handler: {
            (alert: UIAlertAction!) in
            if(completion != nil){
                completion(index)
            }
        })
        
        action.setValue(UIColor.black, forKey: "titleTextColor")
        alertController.addAction(action)
    }
    if let viewController = UIApplication.shared.keyWindow?.rootViewController {
        viewController.present(alertController, animated: true, completion: nil)
    }
    
}

func HIDE_NETWORK_ACTIVITY_INDICATOR(){
    UIApplication.shared.isNetworkActivityIndicatorVisible =  false
}
