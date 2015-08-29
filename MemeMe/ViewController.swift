//
//  ViewController.swift
//  MemeMe
//
//  Created by Jeanne Nicole Byers on 8/8/15.
//  Copyright (c) 2015 Jeanne Nicole Byers. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    // Top Toolbar Items (Share and Cancel)
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!

    private var activityViewController: UIActivityViewController?

    // Image
    @IBOutlet weak var imagePickView: UIImageView!
    private var photo  = [UIImageView()]

    // Bottom Toolbar Items (Album and Camera)
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var pickAnImage: UIBarButtonItem!

    private var imagePicker = UIImagePickerController()

    // Text Fields
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!

    private let textDelegate = TextFieldDelegate()
    private var activeTextField: UITextField?




    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // Enable camera button if the phone has a camera
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable( UIImagePickerControllerSourceType.Camera)

        // Subscribe the notifications so that the bottom text will move when keyboard is presented
        subscribeToKeyboardNotifications()
    }



    override func viewDidLoad() {
        super.viewDidLoad()

        // Set Text Attributes for each of the text fields
        setTextAttributes(topTextField)
        setTextAttributes(bottomTextField)


        // Share button disabled until a photo is selected
        shareButton.enabled = false
    }



    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        // Unsubscribe from the keyboard notifications
        unsubscribeFromKeyboardNotifications()
    }


    // Hide status bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }


    // When cancel is chosen, dismiss the view controller to return to original settings
    @IBAction func cancelRefreshViewController(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }


// ***** TEXT MANAGEMENT  **** //

    // Set text attributes 
    func setTextAttributes(textField: UITextField) {

        // Set Text Delegates
        textField.delegate = textDelegate

        //Default text
        if textField === topTextField {
            textField.text = "TOP"
        } else {
            textField.text = "BOTTOM"
        }

        // Text Formatting - All Caps, Font, Fill, Stroke, Center, Adjust Width, Minimum Size

        let memeTextAttributes = [
            NSStrokeColorAttributeName: UIColor.blackColor(),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)! ,
            NSStrokeWidthAttributeName: -5
        ]

        textField.autocapitalizationType = .AllCharacters
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .Center
        textField.adjustsFontSizeToFitWidth = true
        textField.minimumFontSize = 8.0

    }


// ***** IMAGE MANAGEMENT  **** //

    // Select an image from the photo album
    @IBAction func pickAnImage(sender: AnyObject) {
        pickAnImageControl(.PhotoLibrary)
    }


    // Camara Take a photo with the Camera
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        pickAnImageControl(.Camera)
    }


    // Either opens Album or Camera based on option chosen
    func pickAnImageControl(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        presentViewController(imagePicker, animated: true, completion: nil)
    }


    // Show photo that was selected from Album or picture that was taken
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject: AnyObject])  {

        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage

        imagePickView.contentMode = .ScaleAspectFit
        imagePickView.image = chosenImage

        // Image selected, enable share button
        shareButton.enabled = true

        dismissViewControllerAnimated(true, completion: nil)
    }


    // Image was not selected or taken
    func imagePickerControllerDidCancel(UIImagePickerController){
        dismissViewControllerAnimated(true, completion: nil)
    }



// ***** SHARE (ACTIVITY) MANAGEMENT  **** //

    // Share button
    @IBAction func shareButtonActivity(sender: UIBarButtonItem) {

        // Generate memed Image.
        let memedImage: UIImage = generateMemedImage()

        // Excluding some of the options so that it makes more sense for a meme sharing
        let excludeTypes = [ UIActivityTypeAssignToContact,
                             UIActivityTypeAddToReadingList,
                             UIActivityTypeAirDrop,
                             UIActivityTypePostToFlickr,
                             UIActivityTypePostToVimeo,
                             UIActivityTypePostToTencentWeibo
        ]

        activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityViewController!.excludedActivityTypes = excludeTypes

        // Present the Activity View Controller
        presentViewController(activityViewController!, animated: true, completion: nil)


        // If share was successful, save off Meme for Phase II
        activityViewController?.completionWithItemsHandler = {(activity, success, items,  error) in
            if success == true {
                var savedMeme = Meme(topMemeText: self.topTextField.text, bottomMemeText: self.bottomTextField.text, originalImage: self.imagePickView!.image, memedImage: memedImage)
            }
        }

    }


    // Generate the memed image. Hide and Show toolbars so they are not included in the image.
    func generateMemedImage() -> UIImage {

        topToolBar.hidden = true
        bottomToolBar.hidden = true


        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        topToolBar.hidden = false
        bottomToolBar.hidden = false

        return memedImage
    }






// ***** KEYBOARD MANAGEMENT  **** //

    // Subsribe to notifications so the view can be moved for the bottom text
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }


    // Unsubscribe from the notifications
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }


    // Set the variable to check in the keyboard willshow routine so the view
    // is only moved for the bottom text not the top
    @IBAction func textFieldBeginEdit(sender: UITextField) {
        activeTextField = sender
    }


    // If keyboard is for bottom text field, then move the view out of the way
    func keyboardWillShow(notification: NSNotification) {
        let keyBoardHeight = getKeyboardHeight(notification)
        if activeTextField === bottomTextField {
           view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }


    // Reset View back down
    func keyboardWillHide(notification: NSNotification) {
        if activeTextField === bottomTextField {
            view.frame.origin.y = 0
        }
    }


    // Get keyboard height, used to calculate how much to move keyboard up
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }



}














