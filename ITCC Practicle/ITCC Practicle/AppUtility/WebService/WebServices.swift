//
//  WebServices.swift
//  ITCC Practicle
//
//  Created by MAC on 29/11/21.
//

import Foundation
import Alamofire

class WebServiceManager: NSObject {
    
    static let sharedManager : WebServiceManager = {
        let instance = WebServiceManager()
        return instance
    }()
    
    
    // MARK: - ************* COMMON API METHOD **************
    
    func callApi(_ url : String ,method:HTTPMethod,parameters: Parameters? = nil,headers:HTTPHeaders? = nil, completionHandler : @escaping (AFDataResponse<Any>) -> ())
    {
        if IS_INTERNET_AVAILABLE()
        {
            SHOW_CUSTOM_LOADER()
            AF.request(url, method:method, parameters:parameters,headers:headers).responseJSON { (response) in
                HIDE_CUSTOM_LOADER()
                completionHandler(response)
            }
        }
        else
        {
            SHOW_INTERNET_ALERT()
        }
    }
}

