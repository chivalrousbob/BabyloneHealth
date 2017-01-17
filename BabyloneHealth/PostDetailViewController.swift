//
//  PostDetailViewController.swift
//  BabyloneHealth
//
//  Created by mac on 16/01/17.
//  Copyright © 2017 Ayoub NOURI. All rights reserved.
//

import UIKit
import CoreData
class PostDetailViewController: UIViewController {

    var post: PostObject!
    @IBOutlet weak var numberOfComments: UILabel!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var postBody: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPostDetail()
        if let body = post.body{
            postBody.text = body
        }else{
            postBody.text = "Post descreption not available"
        }
    }
}
extension PostDetailViewController{
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    func loadPostDetail(){
        let context = getContext()
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        let commentFetchRequest = NSFetchRequest<Comment>(entityName: "Comment")
        let commentPredicate = NSPredicate(format: "post.id == \(post.id!)")
        commentFetchRequest.predicate = commentPredicate
        do{
            if let userID = post.userId {
                let userPredicate = NSPredicate(format: " id == \(userID)")
                fetchRequest.predicate = userPredicate
                let user = try context.fetch(fetchRequest)
                
                if let author = user.first?.name{
                 authorName.text = author
                 }else{
                 authorName.text = "Author name not available"
                 }
                
                let comments = try context.fetch(commentFetchRequest)
                
                if (comments.count > 0) {
                    self.numberOfComments.text = "\(comments.count) Comments"
                }
            }
            
            }catch let error as NSError{
                print("could not store data \(error.userInfo)")
            }
        
    }
    
}

