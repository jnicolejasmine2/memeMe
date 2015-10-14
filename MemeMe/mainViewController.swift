//
//  mainViewController.swift
//  MemeMe
//
//  Created by Jeanne Nicole Byers on 8/24/15.
//  Copyright (c) 2015 Jeanne Nicole Byers. All rights reserved.
//

import Foundation
import UIKit

class mainViewController: UIViewController, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource  {

    // Top Toolbar Items (Add)
    @IBOutlet weak var addMemeButton: UIBarButtonItem!
    @IBOutlet var memedTableView: UITableView!


    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }



// ***** VIEW CONTROLLER MANAGEMENT  **** //

     override func viewWillAppear(animated: Bool) {
        
        // Check if any samed memes, if not present Edit View controller
        if self.memes.count == 0 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)

            let secondViewController = self.storyboard!.instantiateViewControllerWithIdentifier("EditViewController") as! UIViewController

            // Turn off Tab Bar
            secondViewController.hidesBottomBarWhenPushed = true
           
            self.navigationController!.pushViewController(secondViewController, animated: false)
        }

        // Show tab Bar
        hidesBottomBarWhenPushed = false

        // Would not show navigation button without turning off/on
        navigationController?.navigationBarHidden = true
        navigationController?.navigationBarHidden = false

    }


    // Reload data when returned from other views
    override func viewDidAppear(animated: Bool) {
        memedTableView.reloadData()

    }

// ***** TABLE MANAGEMENT  **** //

    // Number of Rows
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count

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
