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
    
    @IBOutlet var coolView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
        
        

        // Do any additional setup after loading the view.
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
