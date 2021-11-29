//
//  LoginVCViewModel.swift
//  ITCC Practicle
//
//  Created by MAC on 25/11/21.
//

import Foundation
import Alamofire
class LoginVCViewModel {
    
    //MARK:- Class Variable
    private(set) var onLoginResponse = Bindable<AFDataResponse<Any>>()
    private(set) var onGetProfileResponse = Bindable<AFDataResponse<Any>>()
    //MARK:- Init
    init() {
        
    }
    
    //MARK:- Deinit
    deinit {
        debugPrint("‼️‼️‼️ deinit view model : \(self) ‼️‼️‼️")
    }
    
    //MARK:- WEB SERVICES
    func apiLogin(email: String, password: String){
        let body = ["email":email,
                    "password":password,
                    "platform":"iOS",
                    "os_version":"iOS 14.3",
                    "application_version":"V1",
                    "model":"iPhone",
                    "type":"Gmail",
                    "uid":"xyz"]
        
        WebServiceManager.sharedManager.callApi(APILOGINURL,method: .post, parameters: body as [String : AnyObject], headers: nil) { (response) in
            self.onLoginResponse.value = response
        }
    }
    
    func apiGetProfile(){
        var httpHeader:HTTPHeaders = HTTPHeaders()
        httpHeader.add(name: "Authorization", value: "Bearer \(AUTHORIZATION_TOKEN)")
        
        WebServiceManager.sharedManager.callApi(APIGETPROFILEURL,method: .get, parameters: nil, headers: httpHeader) { (response) in
            self.onGetProfileResponse.value = response
        }
    }
    
}
