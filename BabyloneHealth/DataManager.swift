//
//  DataManager.swift
//  BabyloneHealth
//
//  Created by mac on 16/01/17.
//  Copyright © 2017 Ayoub NOURI. All rights reserved.
//

import UIKit
import CoreData
enum JSONError: String, Error {
    case NoData = "ERROR: no data"
    case ConversionFailed = "ERROR: conversion from JSON failed"
}

class DataManager: NSObject {
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func getUsers(completion: @escaping (_ userDetail: NSMutableArray, _ error: NSError?)->Void){
        let users = NSMutableArray()
        let     url = URL(string: USERS_URL)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task =  URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200{
                // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            if let data = data{
                do{
                    
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSArray else {
                        throw JSONError.ConversionFailed
                    }
                    
                    for obj in json {
                        var user = Dictionary<String,String>()
                        let object = obj as! NSDictionary
                        
                        user["id"] = "\(object.value(forKey: "id")!)"
                        user["name"] = object.value(forKey: "name") as? String
                        user["username"] = object.value(forKey: "username") as? String
                        users.add(user)
                    }
                    completion(users,nil)
                    
                }catch let error as NSError {
                    print("ERROR: conversion from JSON failed \(error.localizedDescription)")
                }
            }else if let error = error {
                print("error data \(error.localizedDescription)")
            }
        }
        task.resume()
        
    }

    
    func getPosts(completion: @escaping (_ posts: NSMutableArray, _ error: NSError?)->Void){
        let posts = NSMutableArray()
        let     url = URL(string: POSTS_URL)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task =  URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200{
                // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            if let data = data{
                do{
                    //  let responseString = String(data: data, encoding: String.Encoding.utf8)
                    //print("responseString = \(responseString)")
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSArray else {
                        throw JSONError.ConversionFailed
                    }
            
                    for obj in json {
                        let object = obj as! NSDictionary
                        var post = Dictionary<String,String>()
                        post["id"] = "\(object.value(forKey: "id")!)"
                        post["title"] = object.value(forKey: "title") as? String
                        post["userId"] = "\(object.value(forKey: "userId")!)"
                        post["body"] = object.value(forKey: "body") as? String
                    
                        posts.add(post)
                    }
                    completion(posts,nil)
               
                }catch let error as NSError {
                    print("ERROR: conversion from JSON failed \(error.localizedDescription)")
                }
            }else if let error = error {
                print("error data \(error.localizedDescription)")
            }
        }
        task.resume()
        
    }
    
    
    func getComments(completion: @escaping (_ posts: NSMutableArray, _ error: NSError?)->Void){
        let comments = NSMutableArray()
        let     url = URL(string: COMMENTS_URL)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task =  URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200{
                // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            if let data = data{
                do{
                    
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSArray else {
                        throw JSONError.ConversionFailed
                    }
                    for obj in json {
                        let object = obj as! NSDictionary
                        var comment = Dictionary<String,String>()
                        
                        comment["id"] = "\(object.value(forKey: "id")!)"
                        comment["postId"] = "\(object.value(forKey: "postId")!)"
                        comments.add(comment)
                    }
                    completion(comments,nil)
        
                }catch let error as NSError {
                    print("ERROR: conversion from JSON failed \(error.localizedDescription)")
                }
            }else if let error = error {
                print("error data \(error.localizedDescription)")
            }
        }
        task.resume()
        
    }

    
    }
