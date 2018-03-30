//
//  CircleView.swift
//  prestim
//
//  Created by Megan Williams on 12/23/17.
//  Copyright © 2017 Prestimulus. All rights reserved.
//

import UIKit

class CircleView: UIView {
    
    var circleLayer: CAShapeLayer!
    var backgroundLayer: CAShapeLayer!
    var indicater: UIView!
    var radius: CGFloat!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        radius = frame.size.width/2
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: frame.size.width/2, startAngle: CGFloat(Double.pi  * -0.5), endAngle: CGFloat(Double.pi * 1.5), clockwise: true)
        
        backgroundLayer = CAShapeLayer()
        backgroundLayer.path = circlePath.cgPath
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.strokeColor = UIColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 1).cgColor
        backgroundLayer.lineWidth = 30.0
        backgroundLayer.strokeEnd = 1.0
        layer.addSublayer(backgroundLayer)
        
//        circleLayer = CAShapeLayer()
//        circleLayer.path = circlePath.cgPath
//        circleLayer.fillColor = UIColor.clear.cgColor
//        circleLayer.strokeColor = UIColor.orange.cgColor
//        circleLayer.lineWidth = 5.0
//        circleLayer.strokeEnd = 0.0
//        layer.addSublayer(circleLayer)
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let center = CGPoint(x: bounds.size.width/2, y: bounds.size.height/2)
        let distFromCenter = pow(center.x-point.x, 2) + pow(center.y - point.y, 2)
        return (distFromCenter <= pow(bounds.size.width/2 + backgroundLayer.lineWidth/2, 2)) && (distFromCenter >= pow(bounds.size.width/2 - backgroundLayer.lineWidth/2, 2))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateCircle(duration: TimeInterval) {
        // We want to animate the strokeEnd property of the circleLayer
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        // Set the animation duration appropriately
        animation.duration = duration
        
        // Animate from 0 (no circle) to 1 (full circle)
        animation.fromValue = 0
        animation.toValue = 0.75
        
        // Do a linear animation (i.e. the speed of the animation stays the same)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        // Set the circleLayer's strokeEnd property to 1.0 now so that it's the
        // right value when the animation ends.
        circleLayer.strokeEnd = 0.75
        
        // Do the actual animation
        circleLayer.add(animation, forKey: "animateCircle")
        
        
        indicater = UIView(frame:CGRect(x: 0, y: 0, width: 20, height: 20))
        indicater.backgroundColor = UIColor.red
        let boundingRect = CGRect(x: -150, y: -150, width: 300, height: 300)
        
        let orbit = CAKeyframeAnimation()
        orbit.keyPath = "position";
        orbit.path = CGPath(ellipseIn: boundingRect, transform: nil)
        orbit.duration = duration
        orbit.isAdditive = true
        orbit.repeatCount = 1
        orbit.calculationMode = kCAAnimationPaced;
        orbit.rotationMode = kCAAnimationRotateAuto;
        
        indicater.layer.add(orbit, forKey: "orbit")
    }
}
