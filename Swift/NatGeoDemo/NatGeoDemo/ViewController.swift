//
//  ViewController.swift
//  NatGeoDemo
//
//  Created by Taha Abbasi on 2/2/16.
//  Copyright © 2016 TahaAbbasi. All rights reserved.
//

import UIKit
import MediaPlayer
import AVKit
import Charts
import SnapKit

class ViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var barChartView: BarChartView!
    
    var playerController = AVPlayerViewController()
    var aviPlayer = AVPlayer()
    let landingTopView : UIImageView = UIImageView()
    
    
    var emissionOffset = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        barChartView.delegate = self
        
        emissionOffset = ["Earth Day", "Other Races"]
        let carbonEmission = [30.0, 150]
        
        setChart(emissionOffset, values: carbonEmission)
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
        
        let image = UIImage(named: "NatGeoDemo")
        
        landingTopView.image = image
        
        landingTopView.frame = CGRectMake(0, 20, self.view.bounds.width, self.view.bounds.height / 2)
        
        
        
        let videoURL : NSURL = NSBundle.mainBundle().URLForResource("NatGeo Slider", withExtension: "mp4")!
        aviPlayer = AVPlayer(URL: videoURL)
        
        playerController.player = aviPlayer
        playerController.showsPlaybackControls = false
        playerController.videoGravity = AVLayerVideoGravityResizeAspectFill
        playerController.view.frame = self.view.frame
        
        
        self.view.insertSubview(playerController.view, atIndex: 0)
        playerController.view.addSubview(landingTopView)
        
        aviPlayer.play()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("loopVideo:"), name: AVPlayerItemDidPlayToEndTimeNotification, object: aviPlayer.currentItem)
        
        
    }
    
    func loopVideo(notification : NSNotification) {
        let avpItem : AVPlayerItem = notification.object as! AVPlayerItem
        avpItem.seekToTime(kCMTimeZero)
        aviPlayer.play()
    }
    
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        barChartView.noDataText = "Loading Average Emmission data"
        
        var dataEntries : [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
            
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Individual Runner Carbon Emission")
        let chartData = BarChartData(xVals: emissionOffset, dataSet: chartDataSet)
        barChartView.data = chartData
        
        barChartView.legend.textColor = UIColor.whiteColor()
        
        
        
        
        barChartView.descriptionText = ""
        
        chartDataSet.colors = [UIColor(red: 0/255, green: 100/255, blue: 0/255, alpha: 1),
            UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)]
        
        
        
        
        barChartView.translatesAutoresizingMaskIntoConstraints = true
        
        let barChartWidth : CGFloat = self.view.bounds.width - (self.view.bounds.width * (5/100))
        let barChartHeight : CGFloat = (self.view.bounds.height / 2) - (self.view.bounds.height / 2 * (5/100))
        let barChartXOffset : CGFloat = self.view.bounds.width * ((5/100) / 2)
        let barChartYOffset : CGFloat = (self.view.bounds.height - (self.view.bounds.height / 2)) + 5
        
        
        chartDataSet.valueTextColor = UIColor.whiteColor()
        
        print((self.view.bounds.width * (5/100)))
        print(self.view.bounds.width * ((5/100) / 2))
        
        barChartView.frame = CGRectMake(barChartXOffset, barChartYOffset, barChartWidth, barChartHeight)
        
        
        
        barChartView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
        
        barChartView.xAxis.labelPosition = .Bottom
        barChartView.xAxis.labelTextColor = UIColor.whiteColor()
        
        barChartView.animate(xAxisDuration: 3.0, yAxisDuration: 3.0, easingOption: .EaseInBounce)
        
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }


}

