//
//  PostController.swift
//  Post
//
//  Created by Kudryatzhan Arziyev on 12/2/17.
//  Copyright © 2017 Kudryatzhan Arziyev. All rights reserved.
//

import Foundation

class PostController {
    
    
    // base URL
    private static let baseURL = URL(string: "https://devmtn-post.firebaseio.com/posts")
    
    // getter endpoint
    private static let getterEndpoint = baseURL?.appendingPathExtension("json")
    
    // posts
    static var posts = [Post]() {
        didSet {
            print(posts.count)
        }
    }
    
    static func fetchPosts(completion: @escaping ([Post]) -> Void) {
        // url
        guard let url = getterEndpoint else { completion([]); return }
        print(url.absoluteString)
        
        // request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.httpBody = nil
        
        // data task, resume it
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let data = data else { completion([]); return }
            
            guard let dictionaryObject = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: [String: Any]] else {
                completion([])
                return
            }
            
            
            let posts = dictionaryObject.flatMap { Post(dictionary: $0.value, identifier: $0.key) }
            let sortedPosts = posts.sorted(by: { $0.timeStamp > $1.timeStamp })
            
            self.posts = sortedPosts
            
            completion(sortedPosts)
        }
        dataTask.resume()
    }
}
