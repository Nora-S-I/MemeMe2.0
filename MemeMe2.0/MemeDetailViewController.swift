//
//  MemeDetailViewController.swift
//  MemeMe2.0
//
//  Created by Norah Al Ibrahim on 12/8/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var selectedMeme: Meme!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = selectedMeme.memedImage
    }
    
}
