//
//  AIReachabilityManager.swift
//  Swift3CodeStucture
//
//  Created by Ravi Alagiya on 11/24/16.
//  Copyright © 2016 agilepc-100. All rights reserved.
// 


import UIKit



class AIReachabilityManager: NSObject {

    var reachability:Reachability!
    
    static let sharedManager : AIReachabilityManager = {
        let instance = AIReachabilityManager()
        return instance
    }()
    
    func isInternetAvailableForAllNetworks() -> Bool
    {
        if(self.reachability == nil){
            self.doSetupReachability()
            return self.reachability!.connection != .unavailable || reachability!.connection == .wifi || self.reachability!.connection == .cellular
        }
        else{
            return reachability!.connection != .unavailable || reachability!.connection == .wifi || reachability!.connection == .cellular
        }
    }
 
    func doSetupReachability() {
        
        do{
            let reachability = try Reachability()
            
            self.reachability = reachability
        }
        catch ReachabilityError.failedToCreateWithAddress(_, _){
            return
        }
        catch{}
        
        reachability.whenReachable = { reachability in
        }
        reachability.whenUnreachable = { reachability in
        }
        do {
            try reachability.startNotifier()
        }
        catch {
        }
    }
    deinit{
        reachability.stopNotifier()
        reachability = nil
    }
    
}
