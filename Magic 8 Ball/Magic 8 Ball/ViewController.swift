//
//  ViewController.swift
//  Magic 8 Ball
//
//  Created by Zain Shaikh on 02/11/2018.
//  Copyright © 2018 Zain Shaikh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var ansImg: UIImageView!
    var ranDom : Int = 0
    let arrayBall = ["ball1", "ball2", "ball3", "ball4", "ball5"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func clickBtn(_ sender: UIButton) {
        ranDom = Int(arc4random_uniform(4))
        ansImg.image = UIImage(named: arrayBall[ranDom])
    }
}

