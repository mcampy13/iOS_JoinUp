//
//  SettingViewController.swift
//  SalesGame_swift
//
//  Created by Akuma on 9/13/15.
//  Copyright (c) 2015 Akuma. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var switchTimed: UISwitch?
    @IBOutlet weak var switchSound: UISwitch?
    @IBOutlet weak var switchVibrate: UISwitch?

//==========================================================================================================================

// MARK: Life Cycle methods

//==========================================================================================================================
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switchTimed?.tag = 1
        switchSound?.tag = 2
        switchVibrate?.tag = 3
        
        switchTimed?.addTarget(self, action: Selector("stateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        switchSound?.addTarget(self, action: Selector("stateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        switchVibrate?.addTarget(self, action: Selector("stateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        
        if(NSUserDefaults.standardUserDefaults().valueForKey(kTimer) as! String  == "YES")
        {
            switchTimed?.setOn(true, animated: false)
        }
        else if(NSUserDefaults.standardUserDefaults().valueForKey(kTimer) as! String  == "NO")
        {
            switchTimed?.setOn(false, animated: false)
        }
        if(NSUserDefaults.standardUserDefaults().valueForKey(kSound) as! String  == "YES")
        {
            switchSound?.setOn(true, animated: false)
        }
        else if (NSUserDefaults.standardUserDefaults().valueForKey(kTimer) as! String  == "NO")
        {
            switchSound?.setOn(false, animated: false)
        }
        if(NSUserDefaults.standardUserDefaults().valueForKey(kVibrate) as! String  == "YES")
        {
            switchVibrate?.setOn(true, animated: false)
        }
        else if (NSUserDefaults.standardUserDefaults().valueForKey(kVibrate) as! String  == "NO")
        {
            switchVibrate?.setOn(false, animated: false)
        }

        // Do any additional setup after loading the view.
    }

    func stateChanged(switchState: UISwitch) {
        if switchState.on
        {
            if switchState == switchTimed
            {
                NSUserDefaults.standardUserDefaults().setValue("YES" , forKey: kTimer)
            }
            if switchState == switchSound
            {
                NSUserDefaults.standardUserDefaults().setValue("YES" , forKey: kSound)
            }
            if switchState == switchVibrate
            {
                NSUserDefaults.standardUserDefaults().setValue("YES" , forKey: kVibrate)
            }
        }
        else
        {
            if switchState == switchTimed
            {
                NSUserDefaults.standardUserDefaults().setValue("NO" , forKey: kTimer)
            }
            if switchState == switchSound
            {
                NSUserDefaults.standardUserDefaults().setValue("NO" , forKey: kSound)
            }
            if switchState == switchVibrate
            {
                NSUserDefaults.standardUserDefaults().setValue("NO" , forKey: kVibrate)
            }
        }
    }
    
    
    @IBAction func btnBackTap(sender: UIButton)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    



}
