//
//  MediaMasterTableViewController.swift
//  FUMCApp
//
//  Created by Andrew Branch on 11/14/14.
//  Copyright (c) 2014 FUMC Pensacola. All rights reserved.
//

import UIKit

class MediaMasterTableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let podcastURL = NSURL(string: "itms-pcast://itunes.apple.com/us/podcast/first-umc-of-pensacola-fl/id313924198?mt=2&uo=4")
    private let font = UIFont(name: "BebasNeue Bold", size: 30)
    private let labels = [NSAttributedString(string: "Bulletins", attributes: [NSKernAttributeName: 5]), NSAttributedString(string: "Witnesses", attributes: [NSKernAttributeName: 5]), NSAttributedString(string: "Sermons", attributes: [NSKernAttributeName: 5])]
    private let images = [UIImage(named: "bulletins-dark"), UIImage(named: "witnesses-dark"), UIImage(named: "sermons-dark")]
    
    private var bulletinsDataSource: BulletinsDataSource?
    private var witnessesDataSource: WitnessesDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        self.tableView.registerNib(UINib(nibName: "MediaMasterTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "mediaMasterTableViewCell")
    }
    
    override func viewWillAppear(animated: Bool) {
        if let indexPath = self.tableView.indexPathForSelectedRow() {
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.labels.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("mediaMasterTableViewCell", forIndexPath: indexPath) as MediaMasterTableViewCell

        cell.iconView!.image = self.images[indexPath.row]
        cell.label!.attributedText = self.labels[indexPath.row]
        if let font = self.font {
            cell.label!.font = font
        }
        
        return cell
    }

    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == 2) {
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            UIApplication.sharedApplication().openURL(podcastURL!)
        } else {
            self.performSegueWithIdentifier("mediaMasterCellSelection", sender: indexPath)
        }
    }


    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "mediaMasterCellSelection") {
            var tableViewController = segue.destinationViewController as MediaTableViewController
            var indexPath = sender as NSIndexPath
            switch (indexPath.item) {
                
                case 0:
                    if (self.bulletinsDataSource == nil) {
                        self.bulletinsDataSource = BulletinsDataSource(delegate: tableViewController)
                    }
                    tableViewController.dataSource = self.bulletinsDataSource!
                    break
                    
                case 1:
                    if (self.witnessesDataSource == nil) {
                        self.witnessesDataSource = WitnessesDataSource(delegate: tableViewController)
                    }
                    tableViewController.dataSource = self.witnessesDataSource!
                    break
                    
                default:
                    break
            }
        }
    }


}
