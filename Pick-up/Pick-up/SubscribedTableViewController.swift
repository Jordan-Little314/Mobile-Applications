//
//  SubscribedTableViewController.swift
//  Pick-up
//
//  Created by Jordan Little on 4/29/17.
//  Copyright © 2017 Jordan Little. All rights reserved.
//

import UIKit

class SubscribedTableViewController: UITableViewController {
    
    //var managedObjectContext: NSManagedObjectContext!
    var appDelegate: AppDelegate!
    
    var currentAnnotations: [PUAnnotation] = []
    var subscribedEvents: [PUAnnotation] = []
    var eventSelected: PUAnnotation!
    var editIndex: Int!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let rootVC = self.navigationController!.topViewController
        if (rootVC?.isKind(of: ViewController.self))! {
            performSegue(withIdentifier: "unwindFromSubsribedEvents", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return subscribedEvents.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subscribeCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = subscribedEvents[indexPath.row].title

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        // let currentCell = tableView.cellForRow(at: indexPath!) as UITableViewCell!
        editIndex = indexPath?.row
        eventSelected = subscribedEvents[(editIndex)!]
        performSegue(withIdentifier: "toInformation", sender: self)
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toInformation") {
            let ViewController = segue.destination as! InformationViewController
            ViewController.puEvent = self.eventSelected
            ViewController.subscribedEvents = self.subscribedEvents
            ViewController.currentAnnotations = self.currentAnnotations
        }
    }
    
    @IBAction func unwindFromInformation (sender: UIStoryboardSegue) {
        let ViewController = sender.source as! InformationViewController
        self.subscribedEvents = ViewController.subscribedEvents
        self.currentAnnotations = ViewController.currentAnnotations
        self.tableView.reloadData()
    }

}
