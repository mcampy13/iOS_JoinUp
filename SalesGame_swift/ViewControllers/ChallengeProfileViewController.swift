//
//  ChallengeProfileViewController.swift
//  SalesGame_swift
//
//  Created by Robert Rock on 12/17/15.
//  Copyright © 2015 Akshay. All rights reserved.
//

import UIKit
import Charts

class ChallengeProfileViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var lineChartView: LineChartView!
    
    var playerGames: NSMutableArray = NSMutableArray()
    var recentScores: NSMutableArray = NSMutableArray()
    var games: [String]!
    var opponents: NSMutableArray = NSMutableArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.barTintColor = UIColor.orangeColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        getTotalGamesPlayed()
        getOpponents()
    }

    /*
     * setChart will provide all initializers & settings for the graph, including the legend
     */
    func setChart(dataPoints: [String], values: [Double]) {
        self.lineChartView.noDataText = "You have no recent games."
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "Scores")
        let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
        lineChartView.data = lineChartData
        lineChartView.rightAxis.labelCount = 0
        
        lineChartView.animate(xAxisDuration: 1.0, yAxisDuration: 2.0, easingOption: .EaseInBounce)
    
    } // END of setChart([String], [Double])
    
    
    /*
     * getTotalGamesPlayed queries Parse for the current user's 5 most recent games with
     *  index[0] being the most recent.
     */
    func getTotalGamesPlayed(){
        let queryGame = PFQuery(className: "Game")
        queryGame.whereKey("player", equalTo: PFUser.currentUser()!)
        queryGame.limit = 5
        queryGame.findObjectsInBackgroundWithBlock { (success, error) -> Void in
            if error == nil {                
                let temp: NSArray = success! as NSArray
                
                self.playerGames = temp.mutableCopy() as! NSMutableArray
                self.getScores()
            } else{
                print("Error in getTotalGamesPlayed: \(error)")
            }
        }
    } // END of getTotalGamesPlayed()
    
    
    /*
     * getScores will retrieve the score values from the prior Game Objects queried for in getTotalGamesPlayed()
     */
    func getScores() {
        for var i=0; i < self.playerGames.count; i++ {
            if self.playerGames.objectAtIndex(i).valueForKey("score") != nil {
                let rs: Double = Double(self.playerGames[i].valueForKey("score")! as! NSNumber)
                self.recentScores.addObject(rs)
            }
        }
        
        games = ["G1", "G2", "G3", "G4", "G5"]
        let scores = [self.recentScores[0], self.recentScores[1], self.recentScores[2], self.recentScores[3], self.recentScores[4]]
        print("recentScores: \(self.recentScores)")
        
        /* Call setChart w/ newly acquired values */
        self.setChart(games, values: scores as! [Double])
        
    } // END of getScores()
    
    
    func getOpponents() {
        let query = PFQuery(className: "Challenge")
        query.whereKey("challenger", equalTo: PFUser.currentUser()!)
        query.limit = 10
        query.findObjectsInBackgroundWithBlock { (challenges, error) -> Void in
            if error == nil {
                let temp: NSArray = challenges! as NSArray
                
                self.opponents = temp.mutableCopy() as! NSMutableArray
                
            } else {
                print("Error in queryObjectsInBackground for Challenge: \(error)")
            }
        }
    }
    
    
    //==========================================================================================================================
    
    // MARK: TableDatasource & Delegate
    
    //==========================================================================================================================
    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = self.opponentTableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
//        
//        let obj: PFObject = self.opponents.objectAtIndex(indexPath.row) as! PFObject
//        cell.textLabel?.text = "opponent"
//        //cell.username?.text = obj["opponent"]?.valueForKey("username") as? String
//        
//        let opponentFile = obj["profilePic"] as? PFFile
//        opponentFile?.getDataInBackgroundWithBlock{ (imageData, error) -> Void in
//            if error == nil {
//                if let imageData = imageData {
//                    cell.opponentImage.image = UIImage(data: imageData)
//                }
//            } else{
//                print("Error in opponentFile: \(error)")
//            }
//        }
//        return cell
//    }
    
}
