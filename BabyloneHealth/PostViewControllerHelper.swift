
//
//  PostViewControllerHelper.swift
//  BabyloneHealth
//
//  Created by mac on 16/01/17.
//  Copyright © 2017 Ayoub NOURI. All rights reserved.
//

import UIKit
import CoreData

extension PostViewController{
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    func loadPostData(){
        let context = getContext()
        do{
            let fetchRequest = NSFetchRequest<Post>(entityName: "Post")
            let postSortDescriptor = NSSortDescriptor(key: "id", ascending: true)
            let postSortDescriptors = [postSortDescriptor]
            fetchRequest.sortDescriptors = postSortDescriptors
            self.posts =  try context.fetch(fetchRequest)
            //print("self.posts \(self.posts)")
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.stopLoadingView(overlayView: self.overlayView, activityIndicator: self.activityIndicator)
            }
           // print("self.posts.count == \(self.posts.count)")
            
        }catch let error as NSError{
            print("could not load Post data\(error.localizedDescription)")
        }
    }
    
    
    func storeData(){
        let dm = DataManager()
        dm.getUsers { (users, userError) in
            dm.getPosts(completion: { (posts, postError) in
                dm.getComments(completion: { (comments, commentError) in
                    let context = self.getContext()
                    do{
                        var iUser = 0
                        for user in users {
                            let user = user as! NSDictionary
                            iUser += 1
                          //  print("iUser \(iUser)")
                            let userEntity = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as! User
                            userEntity.id = Int32(user.value(forKey: "id") as! String)!
                            userEntity.name = user.value(forKey: "name") as? String
                            
                            userEntity.username = user.value(forKey: "username") as? String
                            var iPost = 0
                            for post in posts{
                                let post = post as! NSDictionary
                                iPost += 1
                               // print("iPost \(iPost)")
                                
                                var iEqual = 0
                                let userID = Int32(user.value(forKey: "id") as! String)!
                                let postUserID = Int32(post.value(forKey: "userId") as! String)!
                                if(userID == postUserID){
                                    let postEntity = NSEntityDescription.insertNewObject(forEntityName: "Post", into: context ) as! Post
                                    //try context.delete(postEntity)
                                    postEntity.id = Int32(post.value(forKey: "id") as! String)!
                                    postEntity.title = post.value(forKey: "title") as? String
                                    postEntity.body = post.value(forKey: "body") as? String
                                    
                                    iEqual += 1
                                   // print("iEqual \(iEqual)")
                                    //let postList = userEntity.mutableSetValue(forKey: "posts")
                                    //postList.add(post)
                                    userEntity.addToPosts(postEntity)
                                    for comment in comments {
                                        let comment = comment as! NSDictionary
                                        let postID = Int32(post.value(forKey: "id") as! String)!
                                        let commentPostID = Int32(comment.value(forKey: "postId") as! String)!
                                        if(postID == commentPostID){
                                            let commentEntity = NSEntityDescription.insertNewObject(forEntityName: "Comment", into: context) as! Comment
                                            commentEntity.id = Int32(comment.value(forKey: "id") as! String)!
                                            postEntity.addToComments(commentEntity)
                                        }
                                    }
                                }
                            }
                        }
                        try context.save()
                        self.loadPostData()
                    }catch let error as NSError{
                        print("could not store data \(error.userInfo)")
                    }
                })
            })
        }
    }
    
    func clearData(){
        let context = getContext()
        let entitiesNames = ["User","Post","Comment"]
        do{
            for entity in entitiesNames{
                
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity)
                
                let objects = try (context.fetch(fetchRequest))
                
                for object in objects{
                    context.delete(object)
                }
            }
            try context.save()
            self.storeData()
        }catch let error as NSError{
            print("Could not clear the data. \(error), \(error.userInfo)")
        }
    }


}
