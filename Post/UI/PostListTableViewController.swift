//
//  PostListTableViewController.swift
//  Post
//
//  Created by Kudryatzhan Arziyev on 12/3/17.
//  Copyright © 2017 Kudryatzhan Arziyev. All rights reserved.
//

import UIKit

class PostListTableViewController: UITableViewController, PostControllerDelegate {

    var postController = PostController()
    
    func stringFromTimeInterval(interval: TimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        postController.delegate = self
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        
        setupRefreshControl()
        
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return postController.posts.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostListTableViewCell", for: indexPath)
        let post = postController.posts[indexPath.row]

        // Configure the cell...
        cell.textLabel?.text = post.username
        cell.detailTextLabel?.text = "\(post.username) \(stringFromTimeInterval(interval: post.timeStamp))"

        return cell
    }
    
    // PostControllerDelegate
    func postsWereUpdated(posts: [Post], on postController: PostController) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension PostListTableViewController {
    
    // refreshControl
    func setupRefreshControl() {
        let rc = UIRefreshControl()
        tableView.refreshControl = rc
        rc.addTarget(self, action: #selector(reloadPosts), for: .valueChanged)
    }
    
    @objc func reloadPosts() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        postController.fetchPosts()
        tableView.refreshControl?.endRefreshing()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
