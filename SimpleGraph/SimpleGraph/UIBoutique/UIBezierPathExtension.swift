//
//  UIBezierPathExtension.swift
//  UIBoutique
//
//  Created by Victor Obretin on 2017-01-18.
//  Copyright © 2017 Victor Obretin. All rights reserved.
//

import UIKit

extension UIBezierPath {
    
    convenience init(roundedPolygonPathWithRect rect: CGRect, sides: UInt16, cornerRadius: CGFloat) {
        
        self.init()
        
        let theta = 2.0 * CGFloat.pi / CGFloat(sides)
        let offSet: CGFloat = CGFloat(cornerRadius) * CGFloat(tan(theta/2.0))
        let squareWidth = min(rect.size.width, rect.size.height)
        
        var length = squareWidth
        
        if sides % 4 != 0 {
            length = length * CGFloat(cos(theta / 2.0))
        }
        
        let sideLength = length * CGFloat(tan(theta / 2.0))
        
        var point = CGPoint(x: (squareWidth / 2.0) + (sideLength / 2.0) - offSet, y: squareWidth - ((squareWidth - length) / 2.0))
        var angle = CGFloat.pi
        move(to: point)
        
        for _ in 0 ..< sides {
            point = CGPoint(x: point.x + CGFloat(sideLength - offSet * 2.0) * CGFloat(cos(angle)), y: point.y + CGFloat(sideLength - offSet * 2.0) * CGFloat(sin(angle)))
            addLine(to: point)
            
            let center = CGPoint(x: point.x + cornerRadius * CGFloat(cos(angle + CGFloat.pi / 2.0)), y: point.y + cornerRadius * CGFloat(sin(angle + CGFloat.pi / 2.0)))
            addArc(withCenter: center, radius:CGFloat(cornerRadius), startAngle:angle - CGFloat.pi / 2.0, endAngle:angle + theta - CGFloat.pi / 2.0, clockwise:true)
            
            point = currentPoint
            angle += theta
        }
        
        close()
    }
    
    static func rotatePath(path: UIBezierPath, theta: CGFloat) {
        let bounds = path.cgPath.boundingBox
        let center = CGPoint(x:bounds.midX, y:bounds.midY)
        
        let toOrigin = CGAffineTransform(translationX: -center.x, y: -center.y)
        path.apply(toOrigin)
        
        let rotation = CGAffineTransform(rotationAngle: theta)
        path.apply(rotation)
        
        let fromOrigin = CGAffineTransform(translationX: center.x, y: center.y)
        path.apply(fromOrigin)
    }
    
    static func scalePath(path: UIBezierPath, scale: CGFloat) {
        let bounds = path.cgPath.boundingBox
        let center = CGPoint(x:bounds.midX, y:bounds.midY)
        
        let toOrigin = CGAffineTransform(translationX: -center.x, y: -center.y)
        path.apply(toOrigin)
        
        let toScale = CGAffineTransform(scaleX: scale, y: scale)
        path.apply(toScale)
        
        let fromOrigin = CGAffineTransform(translationX: center.x, y: center.y)
        path.apply(fromOrigin)
    }
}
