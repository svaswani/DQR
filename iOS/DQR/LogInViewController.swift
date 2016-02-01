//
//  LoginViewController.swift
//  DQR
//
//  Created by Apple on 1/30/16.
//  Copyright © 2016 Team DQR. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var name: UITextField!
    
    var newPlayer:PlayerItem?
    
    @IBOutlet weak var userNameInput: UITextField!
    
    @IBOutlet weak var joinButton: UIButton!
    
    // join button code
    @IBAction func didClickJoin(sender: AnyObject) {
        if (!userNameInput.text!.isEmpty)
        {
            let name = userNameInput.text!
            newPlayer = PlayerItem(name: name)
            self.performSegueWithIdentifier("goToPlayers", sender: self)
        }
        else
        {
            let alert = UIAlertController(title: "Error!", message: "You did not enter a name", preferredStyle: UIAlertControllerStyle.Alert)
            let alertAction = UIAlertAction(title: "OK!", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in }
            alert.addAction(alertAction)
            presentViewController(alert, animated: true) { () -> Void in }

        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("In prepareForSegue")
        if segue.identifier == "goToPlayers" {
            let nVC = segue.destinationViewController as! UINavigationController
            let ptVC = nVC.viewControllers[0] as! PlayersTableViewController
            if let newPlayer = newPlayer {
                ptVC.myManager!.thisPlayer = newPlayer
                //ptVC.myManager!.addToList(newPlayer)
            }
        }
        print("Exiting prepareForSegue")
    }
    
    @IBOutlet var coolView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
        name.becomeFirstResponder()
        // Do any additional setup after loading the view.
        joinButton.layer.cornerRadius = 10
        joinButton.clipsToBounds = true
        
        //NetHelper.getNetHelper()
    }
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    @IBAction func didStartEditing(sender: AnyObject) {
        UIView.beginAnimations("lol", context: nil)
        coolView.transform = CGAffineTransformMakeTranslation(0, -200)
        UIView.commitAnimations()
    }
    @IBAction func hideKeyboard(sender: AnyObject) {
        UIView.beginAnimations("lol", context: nil)
        coolView.transform = CGAffineTransformMakeTranslation(0, 0)
        UIView.commitAnimations()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
