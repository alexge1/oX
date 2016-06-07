//
//  UserController.swift
//  NoughtsAndCrosses
//
//  Created by Alexander Ge on 6/1/16.
//  Copyright © 2016 Julian Hulme. All rights reserved.
//

import Alamofire

import Foundation


struct User {
    var email: String
    var password: String
}



class UserController {
    // Singleton design pattern
    class var sharedInstance: UserController {
        struct Static {
            static var instance:UserController?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token)    {
            Static.instance = UserController()
        }
        return Static.instance!
    }
    
        private var users: [User] = []
    
    var logged_in_user: User?
    
    func registerUser(newEmail: String, newPassword: String) -> (failureMessage: String?, user: User?) {
        for user in users {
            if user.email == newEmail {
                return ("Email taken", nil)
            }
        }
        let user = User(email: newEmail, password: newPassword)
        users.append(user)
        logged_in_user = user
        NSUserDefaults.standardUserDefaults().setValue("TRUE", forKey: "userIsLoggedIn")
        print("User with email: \(newEmail) has been registered by the UserManager.")
        return (nil, user)
    }
    
    func loginUser(suppliedEmail: String, suppliedPassword: String) -> (failureMessage: String?, user: User?){
        for user in users {
            if user.email == suppliedEmail {
                if user.password == suppliedPassword {
                    logged_in_user = user
                    print("User with email: \(suppliedEmail) has been logged in by the UserManager.")
                    NSUserDefaults.standardUserDefaults().setValue("TRUE", forKey: "userIsLoggedIn")
                    return (nil, user)
                } else {
                    return ("Password incorrect", nil)
                }
            }
        }
        
        return ("No user with that email", nil)
    }
    
    func logoutUser()
    {
        logged_in_user = nil
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "userIsLoggedIn")
    }
    
    
    func storeUser(user: User)
    {
        
        NSUserDefaults.standardUserDefaults().setObject(user.password, forKey: "\(user.email)")
    }
    
    
    func getStoredUser(id: String) -> User?
    {
        
        if let userPasswordString = NSUserDefaults.standardUserDefaults().stringForKey(id)
        {
            // user found
            return User(email: id, password: userPasswordString)
        }
        else
        {
            return nil
        }
    }
    
    
}



















