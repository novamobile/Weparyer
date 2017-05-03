//
//  PayerADTableViewController.swift
//  WeParyer
//
//  Created by Jeccy on 16/7/5.
//  Copyright © 2016年 Jeccy. All rights reserved.
//

import UIKit

class PayerADTableViewController: UITableViewController,IMStrandTableViewAdapterDelegate {

    var positions : IMStrandPosition!
    var strandAdapter : IMStrandTableViewAdapter!
    
    let tableData = [
        "a",
        "b",
        "c",
        "d",
        "e",
    ]
    
//    1464419642369
    override func viewDidLoad() {
        super.viewDidLoad()

        self.positions = IMStrandPosition()
        self.positions.addFixedIndexPath(NSIndexPath(forRow: 2, inSection: 0))
        self.positions.enableRepeatingPositionsWithStride(4)
        
        self.strandAdapter = IMStrandTableViewAdapter(tableView: self.tableView, placementId: 1466905009032, adPositioning: self.positions, tableViewCellClass: UITableViewCell.classForCoder())
        
        self.tableView.reloadData()
        self.strandAdapter.load()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.tableData.count
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "identtifier_ad"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: identifier)
        }
        
        cell?.textLabel?.text = self.tableData[indexPath.row]
        
        return cell!
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
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
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - IMStrandTableViewAdapterDelegate
    func strandTableViewAdapter(strandTableViewAdapter: IMStrandTableViewAdapter!, adsRemovedFromIndexPaths indexPaths: [AnyObject]!) {
        print("IMStrandTableViewAdapterDelegate",#function)
    }
    
    func strandTableViewAdapter(strandTableViewAdapter: IMStrandTableViewAdapter!, adAtIndexPathDidPresentScreen indexPath: NSIndexPath!) {
        print("IMStrandTableViewAdapterDelegate",#function)
    }
    
    func strandTableViewAdapter(strandTableViewAdapter: IMStrandTableViewAdapter!, adAtIndexPathWillDismissScreen indexPath: NSIndexPath!) {
        print("IMStrandTableViewAdapterDelegate",#function)
    }
    
    func strandTableViewAdapter(strandTableViewAdapter: IMStrandTableViewAdapter!, adAtIndexPathDidDismissScreen indexPath: NSIndexPath!) {
        print("IMStrandTableViewAdapterDelegate",#function)
    }
    
    func strandTableViewAdapter(strandTableViewAdapter: IMStrandTableViewAdapter!, adDidFinishLoadingAtIndexPath indexPath: NSIndexPath!) {
        print("IMStrandTableViewAdapterDelegate",#function)
    }
    
    func strandTableViewAdapter(strandTableViewAdapter: IMStrandTableViewAdapter!, adAtIndexPathWillPresentScreen indexPath: NSIndexPath!) {
        print("IMStrandTableViewAdapterDelegate",#function)
    }
    
    func strandTableViewAdapter(strandTableViewAdapter: IMStrandTableViewAdapter!, userWillLeaveApplicationFromAdAtIndexPath indexPath: NSIndexPath!) {
        print("IMStrandTableViewAdapterDelegate",#function)
    }
    
    func strandTableViewAdapter(strandTableViewAdapter: IMStrandTableViewAdapter!, adDidFailToLoadAtIndexPath indexPath: NSIndexPath!, withError error: IMRequestStatus!) {
        print("IMStrandTableViewAdapterDelegate",#function)
    }

}
