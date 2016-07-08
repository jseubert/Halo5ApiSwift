//
//  ViewController.swift
//  Halo5API
//
//  Created by John  Seubert on 7/7/16.
//  Copyright © 2016 John Seubert. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var responseLabel: UILabel!
    
    @IBAction func buttonPressed(sender: UIButton) {
        self.responseLabel.text = "Loading"
        let client = Halo5Client.sharedInstance
        client.getCampaignMissions { (success, message, missions) in
            //Update UI on MainQueue
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.responseLabel.text = missions?.description
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

