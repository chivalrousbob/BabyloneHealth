//
//  PostViewController.swift
//  BabyloneHealth
//
//  Created by mac on 16/01/17.
//  Copyright © 2017 Ayoub NOURI. All rights reserved.
//

import UIKit
import CoreData

class PostViewController: UITableViewController {
    var posts = [Post]()
    let overlayView = UIView()
    let activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let  reachability = Reachability()!
        if (reachability.isReachable){
            print("Online")
            
            self.setLoadingView(overlayView: overlayView, activityIndicator: activityIndicator)
            self.clearData()
        } else {
            loadPostData()
            print("Offline")
        }
        
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostViewCell
        cell.post = posts[indexPath.row]

        return cell
    }
    
    @IBAction func unwindFromPostsViewController(segue:UIStoryboardSegue){
        
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "showPostDetail" {
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                let naVC = segue.destination as! UINavigationController
                let postDetailVC = naVC.topViewController as! PostDetailViewController
                let post = PostObject()
                post.id = posts[indexPath.row].id
                post.body = posts[indexPath.row].body!
                post.userId = (posts[indexPath.row].user?.id)!
                postDetailVC.post = post 
    
            }
        }
    }


}
