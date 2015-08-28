//
//  mainViewController.swift
//  MemeMe
//
//  Created by Jeanne Nicole Byers on 8/24/15.
//  Copyright (c) 2015 Jeanne Nicole Byers. All rights reserved.
//

import Foundation
import UIKit

class mainViewController: UIViewController, UINavigationControllerDelegate  {

    override func viewDidAppear(animated: Bool) {

        //PHASE I -- just continue to detail screen, 
        //PHASE II -- check for saved memes
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondViewController = storyboard.instantiateViewControllerWithIdentifier("EditViewController") as! UIViewController
        presentViewController(secondViewController, animated: false, completion: nil)
    }
    
}
