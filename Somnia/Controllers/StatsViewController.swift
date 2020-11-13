//
//  StatsViewController.swift
//  Somnia
//
//  Created by Juan Felipe Torres on 15/10/20.
//

import UIKit
import Charts
import Firebase

class StatsViewController: UIViewController {
    
    // Chart variables
    
    lazy var lineChartview: LineChartView = {
        let chartView = LineChartView()
        
        chartView.rightAxis.enabled = false
        chartView.leftAxis.labelTextColor = .white
        chartView.leftAxis.setLabelCount(10, force: false)
        chartView.leftAxis.axisLineColor = .white
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelTextColor = .white
        chartView.xAxis.axisLineColor = .white
        chartView.xAxis.setLabelCount(6, force: false)
        chartView.animate(xAxisDuration: 1.0)
        chartView.legend.textColor = .white
        return chartView
    }()
    
    
    // Sleep Stats Outlets
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var dailyAnalysisView: UIView!
    @IBOutlet weak var noAnalysisLabel: UILabel!
    @IBOutlet weak var deepHrsLabel: UILabel!
    @IBOutlet weak var lightHrsLabel: UILabel!
    @IBOutlet weak var remHrsLabel: UILabel!
    @IBOutlet weak var timeHrsLabel: UILabel!
    @IBOutlet weak var snorePerLabel: UILabel!
    @IBOutlet weak var totalBreathLabel: UILabel!
    
    @IBOutlet weak var deepView: UIView!
    @IBOutlet weak var lightView: UIView!
    @IBOutlet weak var remView: UIView!
    @IBOutlet weak var awakeView: UIView!
    @IBOutlet weak var snoreView: UIView!
    @IBOutlet weak var breathView: UIView!
    
    @IBOutlet weak var nightDateLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var sleepTimeLabel: UILabel!
    
    
    // Firebase
    
    let db = Firestore.firestore()
    
    static var closerAnalysis: Analysis = Analysis(nightDate: Date().addingTimeInterval(-10000000000000), duration: 0.0, totalEvents: 0, totalSnores: 0, snorePercentage: 0.0, wake: 0.0, light: 0.0, deep: 0.0, rem: 0.0, hourStage: [:])
    
    var listAnalysis: [Analysis] = []
    
    var yValues: [ChartDataEntry] = []
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
                
        transformData()
        print(yValues)
        
        setData(yVal: yValues)
        
        if StatsViewController.closerAnalysis.snorePercentage == 0 && StatsViewController.closerAnalysis.totalEvents == 0 && listAnalysis.count == 0 {
            print("hay nulo")
            deepView.isHidden = true
            lightView.isHidden = true
            remView.isHidden = true
            awakeView.isHidden = true
            snoreView.isHidden = true
            breathView.isHidden = true
            dailyAnalysisView.isHidden = true
            noAnalysisLabel.isHidden = false
            firstLabel.isHidden = true
            sleepTimeLabel.isHidden = true
            durationLabel.isHidden = true
            nightDateLabel.isHidden = true

        } else {
            deepView.isHidden = false
            lightView.isHidden = false
            remView.isHidden = false
            awakeView.isHidden = false
            snoreView.isHidden = false
            breathView.isHidden = false
            dailyAnalysisView.isHidden = false
            noAnalysisLabel.isHidden = true
            firstLabel.isHidden = false
            noAnalysisLabel.isHidden = false
            firstLabel.isHidden = true
            noAnalysisLabel.isHidden = false
            firstLabel.isHidden = false
            sleepTimeLabel.isHidden = false
            durationLabel.isHidden = false
            nightDateLabel.isHidden = false
            
            let formatter = DateFormatter()
            formatter.dateFormat = "E, MMM d"
            
            let hourString = formatter.string(from: StatsViewController.closerAnalysis.nightDate)
            nightDateLabel.text = hourString
            durationLabel.text = "\(StatsViewController.closerAnalysis.duration) hours"
            
            deepHrsLabel.text = "\(StatsViewController.closerAnalysis.deep) hrs."
            lightHrsLabel.text = "\(StatsViewController.closerAnalysis.light) hrs."
            remHrsLabel.text = "\(StatsViewController.closerAnalysis.rem) hrs."
            timeHrsLabel.text = "\(StatsViewController.closerAnalysis.wake) hrs."
            let percentage = round(StatsViewController.closerAnalysis.snorePercentage * 100)
            snorePerLabel.text = "\(percentage) %"
            totalBreathLabel.text = "\(StatsViewController.closerAnalysis.totalEvents)"
            
            dailyAnalysisView.addSubview(lineChartview)
            lineChartview.frame.size.width = dailyAnalysisView.frame.size.width - 50
            lineChartview.frame.size.height = dailyAnalysisView.frame.size.width - 50
            lineChartview.center = CGPoint(x: dailyAnalysisView.frame.size.width  / 2,
                                         y: dailyAnalysisView.frame.size.width / 2)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // loadAnalysis()
            
        print("closer analysis: \(StatsViewController.closerAnalysis)")
        
        dailyAnalysisView.layer.cornerRadius = 12
        deepView.layer.cornerRadius = 12
        lightView.layer.cornerRadius = 12
        remView.layer.cornerRadius = 12
        awakeView.layer.cornerRadius = 12
        snoreView.layer.cornerRadius = 12
        breathView.layer.cornerRadius = 12
        
        if StatsViewController.closerAnalysis.snorePercentage == 0 && StatsViewController.closerAnalysis.totalEvents == 0 && listAnalysis.count == 0 {
            print("hay nulo")
            deepView.isHidden = true
            lightView.isHidden = true
            remView.isHidden = true
            awakeView.isHidden = true
            snoreView.isHidden = true
            breathView.isHidden = true
            dailyAnalysisView.isHidden = true
            noAnalysisLabel.isHidden = false
            firstLabel.isHidden = true

        } else {
            deepView.isHidden = false
            lightView.isHidden = false
            remView.isHidden = false
            awakeView.isHidden = false
            snoreView.isHidden = false
            breathView.isHidden = false
            dailyAnalysisView.isHidden = false
            noAnalysisLabel.isHidden = true
            firstLabel.isHidden = false
            noAnalysisLabel.isHidden = false
            firstLabel.isHidden = false
            deepHrsLabel.text = "\(StatsViewController.closerAnalysis.deep) hrs."
            lightHrsLabel.text = "\(StatsViewController.closerAnalysis.light) hrs."
            remHrsLabel.text = "\(StatsViewController.closerAnalysis.rem) hrs."
            timeHrsLabel.text = "\(StatsViewController.closerAnalysis.wake) hrs."
            let percentage = StatsViewController.closerAnalysis.snorePercentage * 100
            snorePerLabel.text = "\(percentage) %"
            totalBreathLabel.text = "\(StatsViewController.closerAnalysis.totalEvents)"
        }
        
    }
    
    func loadAnalysis() {
        
        if let id = Auth.auth().currentUser?.uid {
            
            db.collection(K.FStore.analysisCollection)
                .whereField(K.FStore.createdByField, isEqualTo: id)
                .getDocuments { (querySnapshot, error) in
                    
                    self.listAnalysis = []
                                        
                    if let e = error {
                        print("There was an issue retrieving data from Firestore. \(e)")
                    } else {
                        for document in querySnapshot!.documents {
                            
                            let data = document.data()
                                                                                    
                            let deep = data["deep"] as? Double
                            let duration = data["duration"] as? Double
                            let hourStage = data["hourStage"] as? [String: String]
                            let light = data["light"] as? Double
                            let nightDate = data["nightDate"] as? Timestamp
                            let rem = data["rem"] as? Double
                            let snorePer = data["snorePercentage"] as? Double
                            let totalEvents = data["totalEvents"] as? Int
                            let totalSnores = data["totalSnores"] as? Int
                            let wake = data["wake"] as? Double
                                
                            if let date = nightDate?.dateValue() {
                                
                                let newAnalysis = Analysis(nightDate: date, duration: duration!, totalEvents: totalEvents!, totalSnores: totalSnores!, snorePercentage: snorePer!, wake: wake!, light: light!, deep: deep!, rem: rem!, hourStage: hourStage!)
                                
                                self.listAnalysis.append(newAnalysis)
                                                                
                            }
                        }
                        StatsViewController.closerAnalysis = self.getCloserAnalysis()
                        print(StatsViewController.closerAnalysis)
                    }
                }
        }
    }
    
    func setData(yVal: [ChartDataEntry]) {
        let set = LineChartDataSet(entries: yVal, label: "Hour Stage")
        
        set.drawCirclesEnabled = false
        set.setColor(UIColor(named: "Green")!)
        set.lineWidth = 2
        
        let data = LineChartData(dataSet: set)
        data.setDrawValues(false)
        lineChartview.data = data
    }
    
    func getCloserAnalysis()-> Analysis {
        var menor = -1.0
        var analisis = Analysis(nightDate: Date().addingTimeInterval(-10000000000000), duration: 0.0, totalEvents: 0, totalSnores: 0, snorePercentage: 0.0, wake: 0.0, light: 0.0, deep: 0.0, rem: 0.0, hourStage: [:])
        for i in listAnalysis {
            if(menor < i.nightDate.timeIntervalSince1970) {
                menor = i.nightDate.timeIntervalSince1970
                analisis = i
            }
        }
        return analisis
    }
    
    func transformData() {
        
        var arreglo = [Int]()
        for i in StatsViewController.closerAnalysis.hourStage {
            arreglo.append(Int(i.key)!)
        }
        arreglo.sort()
                
        for i in arreglo {
            var value = 20.0
            var hour = Double(Calendar.current.component(.hour, from: StatsViewController.closerAnalysis.nightDate)) + Double(i) - 1
            
            let llave = StatsViewController.closerAnalysis.hourStage[String(i)]
            
            if llave == "WAKE" {
                value = 80.0
            }
            else if llave == "LIGHT" {
                value = 60.0
            } else if llave == "DEEP" {
                value = 40.0
            }
            
            if hour >= 24{
                hour = hour - 24
            }
            
            yValues.append(ChartDataEntry(x: hour, y: value))
            yValues.append(ChartDataEntry(x: hour + 1, y: value))
        }
    }
    
}

extension StatsViewController: ChartViewDelegate {
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
}
