//
//  ImageCache.swift
//  recipeBook
//
//  Created by Michael Jester on 7/19/18.
//  Copyright © 2018 Michael Jester. All rights reserved.
//

import UIKit

class ImageCache: NSCache<NSString, UIImage> {

    static let sharedInstance = ImageCache()
    
    private override init(){
        super.init()
    }
    
}
