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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.barTintColor = UIColor.orangeColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        let games = ["Game 1", "Game 2", "Game 3", "Game 4", "Game 5"]
        let scores = [40.0, 60.0, 70.0, 80.0, 50.0]
        
        setChart(games, values: scores)
    
    }

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
        
        lineChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .EaseInBounce)
        
        
    
    }

    
}
