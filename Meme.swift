//
//  Meme.swift
//  MemeMe
//
//  Created by Jeanne Nicole Byers on 8/22/15.
//  Copyright (c) 2015 Jeanne Nicole Byers. All rights reserved.
//

import Foundation
import UIKit


struct Meme {
    var topMemeText: String?
    var bottomMemeText: String?
    var originalImage: UIImage?
    var memedImage: UIImage?


    // Set the URL and name where the recorded audio is stored
    init(topMemeText: String!, bottomMemeText: String!, originalImage: UIImage!, memedImage: UIImage) {
        self.topMemeText = topMemeText
        self.bottomMemeText = bottomMemeText
        self.memedImage = memedImage
        if originalImage != nil {
            self.originalImage = originalImage!
        }
    }


}


