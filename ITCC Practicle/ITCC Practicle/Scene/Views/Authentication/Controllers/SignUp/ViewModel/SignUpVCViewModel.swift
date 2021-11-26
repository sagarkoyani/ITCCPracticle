//
//  SignUpVCViewModel.swift
//  ITCC Practicle
//
//  Created by MAC on 25/11/21.
//

import Foundation
class SignUpVCViewModel {
    //MARK:- Class Variable
    let arrGenders = ["Male", "Female"]
    let arrUserType = ["Person with disability", "Community Member","Disability Advocate","Carer","Support Worker","Support Coordinator","Business Representative"]
    //MARK:- Init
    init() {
        
    }
    
    //MARK:- Deinit
    deinit {
        debugPrint("‼️‼️‼️ deinit view model : \(self) ‼️‼️‼️")
    }
}
