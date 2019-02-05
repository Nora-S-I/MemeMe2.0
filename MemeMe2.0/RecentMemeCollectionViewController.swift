//
//  RecentMemeCollectionViewController.swift
//  MemeMe2.0
//
//  Created by Norah Al Ibrahim on 12/2/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

class RecentMemeCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //computed property to read memes from app delegate
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    var selectedMeme: UIImage!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recentMeme", for: indexPath) as! MemeCollectionViewCell
        
        let meme = memes[(indexPath as NSIndexPath).row]
        // Set the memed image
        cell.memeImage?.image = meme.memedImage
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //assign MemeDetailViewController to a constant
        let memeDetailController = self.storyboard!.instantiateViewController(withIdentifier: "memeDetailView") as! MemeDetailViewController
        //assign the selected item to selectedMeme property in memeDetailView view controller
        memeDetailController.selectedMeme = memes[(indexPath as NSIndexPath).row]
        //display the memeDetailView view controller
        navigationController!.pushViewController(memeDetailController, animated: true)
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // set collection view delegates
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //set the flow layout of the collection view
        setFlowLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        //reload data referesh collection veiw data
        collectionView!.reloadData()
    }
    
    //function to set the flow layout of the collection view
    func setFlowLayout() {
        
        let space: CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize (width: dimension, height: dimension)
    }
}
