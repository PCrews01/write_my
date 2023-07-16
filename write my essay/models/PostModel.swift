//
//  PostModel.swift
//  write my essay
//
//  Created by Paul Crews on 1/4/23.
//

import Foundation
import SwiftUI

class Post {
    var id = UUID().uuidString
    var post_image: Image
    var post_topic: String
    var post_caption: String
    
    init(id:String = UUID().uuidString, post_image: Image, post_topic: String, post_caption: String){
        self.id = id
        self.post_image = post_image
        self.post_topic = post_topic
        self.post_caption = post_caption
    }
    
}
