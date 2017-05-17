//
//  UIVerticalBarsGraphView.swift
//  SimpleGraph
//
//  Created by Victor Obretin on 2017-03-08.
//  Copyright © 2017 Victor Obretin. All rights reserved.
//

import UIKit

@IBDesignable
class UIVerticalBarsGraphView: UIView {
    
    @IBInspectable var topColor: UIColor = UIColor.white
    @IBInspectable var middleColor: UIColor = UIColor.white
    @IBInspectable var bottomColor: UIColor = UIColor.white
    
    @IBInspectable var lineWidth: CGFloat = 2.0
    @IBInspectable var lineRoundCaps: Bool = true
    @IBInspectable var animationDuration: Double = 0.5
    @IBInspectable var animationDelay: Double = 0.5
    @IBInspectable var animationIndividualDelay: Double = 0.1
    
    var gradientLayer: CAGradientLayer?
    var barsLayer: CAShapeLayer?
    
    var barsStartingValues: Array<Float>?
    var barsEndingValues: Array<Float>?
    
    private var _shouldAnimate: Bool = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupComponent()
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        if (_shouldAnimate) {
            animateBars()
        }
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setValues(endingValues: getInterfaceBuilderEndingValues(), startingValues: getInterfaceBuilderStartingValues(), animated: false)
    }
    
    internal func setupComponent() {
        drawGradient()
        drawBars()
    }
    
    func setValues(endingValues: Array<Float>? = nil, startingValues: Array<Float>? = nil, animated: Bool = true) {
        _shouldAnimate = animated
        
        let startingValuesCount: Int = startingValues == nil ? 0 : startingValues!.count
        let endingValuesCount: Int = endingValues == nil ? 0 : endingValues!.count
        let maxCount: Int = max(startingValuesCount, endingValuesCount)
        
        if (maxCount == 0) {
            return
        }
        
        barsStartingValues = [Float](repeatElement(0.0, count: maxCount))
        if (startingValuesCount > 0) {
            for i in 0 ..< startingValuesCount {
                barsStartingValues?[i] = startingValues![i]
            }
        }
        
        barsEndingValues = [Float](repeatElement(1.0, count: maxCount))
        if (endingValuesCount > 0) {
            for i in 0 ..< endingValuesCount {
                barsEndingValues?[i] = endingValues![i]
            }
        }
        
        setupComponent()
        
        if (animated) {
            animateBars()
        }
    }
    
    private func drawGradient() {
        if (gradientLayer == nil) {
            gradientLayer = CAGradientLayer()
            self.layer.addSublayer(gradientLayer!)
        }
        
        gradientLayer?.frame = getGraphBounds()
        gradientLayer?.colors = [topColor.cgColor, topColor.cgColor, middleColor.cgColor, bottomColor.cgColor, bottomColor.cgColor]
        gradientLayer?.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer?.endPoint = CGPoint(x: 0.0, y: 1.0)
    }
    
    private func drawBars() {
        if (gradientLayer == nil) {
            return
        }
        
        if (barsLayer == nil) {
            barsLayer = CAShapeLayer()
            gradientLayer?.mask = barsLayer!
        }
        
        barsLayer?.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        if (lineWidth <= 0 || barsStartingValues == nil || barsStartingValues?.count == 0 || barsEndingValues == nil || barsEndingValues?.count == 0) {
            return
        }
        
        let startingPointsArray: Array<CGPoint> = getPointsArray(values: barsStartingValues!, displacementX:  self.bounds.width / 2.0, displacementY:  self.bounds.height / 2.0)
        let endingPointsArray: Array<CGPoint> = getPointsArray(values: barsEndingValues!, displacementX:  self.bounds.width / 2.0, displacementY:  self.bounds.height / 2.0)
        
        let valuesCount: Int = startingPointsArray.count
        for i in 0 ..< valuesCount {
            addBarBetweenPoints(startingPoint: startingPointsArray[i], endingPoint: endingPointsArray[i])
        }
    }
    
    internal func addBarBetweenPoints(startingPoint: CGPoint, endingPoint: CGPoint) {
        let barLayer: CAShapeLayer = CAShapeLayer()
        
        let linePath: UIBezierPath = UIBezierPath()
        linePath.move(to: startingPoint)
        linePath.addLine(to: endingPoint)
        
        barLayer.frame = barsLayer!.bounds
        barLayer.path = linePath.cgPath
        barLayer.lineWidth = lineWidth
        barLayer.fillColor = UIColor.clear.cgColor
        barLayer.strokeColor = UIColor.white.cgColor
        barLayer.lineJoin = kCALineJoinRound
        barLayer.lineCap = lineRoundCaps ? kCALineCapRound : kCALineCapButt
        
        barsLayer?.addSublayer(barLayer)
    }
    
    internal func animateBars() {
        let growLineAnimation: CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        growLineAnimation.fromValue = 0.0
        growLineAnimation.toValue = 1.0
        growLineAnimation.beginTime = CACurrentMediaTime() + animationDelay
        growLineAnimation.duration = animationDuration
        growLineAnimation.repeatCount = 0
        growLineAnimation.fillMode = kCAFillModeForwards;
        growLineAnimation.isRemovedOnCompletion = false;
        growLineAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        barsLayer?.sublayers?.forEach {
            let barLayer: CAShapeLayer? = $0 as? CAShapeLayer
            
            if (barLayer != nil) {
                barLayer?.strokeEnd = 0.0
                barLayer?.removeAllAnimations()
                barLayer?.add(growLineAnimation, forKey: "strokeEnd")
                
                growLineAnimation.beginTime += animationIndividualDelay
            }
        }
    }
    
    private func getGraphBounds()->CGRect {
        var graphBounds: CGRect = self.bounds
        
        graphBounds.origin.x -= graphBounds.size.width / 2.0
        graphBounds.origin.y -= graphBounds.size.height / 2.0
        graphBounds.size.width *= 2.0
        graphBounds.size.height *= 2.0
        
        return graphBounds
    }
    
    private func getPointsArray(values: Array<Float>, displacementX: CGFloat = 0.0, displacementY: CGFloat = 0.0)->Array<CGPoint> {
        var pointsArray: Array<CGPoint> = Array<CGPoint>()
        
        if (values.count == 0) {
            return pointsArray
        }
        
        let maxX: CGFloat = bounds.size.width
        let maxY: CGFloat = bounds.size.height
        let xIntervalsCount: Int = values.count + 1
        let xInterval: CGFloat = maxX / CGFloat(xIntervalsCount)
        
        let adjustedDisplacementX: CGFloat = displacementX + xInterval
        
        for i in 0 ... values.count-1 {
            let point: CGPoint = CGPoint(x: adjustedDisplacementX + CGFloat(i) * xInterval, y: displacementY + CGFloat(1.0 - values[i]) * maxY)
            pointsArray.append(point)
        }
        
        return pointsArray
    }
    
    internal func getInterfaceBuilderStartingValues()->Array<Float> {
        let testData:Array<Float> = [0.3, 0.25, 0.15, 0.25, 0.3, 0.36, 0.4]
        return testData
    }
    
    internal func getInterfaceBuilderEndingValues()->Array<Float> {
        let testData:Array<Float> = [0.6, 0.65, 0.8, 0.7, 0.75, 0.65, 0.7]
        return testData
    }
}
