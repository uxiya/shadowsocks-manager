//
//  AddViewController.swift
//  SecondApp
//
//  Created by 赵锦涛 on 16/9/25.
//  Copyright © 2016年 uxiya. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AddViewController: UIViewController {
    
    @IBOutlet weak var port: UITextField!
    @IBOutlet weak var password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
        
    @IBAction func submit(_ sender: UIButton) {
                let parameters: Parameters = [
                    "port": port.text!,
                    "password": "\(password.text!)"
                ]
        Alamofire.request("http://47.88.17.151:6001/port/add",method: .post,parameters:parameters).responseJSON { response in
                    debugPrint(response)
        
                    if let json = response.result.value {
                        debugPrint(json)
                        let dict = json as! Dictionary<String,AnyObject>
                        var msg = dict["Err"] as! String
                        if msg == ""{
                            msg = "添加成功"
                        }
                        //初始化提示框；
                        let alertController = UIAlertController(title: "标题", message: msg, preferredStyle: UIAlertControllerStyle.alert)
                        let okAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.default, handler: nil)
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
        }
    }
    
}
