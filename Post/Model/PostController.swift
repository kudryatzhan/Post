//
//  PostController.swift
//  Post
//
//  Created by Kudryatzhan Arziyev on 12/2/17.
//  Copyright © 2017 Kudryatzhan Arziyev. All rights reserved.
//

import Foundation

protocol PostControllerDelegate {
    func postsWereUpdated(posts: [Post], on postController: PostController)
}

class PostController {
    
    static let shared = PostController()
    
    // base URL
    private let baseURL = URL(string: "https://devmtn-post.firebaseio.com/posts")
    
    // posts
    var posts = [Post]() {
        didSet {
            delegate?.postsWereUpdated(posts: posts, on: self)
        }
    }
    
    // delegate
    var delegate: PostControllerDelegate?
    
    init() {
        fetchPosts()
    }
    
    func fetchPosts() {
        // url
        guard let url = baseURL?.appendingPathExtension("json") else { return }
        print(url.absoluteString)
        
        // request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.httpBody = nil
        
        // data task, resume it
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else { return }
            
            guard let dictionaryObject = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: [String: Any]] else {
                return
            }
            
            
            let posts = dictionaryObject.flatMap { Post(dictionary: $0.value, identifier: $0.key) }
            let sortedPosts = posts.sorted(by: { $0.timeStamp > $1.timeStamp })
            
            self.posts = sortedPosts
        }
        dataTask.resume()
    }
}
