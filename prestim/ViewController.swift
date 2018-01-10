//
//  ViewController.swift
//  prestim
//
//  Created by Megan Williams on 12/21/17.
//  Copyright © 2017 Prestimulus. All rights reserved.
//
// TODO:
// 2. Get appropriately colored images
// 3. Repeat 16 times
// 4. Other experiment


import UIKit
import AWSDynamoDB
import AWSCognitoIdentityProvider

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    var dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
    var cuePoint: CGPoint!
    let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USEast1,
                                                            identityPoolId:"us-east-1:29e6b34a-7b33-4c71-823e-8b559b42287f")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let circleWidth = CGFloat(300)
        let circleHeight = circleWidth
        let circleView = CircleView(frame: CGRect(x: 55, y: 200, width: circleWidth, height: circleHeight))
        
        view.addSubview(circleView)
        
        let xCenter = 55 + circleWidth/2.0
        let yCenter = 200 + circleHeight/2.0
        
        let radius = circleView.radius!
        let deg = Double(arc4random_uniform(360))
        let radians = deg * Double.pi / 180.0
        var x_pos = radius * CGFloat(cos(radians))
        var y_pos = radius * CGFloat(sin(radians))
        let width = CGFloat(20)
        let height = CGFloat(20)
        let point = UIView(frame: CGRect(x: xCenter + x_pos - width/2, y: yCenter + y_pos - height/2, width: width, height: height))
        point.backgroundColor = UIColor.black
        
        cuePoint = CGPoint(x: xCenter + x_pos, y: yCenter + y_pos)
        
        view.addSubview(point)
        
        let time = DispatchTime.now()
        DispatchQueue.main.asyncAfter(deadline: time + .seconds(3), execute: { () -> Void in
            point.isHidden = true
        })
        
        for index in 1...3 {
            let image = UIImage(named: "obj" + String(index))
            let imageView = UIImageView(image: image!)
            
            let width = CGFloat(100)
            let height = CGFloat(100)
            imageView.frame = CGRect(x: xCenter + x_pos - width/2, y: yCenter + y_pos - height/2, width: width, height: height)
            let deg = Double(arc4random_uniform(360))
            let radians = deg * Double.pi / 180.0
            x_pos = radius * CGFloat(cos(radians))
            y_pos = radius * CGFloat(sin(radians))
            view.addSubview(imageView)
            imageView.isHidden = true
            DispatchQueue.main.asyncAfter(deadline: time + .seconds(5), execute: { () -> Void in
                imageView.isHidden = false
            })
            DispatchQueue.main.asyncAfter(deadline: time + .seconds(9), execute: { () -> Void in
                imageView.isHidden = true
            })
        }
        
        
        let colorWheel = ColorCircle(frame: CGRect(x: 55, y: 200, width: circleWidth, height: circleHeight))
        
        view.addSubview(colorWheel)
        
        colorWheel.isHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: time + .seconds(11), execute: { () -> Void in
            colorWheel.isHidden = false
        })
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapCircle(_:)))
        colorWheel.addGestureRecognizer(tapGesture)
    }
    
    func tapCircle(_ sender: UITapGestureRecognizer) {
        print("Tapped")
        let touch = sender.location(in: view)
        let dist = pow(touch.x - cuePoint.x, 2) + pow(touch.y - cuePoint.y, 2)
        print(dist)
        
        let userId = credentialsProvider.identityId!
        print(userId)
        dynamoDBObjectMapper.load(Data.self, hashKey: userId, rangeKey: nil).continueWith(block: { (task:AWSTask<AnyObject>!) -> Any? in
            var data = Data()
            if let error = task.error as NSError? {
                print("The request failed. Error: \(error)")
                return nil
            } else if (task.result as? Data) != nil {
                print("Retrieved item")
                // Do something with task.result.
                data = task.result as? Data
                print(data?._rE!)
            } else {
                print("Not found")
                data?._lTM = ["hello"]
                data?._rE = []
                data?._userId = self.credentialsProvider.identityId!
            }
            data?._rE?.append(self.textField.text ?? "Invalid")
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

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submit(_ sender: Any) {
        
        
        
    }
    


}

