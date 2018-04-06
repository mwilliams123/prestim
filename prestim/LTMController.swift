//
//  LTMController.swift
//  prestim
//
//  Created by Megan Williams on 3/30/18.
//  Copyright © 2018 Prestimulus. All rights reserved.
//

import Foundation



import UIKit
import AWSDynamoDB
import AWSCognitoIdentityProvider

class LTMController: UIViewController {
    
    
    var dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
    var cuePoint: CGPoint!
    let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USEast1,
                                                            identityPoolId:"us-east-1:29e6b34a-7b33-4c71-823e-8b559b42287f")
    
    let colorWheel = ColorCircle(frame: CGRect(x: 55, y: 200, width: 300, height: 300))
    var imageView = UIImageView(image: UIImage(named: "white"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // start.layer.borderWidth = 1
        // start.layer.borderColor = UIColor.black.cgColor
    }
    
    var n = 1
    
    func update() {
        // Something cool
        
        let circleWidth = CGFloat(300)
        let circleHeight = circleWidth
        let circleView = CircleView(frame: CGRect(x: 55, y: 200, width: circleWidth, height: circleHeight))
        
        view.addSubview(circleView)
        
        let xCenter = 55 + circleWidth/2.0
        let yCenter = 200 + circleHeight/2.0
        
        let radius = circleView.radius!
        let deg = Double(arc4random_uniform(360))
        var radians = deg * Double.pi / 180.0
        let x_pos = radius * CGFloat(cos(radians))
        let y_pos = radius * CGFloat(sin(radians))
        var width = CGFloat(20)
        var height = CGFloat(20)
        let point = UIView(frame: CGRect(x: xCenter + x_pos - width/2, y: yCenter + y_pos - height/2, width: width, height: height))
        point.backgroundColor = UIColor.black
        point.layer.cornerRadius = 10
        
        
        view.addSubview(point)
        point.isHidden = true
        
        let perc = arc4random_uniform(100)
        
        width = CGFloat(100)
        height = CGFloat(100)
        let image1 = UIImage(named: "pic" +  String(n) + "_1")
        let imageView1 = UIImageView(image: image1!)
        let image2 = UIImage(named: "pic" +  String(n) + "_2")
        let imageView2 = UIImageView(image: image2!)
        
        var rand_deg = Double(arc4random_uniform(360))
        while abs(deg - rand_deg) < 10 {
            rand_deg = Double(arc4random_uniform(360))
        }
        radians = rand_deg * Double.pi / 180.0
        let rand_pos_x = radius * CGFloat(cos(radians))
        let rand_pos_y = radius * CGFloat(sin(radians))
        // print(perc)
        if perc < 75 {
            // cue is on correct image
            imageView1.frame = CGRect(x: xCenter + x_pos - width/2, y: yCenter + y_pos - height/2, width: width, height: height)
            imageView2.frame = CGRect(x: xCenter + rand_pos_x - width/2, y: yCenter + rand_pos_y - height/2, width: width, height: height)
            
        }
        else {
            // cue is on incorrect image
            imageView2.frame = CGRect(x: xCenter + x_pos - width/2, y: yCenter + y_pos - height/2, width: width, height: height)
            imageView1.frame = CGRect(x: xCenter + rand_pos_x - width/2, y: yCenter + rand_pos_y - height/2, width: width, height: height)
            
        }
        
        view.addSubview(imageView1)
        view.addSubview(imageView2)
        imageView1.isHidden = true
        imageView2.isHidden = true
        
        
        let time = DispatchTime.now()
        DispatchQueue.main.asyncAfter(deadline: time + .seconds(2), execute: { () -> Void in
            point.isHidden = false
        })
        DispatchQueue.main.asyncAfter(deadline: time + .seconds(2) + .milliseconds(250), execute: { () -> Void in
            point.isHidden = true
        })
        
        
        DispatchQueue.main.asyncAfter(deadline: time + .seconds(5) , execute: { () -> Void in
            imageView1.isHidden = false
            imageView2.isHidden = false
        })
        DispatchQueue.main.asyncAfter(deadline: time + .seconds(5) + .milliseconds(500), execute: { () -> Void in
            imageView1.isHidden = true
            imageView2.isHidden = true
        })
        
        
        
        view.addSubview(colorWheel)
        let image = UIImage(named: "pic" +  String(n) + "_0")
        imageView.image = image
        
        
        colorWheel.isHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: time + .seconds(8) , execute: { () -> Void in
            self.colorWheel.isHidden = false
            self.imageView.isHidden = false
        })
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapCircle(_:)))
        colorWheel.addGestureRecognizer(tapGesture)
    }
    
    func tapCircle(_ sender: UITapGestureRecognizer) {
        // print("Tapped")
        let touch = sender.location(in: view)
        let circleWidth = CGFloat(300)
        let circleHeight = circleWidth
        let xCenter = 55 + circleWidth/2.0
        let yCenter = 200 + circleHeight/2.0
        
        let rad = atan(( yCenter - touch.y)/(touch.x - xCenter ))
        
        var degree = rad * 180 / CGFloat.pi
        if (touch.x < xCenter) {
            degree = degree + 180
        }
        if degree < 0 {
            degree = degree + 360
        }
        // print(degree)
        let actual = colorList[n - 1]
        var dist = abs(degree - CGFloat(actual))
        if (dist > 180) {
            dist = abs(dist - 360)
        }
        let s = dist.description
        // print(s)
        let userId = credentialsProvider.identityId!
        
        dynamoDBObjectMapper.load(Data.self, hashKey: userId, rangeKey: nil).continueWith(block: { (task:AWSTask<AnyObject>!) -> Any? in
            var data = Data()
            if let error = task.error as NSError? {
                print("The request failed. Error: \(error)")
                return nil
            } else if (task.result as? Data) != nil {
                print("Data:")
                // Do something with task.result.
                data = task.result as? Data
                print(data?._rE! ?? "not valid")
            } else {
                print("Not found")
                data?._lTM = ["test"]
                data?._rE = []
                data?._userId = self.credentialsProvider.identityId!
            }
            
            data?._rE?.append(s)
            self.dynamoDBObjectMapper.save(data!).continueWith(block: { (task:AWSTask<AnyObject>!) -> Any? in
                if let error = task.error as NSError? {
                    print("The request failed. Error: \(error)")
                } else {
                    print("Success!")
                }
                return 0
            })
            return nil
        })
        self.imageView.isHidden = true
        if (n < 16) {
            n = n + 1
            update()
        }
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
}

