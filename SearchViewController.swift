//
//  SearchViewController.swift
//  CrowdTransfer Beta
//
//  Created by Cristian Duguet on 4/27/15.
//  Copyright (c) 2015 CrowdTransfer. All rights reserved.
//

import UIKit
import Parse

class SearchViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    // Controls
    @IBOutlet var currencyFromField: TextField!
    @IBOutlet var currencyToField: TextField!
    @IBOutlet var amountFromField: UITextField!
    @IBOutlet var amountToField: UITextField!
    
    
    //Initialize Picker Views
    var pickerView1: UIPickerView!
    var pickerView2: UIPickerView!
    
    //Currency Picker List
    var currencyFrom = ["USD", "EUR", "CLP", "GBP", "BRL", "CAD", "INR", "COP"]
    var currencyTo = ["USD", "EUR", "CLP", "GBP", "BRL", "CAD", "INR", "COP"]

    //create activity indicator for pause and restore
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var activeTextField:UITextField?

    
    
    // ****************************** FIND MATCH BUTTON **************************************
    @IBAction func findMatch(sender: AnyObject) {
        
        var error = ""
        
        var amountFromNumber  = amountFromField.text.toInt()
        var amountToNumber = amountToField.text.toInt()
        
        // ----------------- check if theres an image and text -------------
        
        if (amountFromField.text == "") {
            error = "Please insert the amount you have"
        } else if (amountToField.text == "") {
            error = "Please insert the amount you need"
        } else if amountFromNumber == nil || amountToNumber == nil {
            error = "Please enter valid numbers"
        }
    
        // display error
        if (error != "") {
            displayAlert("Cannot Search", error: error)
        } else {
            pause()
            
            //Post Currency Exchanges to class "Offers"
            var post = PFObject(className: "Offers")
            post["user"] = PFUser.currentUser()?.username
            post["amountFrom"] = amountFromNumber
            post["amountTo"] = amountToNumber
            post["currencyFrom"] = currencyFromField.text
            post["currencyTo"] = currencyToField.text
            
            post.saveInBackgroundWithBlock({ (success, error) -> Void in
                if success == false{
                    self.displayAlert("Could not Post", error: "Please try again later")
                } else {
                    self.displayAlert("Matches", error: "Your post is succesful!")
                    println("successfully posted")
                    
                    // reset values to default
                    //waive pause
                    self.restore()
                }
            })
            
        }
    }
    
    
    // **************** FUNCTION: Send Error Alert ****************************
    func displayAlert(title: String, error: String) {
        // add alert
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        // add action to alert
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        //show alert
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // **************** FUNCTION: Pause Application ****************************
    func pause() {
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
    }
    // **************** FUNCTION: Restore Application ****************************
    func restore() {
        activityIndicator.stopAnimating()
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
    }
    
    
    
    
    
    // ****************************** VIEWDIDLOAD **************************************

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // --------------------- PickerView Toolbar and Done Button -------------------------
        let toolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 44))
        var items = [AnyObject]()
        //making done button
        let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: "donePressed")
        items.append(doneButton)
        toolbar.barStyle = UIBarStyle.Black
        toolbar.setItems(items, animated: true)
        
        // -------------------------------- Initialize PickerViews ---------------------------
        // Initialize and configure PickerViews
        pickerView1 = UIPickerView();         pickerView2 = UIPickerView()
        pickerView1.tag = 0         ;         pickerView2.tag = 1
        pickerView1.delegate = self ;         pickerView2.delegate = self
        
        // --------------------------------- Configure TextFields -----------------------------
        currencyFromField.delegate = self                   ;        currencyToField.delegate = self
        currencyFromField.inputAccessoryView = toolbar      ;        currencyToField.inputAccessoryView = toolbar
        self.currencyFromField.inputView = self.pickerView1 ;        self.currencyToField.inputView = self.pickerView2
        
    }
    
    //********************************** Function: others ***************************************
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // ****************************** FOR PICKER VIEW **************************************
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int  {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return currencyFrom.count
        } else if pickerView.tag == 1 {
            return currencyTo.count
        }
        return 1
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if pickerView.tag == 0 {
            return currencyFrom[row]
        } else if pickerView.tag == 1 {
            return currencyTo[row]
        }
        return ""
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)  {
        
        if pickerView.tag == 0 {
            currencyFromField.text = currencyFrom[row]
        } else if pickerView.tag == 1 {
            currencyToField.text = currencyTo[row]
        }
    }
    //Toolbar Done Pressed
    func donePressed() {
        activeTextField?.resignFirstResponder()
    }
    //Implement textFieldDidBeginEditing and store the active UITextField:
    func textFieldDidBeginEditing(textField: UITextField) { // became first responder
        activeTextField = textField
    }
    // **************************** END OF FOR PICKER VIEW **************************************


    // ******************** Hide Keyboard when tapping outside *******************************
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // ************************************ Hide Cursor on certain fields **********************
    func caretRectForPosition(position: UITextPosition!) -> CGRect {
        return CGRectZero;
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