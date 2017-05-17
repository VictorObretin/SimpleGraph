//
//  BarGraphsViewController.swift
//  SimpleGraph
//
//  Created by Victor Obretin on 2016-11-28.
//  Copyright © 2016 Victor Obretin. All rights reserved.
//

import UIKit

class BarGraphsViewController: PageItemViewController {
    
    @IBOutlet weak var backLineGraph: UILineGraphView!
    @IBOutlet weak var verticalBarsGraph: UIVerticalBarsGraphView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        resetViews()
    }
    
    internal func resetViews() {
        // Feeding Test Data
        let startingValues:Array<Float> = [0.3, 0.25, 0.15, 0.25, 0.3, 0.36, 0.4]
        let endingValues:Array<Float> = [0.6, 0.65, 0.8, 0.7, 0.75, 0.65, 0.7]
        verticalBarsGraph.setValues(endingValues: endingValues, startingValues: startingValues, animated: true)
        
        backLineGraph.setValues(values: [0.4, 0.45, 0.42, 0.6, 0.5, 0.56, 0.5, 0.52, 0.65], animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent //or default
    }
}
