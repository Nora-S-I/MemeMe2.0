//
//  Meme.swift
//  MemeMe2.0
//
//  Created by Norah Al Ibrahim on 11/30/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit

struct Meme
{
    var topText : String
    var bottomText: String
    var originalImage : UIImage
    var memedImage : UIImage
    
    init(topText: String, bottomText: String, originalImage: UIImage, memedImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
}
