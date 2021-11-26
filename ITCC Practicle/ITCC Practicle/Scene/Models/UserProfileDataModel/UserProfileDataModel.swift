//
//  UserProfileDataModel.swift
//  ITCC Practicle
//
//  Created by MAC on 25/11/21.
//

import Foundation


struct UserProfileDataModel {
    
    let id:String
    let firstName:String
    let lastName:String
    let email:String
    let dob:String
    let gender:String
    let roleName:String
    let userType:String
    let type:String
    let profilePic:String
    let isFirstTime:String
    
    
    init(fromJson json: JSON) {
        
        id = json["id"].stringValue
        firstName = json["first_name"].stringValue
        lastName = json["last_name"].stringValue
        email = json["email"].stringValue
        dob = json["dob"].stringValue
        gender = json["gender"].stringValue
        roleName = json["role_name"].stringValue
        userType = json["user_type"].stringValue
        type = json["type"].stringValue
        profilePic = json["profile_pic"].stringValue
        isFirstTime = json["is_first_time"].stringValue
     
    }
    
    internal init(id: String, firstName: String, lastName: String, email: String, dob: String, gender: String, roleName: String, userType: String, type: String, profilePic: String, isFirstTime: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.dob = dob
        self.gender = gender
        self.roleName = roleName
        self.userType = userType
        self.type = type
        self.profilePic = profilePic
        self.isFirstTime = isFirstTime
    }
}
