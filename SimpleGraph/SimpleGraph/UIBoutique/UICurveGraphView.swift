//
//  UICurveGraphView.swift
//  SimpleGraph
//
//  Created by Victor Obretin on 2017-03-03.
//  Copyright © 2017 Victor Obretin. All rights reserved.
//

import UIKit

@IBDesignable
class UICurveGraphView: UILineGraphView {
    
    override internal func getLinePath(points: Array<CGPoint>)->UIBezierPath {
        let linePath: UIBezierPath = UIBezierPath()
        
        if (points.count == 0) {
            return linePath
        }
        
        let cubicCurveAlgorithm = CubicCurveAlgorithm()
        let controlPoints = cubicCurveAlgorithm.controlPointsFromPoints(dataPoints: points)
        
        for i in 0 ..< points.count {
            let point = points[i];
            
            if i==0 {
                linePath.move(to: point)
            } else {
                let segment = controlPoints[i-1]
                linePath.addCurve(to: point, controlPoint1: segment.controlPoint1, controlPoint2: segment.controlPoint2)
            }
        }
        
        return linePath;
    }
    
    override internal func getInterfaceBuilderData()->Array<Float> {
        let testData:Array<Float> = [0.5, 0.5, 0.55, 0.45, 0.15, 0.0, 0.2, 0.7, 0.8, 0.75, 1.0]
        return testData
    }
}
