//
//  ViewController.swift
//  prestim
//
//  Created by Megan Williams on 12/21/17.
//  Copyright © 2017 Prestimulus. All rights reserved.
//
// timing
// formatting
// save ltm data
// send data at end of block
// clean up code
// transitions


import UIKit
import AWSDynamoDB
import AWSCognitoIdentityProvider

class ViewController: UIViewController {

    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var start: UIButton!
    
    
    @IBAction func submit(_ sender: Any) {
        print("submitted")
        print(iteration)
        if iteration % 16 == 0 {
            print("Updating")
            submitButton.isHidden = true
            LTMMode = false
            imageView.isHidden = true
            circleView.isHidden = false
            centerPoint.isHidden = false
            colorWheel.isHidden = true
            update()
            
        }
        else {
            print("LTM")
            LTM()
        }
    }
    
    let centerPoint = UIView()
    
    @IBAction func startButton(_ sender: Any) {
        let circleWidth = CGFloat(300)
        let circleHeight = circleWidth
        
        let xCenter = 55 + circleWidth/2.0
        let yCenter = 200 + circleHeight/2.0
        var width = CGFloat(100)
        var height = CGFloat(100)
        imageView.frame = CGRect(x: xCenter - width/2, y: yCenter - height/2, width: width, height: height)
        imageView.isHidden = true
        view.addSubview(imageView)
        
        width = CGFloat(20)
        height = CGFloat(20)
        centerPoint.frame = CGRect(x: xCenter - width/2, y: yCenter - height/2, width: width, height: height)
        centerPoint.backgroundColor = UIColor.black
        centerPoint.layer.cornerRadius = 10
        view.addSubview(centerPoint)
        circleView.isHidden = false
        start.isHidden = true
        print("START BUTTON Updating")
        update()

    }
    
    var dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
    var cuePoint: CGPoint!
    let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USEast1,
                                                            identityPoolId:"us-east-1:29e6b34a-7b33-4c71-823e-8b559b42287f")
    
    let colorWheel = ColorCircle(frame: CGRect(x: 55, y: 200, width: 300, height: 300))
    let circleView = CircleView(frame: CGRect(x: 55, y: 200, width: 300, height: 300))
    var imageView = UIImageView(image: UIImage(named: "white"))
    
    var list:[Int] = []
    var iteration = 0
    var LTMMode : Bool = false
    
    func generateRandomUniqueNumbers3(UpperBound upper:Int, NumNumbers iterations: Int) -> [Int] {
        guard iterations <= upper else { return [] }
        var numbers: Set<Int> = Set<Int>()
        (0..<iterations).forEach { _ in
            let beforeCount = numbers.count
            repeat {
                numbers.insert(Int(arc4random_uniform(UInt32(upper))))
            } while numbers.count == beforeCount
        }
        return numbers.map{ $0 }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        start.layer.borderWidth = 1
        start.layer.borderColor = UIColor.black.cgColor
        
        
        list = generateRandomUniqueNumbers3(UpperBound: 767, NumNumbers: 144)
        print(list)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapCircle(_:)))
        colorWheel.addGestureRecognizer(tapGesture)
        view.addSubview(circleView)
        view.addSubview(colorWheel)
        circleView.isHidden = true
        colorWheel.isHidden = true
        submitButton.isHidden = true
    }
    
    var true_angle = 0
    
    func update() {
       
        print(iteration)
        let circleWidth = CGFloat(300)
        let circleHeight = circleWidth
        
        
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
        
        // Determine color randomly
        true_angle = Int(arc4random_uniform(361))
        // print("True angle:")
        // print(true_angle)
        let hue1 = CGFloat(true_angle) / 360
        let hue2 = CGFloat(arc4random_uniform(361)) / 360
        
        
        let image1 = UIImage(named: "pic_" +  String(list[iteration]))!.withRenderingMode(.alwaysTemplate)
        let imageView1 = UIImageView(image: image1)
        imageView1.tintColor = UIColor(hue: hue1, saturation: 1, brightness: 1, alpha: 1)
        let image2 = UIImage(named: "pic_" +  String(list[iteration + 1]))!.withRenderingMode(.alwaysTemplate)
        let imageView2 = UIImageView(image: image2)
        imageView2.tintColor = UIColor(hue: hue2, saturation: 1, brightness: 1, alpha: 1)
        
        var rand_deg = Double(arc4random_uniform(360))
        while abs(deg - rand_deg) < 16 {
            rand_deg = Double(arc4random_uniform(360))
        }
        radians = rand_deg * Double.pi / 180.0
        let rand_pos_x = radius * CGFloat(cos(radians))
        let rand_pos_y = radius * CGFloat(sin(radians))
        // print("perc")
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
        
        
        
        
        let image = UIImage(named: "pic_" +  String(list[iteration]))!.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.black
        imageView.image = image
        
        
        
        
        DispatchQueue.main.asyncAfter(deadline: time + .seconds(8) , execute: { () -> Void in
            self.colorWheel.isHidden = false
            self.imageView.isHidden = false
        })
        
        
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
        
        
        degree = 360 - degree
        
        if (LTMMode) {
            let hue = CGFloat(degree) / 360
            imageView.tintColor = UIColor(hue: hue, saturation: 1, brightness: 1, alpha: 1)
            return
        }
        self.colorWheel.isHidden = true
        // print(degree)
        var dist = abs(degree - CGFloat(true_angle))
        if (dist > 180) {
            dist = abs(dist - 360)
        }
        print(dist)
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
                // print(data?._rE! ?? [])
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
        if (iteration < 144) {
            iteration = iteration + 2
            if iteration % 16 == 0 {
                iteration = iteration - 16
                LTMMode = true
                colorWheel.isHidden = false
                imageView.isHidden = false
                circleView.isHidden = true
                centerPoint.isHidden = true
                submitButton.isHidden = false
                LTM()
            }
            else {
                print("UPDATING")
               update()
            }
            
        }
        
        

    }
    
    func LTM() {
        imageView.image = UIImage(named: "pic_" + String(list[iteration]))!.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.black
        iteration = iteration + 2
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    


}

