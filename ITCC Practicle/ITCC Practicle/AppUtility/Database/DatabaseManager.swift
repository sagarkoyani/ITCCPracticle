//
//  DatabaseManager.swift
//  YoutubeSqliteDemo
//
//  Created by Yogesh Patel on 15/12/18.
//  Copyright © 2018 Yogesh Patel. All rights reserved.
//

import Foundation
var shareInstance = DatabaseManager()
class DatabaseManager: NSObject{
    
    var database:FMDatabase? = nil
    
    
    class func getInstance() -> DatabaseManager{
        if shareInstance.database == nil{
            shareInstance.database = FMDatabase(path: Util.getPath(DBNAME))
        }
        return shareInstance
    }
    
    // "INSERT INTO reginfo (name, username, email, password) VALUES(?,?,?,?)"
    func saveData(_ modelInfo:UserProfileDataModel) -> Bool{
        shareInstance.database?.open()
//        INSERT INTO User_profiles (userid,first_name,last_name,email,dob,gender,roll_name,usertype,type,profilepic,isfirsttime)  VALUES  (12,"sagar","Koyani","sa@gmail.com","2021-08","male","member","3","gmail","profilepic","1")
        let isSave = shareInstance.database?.executeUpdate("INSERT INTO User_profiles (userid,first_name,last_name,email,dob,gender,roll_name,usertype,type,profilepic,isfirsttime)  VALUES  (?,?,?,?,?,?,?,?,?,?,?)", withArgumentsIn: [modelInfo.id,modelInfo.firstName,modelInfo.lastName,modelInfo.email,modelInfo.dob,modelInfo.gender,modelInfo.roleName,modelInfo.userType,modelInfo.type,modelInfo.profilePic,modelInfo.isFirstTime])
        shareInstance.database?.close()
        return isSave!
    }
    
    
    //MARK: - Get All Users data
     func getAllUsers() -> [UserProfileDataModel]{
         shareInstance.database?.open()
         //FMResultSet  :  Used to hold result of SQL query on FMDatabase object.
         let resultSet : FMResultSet! = try! shareInstance.database?.executeQuery("SELECT * FROM User_profiles", values: nil)
         var allUsers = [UserProfileDataModel]()
         
         if resultSet != nil{
             while resultSet.next() {
                let userModel = UserProfileDataModel(id: resultSet.string(forColumn: "userid")!, firstName: resultSet.string(forColumn: "first_name")!, lastName: resultSet.string(forColumn: "last_name")!, email: resultSet.string(forColumn: "email")!, dob: resultSet.string(forColumn: "dob")!, gender: resultSet.string(forColumn: "gender")!, roleName: resultSet.string(forColumn: "roll_name")!, userType: resultSet.string(forColumn: "usertype")!, type: resultSet.string(forColumn: "type")!, profilePic: resultSet.string(forColumn: "profilepic")!, isFirstTime: resultSet.string(forColumn: "isfirsttime")!)
                 
                 allUsers.append(userModel)
             }
         }
         shareInstance.database?.close()
         return allUsers
     }
    
}
