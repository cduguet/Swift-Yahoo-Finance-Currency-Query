//
//  RatesTableViewController.swift
//  
//
//  Created by Cristian Duguet on 4/28/15.
//
//

import UIKit

class RatesTableViewController: UITableViewController {
    
    var curr :[(currency: NSString, value: NSNumber)] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    
    
        updateRates()
    
    
    }
    
    
    // *************************** Load Exchange Rates *******************************
    func updateRates() {
        let results = YQL.query("select * from yahoo.finance.xchange where pair in (\"EUR\",\"GBP\", \"CLP\", \"BRL\", \"INR\", \"COP\", \"JPY\", \"CNY\", \"AUD\", \"CHF\", \"NZD\", \"ARS\")")
        let queryResults = results?.valueForKeyPath("query.results") as! NSDictionary?
        if queryResults != nil {
            
            //NSLog( "query.results: \(queryResults)" )
            //println(((queryResults!.objectForKey("rate") as! NSArray)[0]).objectForKey("Rate") as! NSString)
            var arr = queryResults!.objectForKey("rate") as! NSArray
            //var rate = NSString
            var numberFormatter = NSNumberFormatter()
            var num: NSNumber
            var str: NSString
            for elem in arr {
                if let num = numberFormatter.numberFromString(elem.objectForKey("Rate") as! NSString as String) {
                    
                    str = (elem.objectForKey("Name") as! NSString).substringFromIndex(4)
                
                    curr += [(currency: str, value: num)]
                    
                    //println(num)
                } else {
                    var error  = "Errooooor"
                }
            }
            
        } else {
            var error = "No currencies downloaded."
        }
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return count(curr)
    }
    
    

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        //let cell = self.offersTable.dequeueReusableCellWithIdentifier("offerCell") as! RateCell
        
         cell.textLabel?.text = "1 USD = \(curr[indexPath.row].1) \(curr[indexPath.row].0) "
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
