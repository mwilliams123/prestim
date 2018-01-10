//
//  ColorCircle.swift
//  prestim
//
//  Created by Megan Williams on 12/23/17.
//  Copyright © 2017 Prestimulus. All rights reserved.
//

import Foundation

//
//  CircleView.swift
//  prestim
//
//  Created by Megan Williams on 12/23/17.
//  Copyright © 2017 Prestimulus. All rights reserved.
//

import UIKit

class ColorCircle: UIView {
    
    var circleLayer: CAShapeLayer!
    var backgroundLayer: CAShapeLayer!
    var indicater: UIView!
    var radius: CGFloat!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        radius = frame.size.width/2
        
        
        var angle = CGFloat(0)
        let delta = CGFloat(Double.pi / 180.0)
        
        for color in colorList {
            let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: frame.size.width/2, startAngle: angle, endAngle: angle + delta, clockwise: true)
            
            backgroundLayer = CAShapeLayer()
            backgroundLayer.path = circlePath.cgPath
            backgroundLayer.fillColor = UIColor.clear.cgColor
            let red = Double(color[0])/255.0
            let green = Double(color[1])/255.0
            let blue = Double(color[2])/255.0
            backgroundLayer.strokeColor = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1).cgColor
            backgroundLayer.lineWidth = 30.0
            backgroundLayer.strokeEnd = 1.0
            layer.addSublayer(backgroundLayer)
            angle = angle + delta
        }
        
        
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let center = CGPoint(x: bounds.size.width/2, y: bounds.size.height/2)
        let distFromCenter = pow(center.x-point.x, 2) + pow(center.y - point.y, 2)
        return (distFromCenter <= pow(bounds.size.width/2 + backgroundLayer.lineWidth/2, 2)) && (distFromCenter >= pow(bounds.size.width/2 - backgroundLayer.lineWidth/2, 2))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
