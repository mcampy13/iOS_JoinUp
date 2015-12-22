//
//  ProfileViewController.swift
//  SalesGame_swift
//
//  Created by Robert Rock on 10/20/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import UIKit
import Charts

class ProfileViewController: UIViewController, UINavigationControllerDelegate {

    
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var departmentLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    
    @IBOutlet weak var pieChartView: PieChartView!
    var months: [String]!
    var wld: [String]!
    
    var playerGames: NSMutableArray = NSMutableArray()
    
    @IBOutlet weak var labelTotalGamesAmount: UILabel!
    @IBOutlet weak var labelWinsAmount: UILabel!
    @IBOutlet weak var labelLossesAmount: UILabel!
    @IBOutlet weak var labelDrawsAmount: UILabel!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var gamesButton: UIButton!
    @IBOutlet weak var badgesButton: UIButton!
    @IBOutlet weak var friendButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    
    var userLevel: Int?
    
    var pic:AnyObject?
    var wins: Int = 0
    var losses: Int = 0
    var noStatus: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //NSThread .detachNewThreadSelector("showhud", toTarget: self, withObject: nil)
        
        menuButton.target = self.revealViewController()
        menuButton.action = Selector("revealToggle:")
        //self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        
        UtilityClass.setMyViewBorder(img, withBorder: 0, radius: 75)
        self.displayUserImg()
        
        let currentUser = PFUser.currentUser()!.objectForKey("username")
        let currentDepartment = PFUser.currentUser()!.objectForKey("department")
        let level = PFUser.currentUser()!.objectForKey("level")
        self.userLevel = level as? Int
        self.usernameLabel.text = currentUser as? String
        self.departmentLabel.text = currentDepartment as? String
        levelLabel?.text = String(format: "%d", self.userLevel!)
        
        getTotalGamesPlayed()
        
//        let unitsSold = [70.0, 20.0, 10.0]
        
//        wld = ["Wins", "Losses", "Draws"]
//        let stats = [self.wins, self.losses, self.noStatus]
//        print("stats: \(stats)")
//        
//        setChart(wld, values: unitsSold)
    
    } // END of viewDidLoad()
    
    
    func setChart(dataPoints: [String], values:[Double]) {
        pieChartView.noDataText = "Must play a game before data can be displayed."
        pieChartView.descriptionText = ""
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: nil)
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        pieChartView.data = pieChartData
        pieChartView.usePercentValuesEnabled = true
        pieChartView.animate(xAxisDuration: 2.0, easingOption: .EaseInCirc)
        //pieChartView.backgroundColor = UIColor.lightGrayColor()
                
        /* percent value of pieChart hole; default is 0.5 (half of the chart) */
        pieChartView.holeRadiusPercent = 0.2
        pieChartView.transparentCircleRadiusPercent = 0.3

        pieChartData.setValueTextColor(UIColor.whiteColor())
        
        var colors: [UIColor] = []
        
        for j in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        
        //pieChartDataSet.colors = colors
        
        /* Choices are: .liberty, .joyful, .colorful, .pastel, .vordiplom */
        pieChartDataSet.colors = ChartColorTemplates.colorful()
        
        /* Properties for the graph's legend */
        let legend = pieChartView.legend
        legend.position = .RightOfChartCenter
        legend.textColor = UIColor.darkGrayColor()
        
        let pFormatter = NSNumberFormatter()
        pFormatter.numberStyle = .PercentStyle
        pFormatter.percentSymbol = "%"
        pFormatter.multiplier = 1
        pieChartData.setValueFormatter(pFormatter)
        
        
        
    } // END of setChart()
    
    
    /*
     * Retrieve user's profile pic and display it.  Allows user to change img
     */
    func displayUserImg() {
        let query = PFQuery.getUserObjectWithId(PFUser.currentUser()!.objectId!)
        
        let file: PFFile = query?.valueForKey("profilePic") as! PFFile
        print("file \(file)")
        file.getDataInBackgroundWithBlock({
            (imageData, error) -> Void in
            if error == nil {
                let Image: UIImage = UIImage(data: imageData!)!
                print("Image \(Image)")
                self.img.image = Image
                hideHud(self.view)
            } else {
                print("Error \(error)")
            }
        })

    } // END of displayUserImg()
    
    func getTotalGamesPlayed(){
        let queryGame = PFQuery(className: "Game")
        queryGame.whereKey("player", equalTo: PFUser.currentUser()!)
        queryGame.findObjectsInBackgroundWithBlock { (success, error) -> Void in
            if error == nil {
                self.labelTotalGamesAmount?.text = String(success!.count)
                
                let temp: NSArray = success! as NSArray
                
                self.playerGames = temp.mutableCopy() as! NSMutableArray
                self.getWLD()
            } else{
                print("Error in getTotalGamesPlayed: \(error)")
            }
        }
    }
    
    func getWLD() {
        
        for var i=0; i < self.playerGames.count; i++ {
            if self.playerGames.objectAtIndex(i).valueForKey("WLD") as? String == "W" {
                wins++
            } else if self.playerGames.objectAtIndex(i).valueForKey("WLD") as? String == "L" {
                losses++
            } else {
                noStatus++
            }
        }
        
        wld = ["Wins", "Losses", "Draws"]
        let stats = [Double(self.wins), Double(self.losses), Double(self.noStatus)]
        print("stats: \(stats)")
        
        self.setChart(wld, values: stats)
        
        print("You won \(wins) games.")
        print("You lost \(losses) games.")
        print("You don't have any status for \(noStatus) games.")
        
        self.labelWinsAmount?.text = String(wins)
        self.labelLossesAmount?.text = String(losses)
    }
    
    
    //==========================================================================================================================
    
    // MARK: Navigation
    
    //==========================================================================================================================
    
    


    //==========================================================================================================================
    
    // MARK: Actions
    
    //==========================================================================================================================
    
    @IBAction func homeButton(sender: AnyObject) {
        let homeVC = self.storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as? HomeViewController
        self.navigationController?.pushViewController(homeVC!, animated: true)
    }
    
    
    @IBAction func logOutButton(sender: AnyObject) {
        PFUser.logOutInBackground()
        self.navigationController!.popToRootViewControllerAnimated(true)
    }
    

    @IBAction func unwindToProfile(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? EditProfileViewController, department = sourceViewController.newDept, profilePic = sourceViewController.newProfilePFImage {
            
            let user = PFUser.currentUser()
            
            // If department is NOT empty, user input text & wants to save new department
            user!["department"] = department
            user!["profilePic"] = profilePic
            
            user?.saveInBackgroundWithBlock { (success, error) -> Void in
                if error == nil {
                    print("unwindToProfile done, new profile data was saved")
                } else{
                    print("Error in unwindToProfile b/c of saving department \(error)")
                }
            }
            
            self.departmentLabel?.text = department
            self.displayUserImg()

        }
    } // END of unwindToProfile
    
    
    //==========================================================================================================================
    
    // MARK: Progress hud display methods
    
    //==========================================================================================================================
    
    func showhud() {
        showHud(self.view)
    }

}
