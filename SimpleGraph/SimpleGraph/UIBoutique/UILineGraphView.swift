//
//  UILineGraphView.swift
//  SimpleGraph
//
//  Created by Victor Obretin on 2017-03-07.
//  Copyright © 2017 Victor Obretin. All rights reserved.
//

import UIKit

@IBDesignable
class UILineGraphView: UIView {
    
    @IBInspectable var topColor: UIColor = UIColor.white
    @IBInspectable var middleColor: UIColor = UIColor.white
    @IBInspectable var bottomColor: UIColor = UIColor.white
    
    @IBInspectable var lineWidth: CGFloat = 2.0
    @IBInspectable var lineRoundCaps: Bool = true
    @IBInspectable var animationDuration: Double = 1.0
    @IBInspectable var animationDelay: Double = 0.5
    
    @IBInspectable var showPoints: Bool = true
    @IBInspectable var pointsDiameter: CGFloat = 6
    @IBInspectable var pointsColor: UIColor = UIColor.white
    @IBInspectable var pointsLineWidth: CGFloat = 0.0
    @IBInspectable var pointsLineColor: UIColor = UIColor.black
    @IBInspectable var pointsFadeInDuration: Double = 0.5
    
    var gradientLayer: CAGradientLayer?
    var lineLayer: CAShapeLayer?
    var dotsLayer: CAShapeLayer?
    
    var graphValues: Array<Float>?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupComponent()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupComponent(inInterfaceBuilder: true)
        setValues(values: getInterfaceBuilderData(), animated: false)
    }
    
    internal func setupComponent(inInterfaceBuilder: Bool = false) {
        drawGradient()
        drawLine()
        drawPoints()
    }
    
    func setValues(values: Array<Float>, animated: Bool = true) {
        graphValues = Array<Float>()
        graphValues?.append(contentsOf: values)
        setupComponent()
        
        if (animated) {
            animateLine()
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
    
    private func drawLine() {
        if (gradientLayer == nil) {
            return
        }
        
        if (lineLayer == nil) {
            lineLayer = CAShapeLayer()
            gradientLayer?.mask = lineLayer!
        }
        
        if (lineWidth <= 0 || graphValues == nil || graphValues?.count == 0) {
            lineLayer?.path = nil
            return
        }
        
        let pointsArray: Array<CGPoint> = getPointsArray(values: graphValues!, displacementX:  self.bounds.width / 2.0, displacementY:  self.bounds.height / 2.0)
        
        lineLayer?.frame = self.bounds
        lineLayer?.path = getLinePath(points: pointsArray).cgPath
        lineLayer?.lineWidth = lineWidth
        lineLayer?.fillColor = UIColor.clear.cgColor
        lineLayer?.strokeColor = UIColor.white.cgColor
        lineLayer?.lineJoin = kCALineJoinRound
        lineLayer?.lineCap = lineRoundCaps ? kCALineCapRound : kCALineCapButt
    }
    
    internal func animateLine() {
        let growLineAnimation: CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        growLineAnimation.fromValue = 0.0
        growLineAnimation.toValue = 1.0
        growLineAnimation.beginTime = CACurrentMediaTime() + animationDelay + pointsFadeInDuration
        growLineAnimation.duration = animationDuration
        growLineAnimation.repeatCount = 0
        growLineAnimation.fillMode = kCAFillModeForwards;
        growLineAnimation.isRemovedOnCompletion = false;
        growLineAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        lineLayer?.strokeEnd = 0.0
        lineLayer?.removeAllAnimations()
        lineLayer?.add(growLineAnimation, forKey: "strokeEnd")
        
        let fadeInDotsAnimation: CABasicAnimation = CABasicAnimation(keyPath: "opacity")
        
        fadeInDotsAnimation.fromValue = 0.0
        fadeInDotsAnimation.toValue = 1.0
        fadeInDotsAnimation.beginTime = CACurrentMediaTime() + animationDelay
        fadeInDotsAnimation.duration = pointsFadeInDuration
        fadeInDotsAnimation.repeatCount = 0
        fadeInDotsAnimation.fillMode = kCAFillModeForwards;
        fadeInDotsAnimation.isRemovedOnCompletion = false;
        fadeInDotsAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        dotsLayer?.opacity = 0.0
        dotsLayer?.removeAllAnimations()
        dotsLayer?.add(fadeInDotsAnimation, forKey: "opacity")
    }
    
    internal func getLinePath(points: Array<CGPoint>)->UIBezierPath {
        let linePath: UIBezierPath = UIBezierPath()
        
        if (points.count == 0) {
            return linePath
        }
        
        for i in 0 ..< points.count {
            let point = points[i];
            
            if i==0 {
                linePath.move(to: point)
            } else {
                linePath.addLine(to: point)
            }
        }
        
        return linePath;
    }
    
    internal func drawPoints() {
        if (dotsLayer == nil) {
            dotsLayer = CAShapeLayer()
            self.layer.addSublayer(dotsLayer!)
        }
        
        if (!showPoints || graphValues == nil || graphValues?.count == 0) {
            dotsLayer?.path = nil
            return
        }
        
        let pointsArray: Array<CGPoint> = getPointsArray(values: graphValues!)
        
        dotsLayer?.path = getPointsPath(points: pointsArray).cgPath
        dotsLayer?.fillColor = pointsColor.cgColor
        dotsLayer?.lineWidth = pointsLineWidth
        dotsLayer?.strokeColor = pointsLineColor.cgColor
        dotsLayer?.frame = self.bounds
    }
    
    internal func getPointsPath(points: Array<CGPoint>)->UIBezierPath {
        let pointsPath: UIBezierPath = UIBezierPath()
        let pointsRadius: CGFloat = pointsDiameter / 2.0
        
        for i in 0 ..< points.count {
            let point: CGPoint = points[i]
            let circlePath: UIBezierPath = UIBezierPath(arcCenter: point, radius: pointsRadius, startAngle: CGFloat(0), endAngle: CGFloat.pi * 2.0, clockwise: true)
            pointsPath.append(circlePath)
        }
        
        return pointsPath
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
        let xIntervalsCount: Int = values.count - 1
        let xInterval: CGFloat = maxX / CGFloat(xIntervalsCount)
        
        for i in 0 ... values.count-1 {
            let point: CGPoint = CGPoint(x: displacementX + CGFloat(i) * xInterval, y: displacementY + CGFloat(1.0 - values[i]) * maxY)
            pointsArray.append(point)
        }
        
        return pointsArray
    }
    
    internal func getInterfaceBuilderData()->Array<Float> {
        let testData:Array<Float> = [0.5, 0.55, 0.5, 0.6, 0.1, 0.35, 0.3, 0.7, 0.8, 0.75, 0.9]
        return testData
    }
}
