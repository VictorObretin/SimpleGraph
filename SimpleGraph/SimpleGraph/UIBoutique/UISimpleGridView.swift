//
//  UISimpleGridView.swift
//  SimpleGraph
//
//  Created by Victor Obretin on 2017-02-22.
//  Copyright © 2017 Victor Obretin. All rights reserved.
//

import UIKit

@IBDesignable
class UISimpleGridView: UIView {
    
    @IBInspectable var gridLinesHorizontalCount: Int = 3
    @IBInspectable var gridLinesVerticalCount: Int = 3
    @IBInspectable var showBorders: Bool = true
    
    @IBInspectable var gridLinesHorizontalColor: UIColor = UIColor.white
    @IBInspectable var gridLinesVerticalColor: UIColor = UIColor.white
    
    @IBInspectable var gridLinesWidth: CGFloat = 1.0
    @IBInspectable var gridLinesDash: CGFloat = 2.0
    @IBInspectable var gridLinesGap: CGFloat = 3.0
    @IBInspectable var gridLinesRoundCaps: Bool = false
    
    @IBInspectable var gridIntersectionsColor: UIColor = UIColor.white
    @IBInspectable var gridIntersectionsLinesWidth: CGFloat = 0
    @IBInspectable var gridIntersectionsLinesLength: CGFloat = 0
    @IBInspectable var gridIntersectionsRoundCaps: Bool = false
    
    var gridHorizontalLinesLayer: CAShapeLayer?
    var gridVerticalLinesLayer: CAShapeLayer?
    
    var gridHorizontalIntersectionsLayer: CAShapeLayer?
    var gridVerticalIntersectionsLayer: CAShapeLayer?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupComponent()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupComponent(inInterfaceBuilder: true)
    }
    
    internal func setupComponent(inInterfaceBuilder: Bool = false) {
        drawGrid()
    }
    
    private func drawGrid() {
        addHorizontalLines()
        addVerticalLines()
        addIntersections()
    }
    
    private func addHorizontalLines() {
        if (gridHorizontalLinesLayer == nil) {
            gridHorizontalLinesLayer = CAShapeLayer()
            self.layer.addSublayer(gridHorizontalLinesLayer!)
        }
        
        if (gridLinesHorizontalCount <= 0 || gridLinesWidth <= 0) {
            gridHorizontalLinesLayer?.path = nil
            return
        }
        
        var horizontalSpacing: CGFloat = self.bounds.height
        if (gridLinesHorizontalCount > 2) {
            horizontalSpacing = self.bounds.height / CGFloat(gridLinesHorizontalCount - 1)
        }
        
        let combinedPath: UIBezierPath = UIBezierPath()
        
        var currentY: CGFloat = self.bounds.minY
        
        if (showBorders) {
            for _ in 1...gridLinesHorizontalCount {
                combinedPath.append(getHorizontalLinePathAtPosition(y: currentY))
                currentY += horizontalSpacing
            }
        } else if (gridLinesHorizontalCount >= 3) {
            currentY += horizontalSpacing
            for _ in 2...gridLinesHorizontalCount-1 {
                combinedPath.append(getHorizontalLinePathAtPosition(y: currentY))
                currentY += horizontalSpacing
            }
        }
        
        var lineDashPattern: [NSNumber]?  = nil
        if (gridLinesDash > 0) {
            lineDashPattern = [ NSNumber(value: Float(gridLinesDash)), NSNumber(value: Float(gridLinesGap)) ]
        }
        
        gridHorizontalLinesLayer?.path = combinedPath.cgPath
        gridHorizontalLinesLayer?.lineWidth = gridLinesWidth
        gridHorizontalLinesLayer?.lineDashPattern = lineDashPattern
        gridHorizontalLinesLayer?.fillColor = UIColor.clear.cgColor
        gridHorizontalLinesLayer?.strokeColor = gridLinesHorizontalColor.cgColor
        gridHorizontalLinesLayer?.lineJoin = gridLinesRoundCaps ? kCALineJoinRound : kCALineCapButt
    }
    
    private func addVerticalLines() {
        if (gridVerticalLinesLayer == nil) {
            gridVerticalLinesLayer = CAShapeLayer()
            self.layer.addSublayer(gridVerticalLinesLayer!)
        }
        
        if (gridLinesVerticalCount <= 0 || gridLinesWidth <= 0) {
            gridVerticalLinesLayer?.path = nil
            return
        }
        
        var verticalSpacing: CGFloat = self.bounds.width
        if (gridLinesVerticalCount > 2) {
            verticalSpacing = self.bounds.width / CGFloat(gridLinesVerticalCount - 1)
        }
        
        let combinedPath: UIBezierPath = UIBezierPath()
        
        var currentX: CGFloat = self.bounds.minY
        
        if (showBorders) {
            for _ in 1...gridLinesVerticalCount {
                combinedPath.append(getVerticalLinePathAtPosition(x: currentX))
                currentX += verticalSpacing
            }
        } else if (gridLinesVerticalCount >= 3) {
            currentX += verticalSpacing
            for _ in 2...gridLinesVerticalCount-1 {
                combinedPath.append(getVerticalLinePathAtPosition(x: currentX))
                currentX += verticalSpacing
            }
        }
        
        var lineDashPattern: [NSNumber]?  = nil
        if (gridLinesDash > 0) {
            lineDashPattern = [ NSNumber(value: Float(gridLinesDash)), NSNumber(value: Float(gridLinesGap)) ]
        }
        
        gridVerticalLinesLayer?.path = combinedPath.cgPath
        gridVerticalLinesLayer?.lineWidth = gridLinesWidth
        gridVerticalLinesLayer?.lineDashPattern = lineDashPattern
        gridVerticalLinesLayer?.fillColor = UIColor.clear.cgColor
        gridVerticalLinesLayer?.strokeColor = gridLinesVerticalColor.cgColor
        gridVerticalLinesLayer?.lineJoin = gridLinesRoundCaps ? kCALineJoinRound : kCALineCapButt
    }
    
    private func addIntersections() {
        if (gridHorizontalIntersectionsLayer == nil) {
            gridHorizontalIntersectionsLayer = CAShapeLayer()
            self.layer.addSublayer(gridHorizontalIntersectionsLayer!)
        }
        
        if (gridVerticalIntersectionsLayer == nil) {
            gridVerticalIntersectionsLayer = CAShapeLayer()
            self.layer.addSublayer(gridVerticalIntersectionsLayer!)
        }
        
        if (gridLinesHorizontalCount <= 0 || gridLinesVerticalCount <= 0 || gridIntersectionsLinesWidth <= 0) {
            gridHorizontalIntersectionsLayer?.path = nil
            gridVerticalIntersectionsLayer?.path = nil
            return
        }
        
        var horizontalSpacing: CGFloat = self.bounds.height
        if (gridLinesHorizontalCount > 2) {
            horizontalSpacing = self.bounds.height / CGFloat(gridLinesHorizontalCount - 1)
        }
        
        var verticalSpacing: CGFloat = self.bounds.width
        if (gridLinesHorizontalCount > 2) {
            verticalSpacing = self.bounds.width / CGFloat(gridLinesVerticalCount - 1)
        }
        
        
        let combinedPath: UIBezierPath = UIBezierPath()
        
        var currentY: CGFloat = self.bounds.minY
        
        if (showBorders) {
            for _ in 1...gridLinesHorizontalCount {
                combinedPath.append(getHorizontalIntersectionsPathAtPosition(y: currentY))
                currentY += horizontalSpacing
            }
        } else if (gridLinesHorizontalCount >= 3) {
            currentY += horizontalSpacing
            for _ in 2...gridLinesHorizontalCount-1 {
                combinedPath.append(getHorizontalIntersectionsPathAtPosition(y: currentY))
                currentY += horizontalSpacing
            }
        }
        
        let maxLength: CGFloat = max( gridIntersectionsLinesLength, gridIntersectionsLinesWidth)
        
        var gap = verticalSpacing - (maxLength)
        var lineDashPattern: [NSNumber]?  = [ NSNumber(value: Float(maxLength)), NSNumber(value: Float(gap)) ]
        
        gridHorizontalIntersectionsLayer?.path = combinedPath.cgPath
        gridHorizontalIntersectionsLayer?.lineWidth = gridIntersectionsLinesWidth
        gridHorizontalIntersectionsLayer?.lineDashPattern = lineDashPattern
        gridHorizontalIntersectionsLayer?.fillColor = UIColor.clear.cgColor
        gridHorizontalIntersectionsLayer?.strokeColor = gridIntersectionsColor.cgColor
        gridHorizontalIntersectionsLayer?.lineJoin = gridIntersectionsRoundCaps ? kCALineJoinRound : kCALineCapButt
        
        
        if (gridIntersectionsLinesLength > gridIntersectionsLinesWidth) {
            let combinedPath: UIBezierPath = UIBezierPath()
            
            var currentX: CGFloat = self.bounds.minY
            
            if (showBorders) {
                for _ in 1...gridLinesVerticalCount {
                    combinedPath.append(getVerticalIntersectionsPathAtPosition(x: currentX))
                    currentX += verticalSpacing
                }
            } else if (gridLinesVerticalCount >= 3) {
                currentX += verticalSpacing
                for _ in 2...gridLinesVerticalCount-1 {
                    combinedPath.append(getVerticalIntersectionsPathAtPosition(x: currentX))
                    currentX += verticalSpacing
                }
            }
            
            gap = horizontalSpacing - (maxLength)
            lineDashPattern  = [ NSNumber(value: Float(maxLength)), NSNumber(value: Float(gap)) ]
            
            gridVerticalIntersectionsLayer?.path = combinedPath.cgPath
            gridVerticalIntersectionsLayer?.lineWidth = gridIntersectionsLinesWidth
            gridVerticalIntersectionsLayer?.lineDashPattern = lineDashPattern
            gridVerticalIntersectionsLayer?.fillColor = UIColor.clear.cgColor
            gridVerticalIntersectionsLayer?.strokeColor = gridIntersectionsColor.cgColor
            gridVerticalIntersectionsLayer?.lineJoin = gridIntersectionsRoundCaps ? kCALineJoinRound : kCALineCapButt
        } else {
            gridVerticalIntersectionsLayer?.path = nil
        }
        
        
    }
    
    private func getHorizontalLinePathAtPosition(y: CGFloat)->UIBezierPath {
        let  p0: CGPoint = CGPoint(x: self.bounds.minX, y: y)
        let  p1: CGPoint = CGPoint(x: self.bounds.maxX, y: y)
        return getLineBetweenPoints(p0: p0, p1: p1)
    }
    
    private func getVerticalLinePathAtPosition(x: CGFloat)->UIBezierPath {
        let  p0: CGPoint = CGPoint(x: x, y: self.bounds.minY)
        let  p1: CGPoint = CGPoint(x: x, y: self.bounds.maxY)
        return getLineBetweenPoints(p0: p0, p1: p1)
    }
    
    private func getHorizontalIntersectionsPathAtPosition(y: CGFloat)->UIBezierPath {
        let maxLength: CGFloat = max( gridIntersectionsLinesLength, gridIntersectionsLinesWidth)
        
        let  p0: CGPoint = CGPoint(x: self.bounds.minX - (maxLength / 2.0), y: y)
        let  p1: CGPoint = CGPoint(x: self.bounds.maxX + (maxLength / 2.0), y: y)
        return getLineBetweenPoints(p0: p0, p1: p1)
    }
    
    private func getVerticalIntersectionsPathAtPosition(x: CGFloat)->UIBezierPath {
        let maxLength: CGFloat = max( gridIntersectionsLinesLength, gridIntersectionsLinesWidth)
        
        let  p0: CGPoint = CGPoint(x: x, y: self.bounds.minY - (maxLength / 2.0))
        let  p1: CGPoint = CGPoint(x: x, y: self.bounds.maxY + (maxLength / 2.0))
        return getLineBetweenPoints(p0: p0, p1: p1)
    }
    
    private func getLineBetweenPoints(p0: CGPoint, p1: CGPoint)->UIBezierPath {
        let path: UIBezierPath = UIBezierPath()
        
        path.move(to: p0)
        path.addLine(to: p1)
        
        return path
    }
}
