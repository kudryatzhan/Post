//
//  Post.swift
//  Post
//
//  Created by Kudryatzhan Arziyev on 12/2/17.
//  Copyright © 2017 Kudryatzhan Arziyev. All rights reserved.
//

import Foundation


class Post {
    
    private let usernameKey = "username"
    private let textKey = "text"
    private let timeStampKey = "timestamp"
    
    let username: String
    let text: String
    let timeStamp: TimeInterval
    let identifier: UUID
    
    init(username: String, text: String, timeStamp: TimeInterval = Date().timeIntervalSince1970, identifier: UUID = UUID()) {
        
        self.username = username
        self.text = text
        self.timeStamp = timeStamp
        self.identifier = identifier
    }
    
    init?(dictionary: [String: Any], identifier: String) {
        guard let text = dictionary[textKey] as? String,
            let timestamp = dictionary[timeStampKey] as? Double,
            let username = dictionary[usernameKey] as? String,
            let identifier = UUID(uuidString: identifier) else { return nil }
        
        self.text = text
        self.timeStamp = timestamp
        self.username = username
        self.identifier = identifier
    }
}
