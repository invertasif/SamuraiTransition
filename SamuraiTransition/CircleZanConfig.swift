//
//  CircleZanConfig.swift
//  SamuraiTransition
//
//  Created by Takahiro Nishinobu on 2016/12/17.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import Foundation

class CircleZanConfig: OneLineZanProtocol, SamuraiConfigProtocol {
    
    let containerFrame: CGRect
    let zanPoint: CGPoint
    let width: CGFloat
    let color: UIColor
    var radius: CGFloat
    
    //conform SamuraiConfigProtocol
    lazy var lineLayers: [CAShapeLayer] = {
        let path = self.circleAreaPath()
        let lineLayer = self.zanLineLayer(from: path, width: self.width, color: self.color)
        return [lineLayer]
    }()
    
    lazy var zanViewConfigList: [ZanViewConfigProtocol] = {
        let maskLayers = self.zanMaskLayers()
        let oneSideConfig = ZanViewConfig(insideFrame: self.containerFrame, outSideFrame: self.containerFrame.offsetBy(dx: 0.0, dy: self.containerFrame.maxY), isAlphaAnimation: true, mask: maskLayers.oneSide)
        let otherSideConfig = ZanViewConfig(insideFrame: self.containerFrame, outSideFrame: self.containerFrame, mask: maskLayers.otherSide)
        return [oneSideConfig, otherSideConfig]
    }()
    
    init(containerFrame: CGRect, zanPoint: CGPoint, width: CGFloat, color: UIColor, radius: CGFloat) {
        self.containerFrame = containerFrame
        self.zanPoint = zanPoint
        self.width = width
        self.color = color
        self.radius = fabs(radius)
    }
    
}

extension CircleZanConfig {
    
    fileprivate func circleAreaPath() -> UIBezierPath {
        let path = UIBezierPath()
        let startAngle = -CGFloat(M_PI_2)
        let endAngle = CGFloat(M_PI) + CGFloat(M_PI_2)
        path.addArc(withCenter: zanPoint, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        return path
    }
    
    fileprivate func zanMaskLayers() -> (oneSide: CAShapeLayer, otherSide: CAShapeLayer) {
        
        let oneSide = CAShapeLayer()
        let outerCirclePath = circleAreaPath()
        outerCirclePath.addLine(to: CGPoint(x: outerCirclePath.currentPoint.x, y: containerFrame.minY))
        outerCirclePath.addLine(to: CGPoint(x: containerFrame.minX, y: outerCirclePath.currentPoint.y))
        outerCirclePath.addLine(to: CGPoint(x: outerCirclePath.currentPoint.x, y: containerFrame.maxY))
        outerCirclePath.addLine(to: CGPoint(x: containerFrame.maxX, y: outerCirclePath.currentPoint.y))
        outerCirclePath.addLine(to: CGPoint(x: outerCirclePath.currentPoint.x, y: containerFrame.minY))
        outerCirclePath.addLine(to: CGPoint(x: containerFrame.minX, y: outerCirclePath.currentPoint.y))
        oneSide.path = outerCirclePath.cgPath
        
        let otherSide = CAShapeLayer()
        let innerCirclePath = circleAreaPath()
        otherSide.path = innerCirclePath.cgPath
        
        return (oneSide, otherSide)
    }
    
}
