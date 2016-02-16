//
//  collectionViewController.swift
//  MemeMe
//
//  Created by Jeanne Nicole Byers on 8/24/15.
//  Copyright (c) 2015 Jeanne Nicole Byers. All rights reserved.
//

import Foundation
import UIKit

class  collectionViewController: UICollectionViewController, UINavigationControllerDelegate     {


    @IBOutlet weak var addMemeButton: UIBarButtonItem!

    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }

    @IBOutlet var memedCollectionView: UICollectionView!


// ***** VIEW CONTROLLER MANAGEMENT  **** //

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // Would not show navigation button without turning off/on
        navigationController?.navigationBarHidden = true
        navigationController?.navigationBarHidden = false

        // Reload data when returned from other views
        memedCollectionView.reloadData()

    }

 

// ***** COLLECTION MANAGEMENT  **** //

    // Number of Items
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }


    // Load the images into the collection
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell: memedCollectionCell = collectionView.dequeueReusableCellWithReuseIdentifier("CustomCollectionCell", forIndexPath: indexPath) as! memedCollectionCell

        let meme = memes[indexPath.item]
        cell.collectionCellImage.image = meme.memedImage

        cell.collectionCellImage.contentMode = .ScaleAspectFit

        return cell
    }


    // When a meme is selected, push the MemedView controller.  Pass the Meme (used to present details) and the indexPath.Row (used for delete)
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        let detailController = storyboard!.instantiateViewControllerWithIdentifier("MemeViewController") as! memedViewController

        let selectedMeme = memes[indexPath.item]
        detailController.selectedMeme = selectedMeme

        detailController.selectedMemeIndex = indexPath.row

        // Hide tab bar
        detailController.hidesBottomBarWhenPushed = true

        navigationController!.pushViewController(detailController, animated: true)
    }


// ***** BUTTON MANAGEMENT  **** //

    // When Add button selected push the EditView Controller
    @IBAction func addMemeNavigation(sender: AnyObject) {

        let secondViewController = storyboard!.instantiateViewControllerWithIdentifier("EditViewController") 

        // Hide tab bar
        secondViewController.hidesBottomBarWhenPushed = true

        navigationController!.pushViewController(secondViewController, animated: false)
    }


}
