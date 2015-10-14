//
//  memedTableViewController.swift
//  MemeMe
//
//  Created by Jeanne Nicole Byers on 8/24/15.
//  Copyright (c) 2015 Jeanne Nicole Byers. All rights reserved.
//

import Foundation
import UIKit

class memedTableViewController: UIViewController, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource  {

    // Top Toolbar Items (Add)
    @IBOutlet weak var addMemeButton: UIBarButtonItem!
    @IBOutlet var memedTableView: UITableView!


    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }



// ***** VIEW CONTROLLER MANAGEMENT  **** //

     override func viewWillAppear(animated: Bool) {

        // Show tab Bar
        hidesBottomBarWhenPushed = false

        // Would not show navigation button without turning off/on
        navigationController?.navigationBarHidden = true
        navigationController?.navigationBarHidden = false

        // Set Option to show edit button on the table line
        memedTableView.setEditing(true, animated: true)

        // Refesh the table when one is added or deleted
        memedTableView.reloadData()

    }



// ***** TABLE MANAGEMENT  **** //

    // Number of Rows
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count

    }


 // Load the images and text into the table
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableCell") as! UITableViewCell

        let meme = memes[indexPath.row]

        // Set Image and Size it
        cell.imageView?.image = meme.memedImage
        let sizeValue = CGSizeMake(50.0, 50.0)
        cell.imageView?.contentMode = .ScaleAspectFit


        // Set Top and Bottom Text
        if meme.topMemeText > "" && meme.bottomMemeText > "" {
             cell.textLabel?.text =  meme.topMemeText! + " ... " + meme.bottomMemeText!
        } else if  meme.topMemeText > "" {
             cell.textLabel?.text =  meme.topMemeText!
        } else  {
            cell.textLabel?.text =  meme.bottomMemeText!
        }

        return cell
    }


    // When a meme is selected, push the MemedView controller.  Pass the Meme (used to present details) and the indexPath.Row (used for delete)
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeViewController") as! memedViewController

        // Pass Meme and Index Number
        let selectedMeme = self.memes[indexPath.row]
        detailController.selectedMeme = selectedMeme
        detailController.selectedMemeIndex = indexPath.row

        // Hide Button Bar
        detailController.hidesBottomBarWhenPushed = true

        navigationController!.pushViewController(detailController, animated: true)

    }


    // Slide Delete Button, delete from Meme table and from table view
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {

        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.removeAtIndex(indexPath.row)

        tableView.deleteRowsAtIndexPaths ([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
    }



    // ***** BUTTON MANAGEMENT  **** //

    // When Add button selected push the EditView Controller
    @IBAction func addMemeNavigation(sender: AnyObject) {

        let secondViewController = self.storyboard!.instantiateViewControllerWithIdentifier("EditViewController") as! UIViewController

        secondViewController.hidesBottomBarWhenPushed = true

        navigationController!.pushViewController(secondViewController, animated: false)
    }

}
