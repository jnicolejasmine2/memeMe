//
//  memedViewController.swift
//  MemeMe
//
//  Created by Jeanne Nicole Byers on 8/8/15.
//  Copyright (c) 2015 Jeanne Nicole Byers. All rights reserved.
//

import UIKit


class memedViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    // Top Toolbar Items (Share and Cancel)
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var deleteMemeButton: UIBarButtonItem!
    @IBOutlet weak var backButton: UIButton!


    // Image
    @IBOutlet weak var imagePickView: UIImageView!
    private var photo  = [UIImageView()]


    // Text Fields
    @IBOutlet weak var topTextField: UILabel!
    @IBOutlet weak var bottomTextField: UILabel!


    //Passed Fields 
    var selectedMeme: Meme?
    var selectedMemeIndex:Int?


// ***** VIEW CONTROLLER MANAGEMENT  **** //

    override func viewDidLoad() {
        super.viewDidLoad()

        // Hide navigation, managed by tool bar
        navigationController?.navigationBar.hidden = true

        // Set Text and Attributes for each of the text fields
        setTextAttributes(topTextField, selectedText: selectedMeme?.topMemeText)
        setTextAttributes(bottomTextField, selectedText: selectedMeme?.bottomMemeText)

        // Set the Image
        if let imageCheck = selectedMeme?.originalImage {
            imagePickView.image = selectedMeme?.originalImage
        }
    }



// ***** BUTTON MANAGEMENT  **** //

    // Saved Memes, return to table/collection
    @IBAction func cancelRefreshViewController(sender: AnyObject) {
        navigationController?.popToRootViewControllerAnimated(true)

     }


    // Edit Button, pass meme to Editor
    @IBAction func editMeme(sender: AnyObject) {

        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("EditViewController") as! ViewController

        detailController.selectedMeme = selectedMeme

        // Hide Tab Barr
        detailController.hidesBottomBarWhenPushed = true

        navigationController!.pushViewController(detailController, animated: true)
    }



    // Delete Button, remove the meme from the display and return to table/collection
    @IBAction func deleteMeme(sender: AnyObject) {

        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.removeAtIndex(selectedMemeIndex!)

        navigationController?.popToRootViewControllerAnimated(false)
    }




// ***** TEXT MANAGEMENT  **** //

    // Set text fields and  attributes
    func setTextAttributes(textField: UILabel, selectedText: String?) {

        if let textCheck = selectedText {

            // Text Formatting - All Caps, Font, Fill, Stroke, Center, Adjust Width, Minimum Size
            let memeTextAttributes = [
                NSStrokeColorAttributeName: UIColor.blackColor(),
                NSForegroundColorAttributeName: UIColor.whiteColor(),
                NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
                 NSStrokeWidthAttributeName: -5
            ]
            var textFormatted = NSMutableAttributedString(string: textCheck, attributes: memeTextAttributes)

            textField.attributedText = textFormatted
        }
    }

}

