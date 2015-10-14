//
//  TextFieldDelegate.swift
//  MemeMe
//
//  Created by Jeanne Nicole Byers on 8/14/15.
//  Copyright (c) 2015 Jeanne Nicole Byers. All rights reserved.
//
////

import Foundation
import UIKit

class TextFieldDelegate: NSObject, UITextFieldDelegate {

    // Clear text field before accepting new text
    func textFieldDidBeginEditing(textField: UITextField) {

        if textField.text == "TOP" {
            textField.text = ""
        }

        if textField.text == "BOTTOM" {
            textField.text = ""
        }
    }


    // Convert both textfields UpperCase
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        textField.text = (textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string.uppercaseString)
        return false
    }


    // Allows the keyboard to be closed
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
       return true
    }

}


