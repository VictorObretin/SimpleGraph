//
//  LineGraphsViewController.swift
//  SimpleGraph
//
//  Created by Victor Obretin on 2016-11-28.
//  Copyright © 2016 Victor Obretin. All rights reserved.
//

import UIKit

class LineGraphsViewController: PageItemViewController {
    
    @IBOutlet weak var firstLineGraph: UILineGraphView!
    @IBOutlet weak var secondLineGraph: UILineGraphView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        resetViews()
    }
    
    internal func resetViews() {
        // Feeding Test Data
        firstLineGraph.setValues(values: [0.5, 0.55, 0.5, 0.6, 0.1, 0.35, 0.3, 0.7, 0.8, 0.75, 0.9])
        secondLineGraph.setValues(values: [0.2, 0.3, 0.35, 0.45, 0.5, 0.45, 0.52, 0.55, 0.65, 0.6, 0.65], animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent //or default
    }
}
