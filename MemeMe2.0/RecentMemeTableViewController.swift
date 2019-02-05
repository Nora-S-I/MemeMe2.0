//
//  RecentMemeTableViewController.swift
//  MemeMe2.0
//
//  Created by Norah Al Ibrahim on 12/1/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

class RecentMemeTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    //computed property to read memes from app delegate
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "recentMeme")!
        let meme = memes[(indexPath as NSIndexPath).row]
        
        // Set the name and image
        cell.textLabel?.text = meme.topText + " ... " + meme.bottomText
        cell.imageView?.image = meme.memedImage
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //assign MemeDetailViewController to a constant
        let memeDetailController = self.storyboard!.instantiateViewController(withIdentifier: "memeDetailView") as! MemeDetailViewController
        //assign the selected item to selectedMeme property in memeDetailView view controller
        memeDetailController.selectedMeme = memes[(indexPath as NSIndexPath).row]
        //display the memeDetailView view controller
        navigationController!.pushViewController(memeDetailController, animated: true)
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //set table view deleagtes
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        //reload data to refresh the table view data
        tableView!.reloadData()
    }
    
    
}
