//
//  ListViewController.swift
//  SecondApp
//
//  Created by 赵锦涛 on 16/9/25.
//  Copyright © 2016年 uxiya. All rights reserved.
//

import UIKit
import Alamofire

class ListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var tableView: UITableView?
    var Infos = [Port]()
    var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView=UITableView(frame:self.view.frame,style:.plain)
        self.tableView!.dataSource=self
        self.tableView!.delegate=self
        
        //添加刷新
        refreshControl.addTarget(self, action: #selector(ListViewController.refreshData), for: UIControlEvents.valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "松手刷新")
        self.tableView!.addSubview(refreshControl)
        
        self.view.addSubview(self.tableView!)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshData(){
        Alamofire.request("http://47.88.17.151:6001/port/list").responseJSON { response in
            //debugPrint(response)
            if let json = response.result.value {
                let dict = json as! Dictionary<String,AnyObject>
                let ports = dict["Content"] as! NSArray
                var Infos = [Port]()
                for port in ports {
                    let dict = port as! Dictionary<NSString,AnyObject>
                    let tmp:Port = Port(port:dict["Port"]! as! NSString,pass:dict["Password"]! as! NSString,flow:dict["Flow"]! as! NSNumber)
                    Infos.append(tmp)
                }
                self.Infos=Infos
                self.tableView?.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return Infos.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let identifier = "port"
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier:identifier)
        }
        let port2:Port = Infos[indexPath.row]
        cell!.textLabel!.text = port2.port as String
        cell!.detailTextLabel!.text = port2.flow.stringValue
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete{
            let parameters: Parameters = [
                "port": self.Infos[indexPath.row].port,
                "password": "\(self.Infos[indexPath.row].pass)"
            ]
            Alamofire.request("http://47.88.17.151:6001/port/del",method: .post,parameters:parameters).responseJSON { response in
                debugPrint(response)
                
                if let json = response.result.value {
                    debugPrint(json)
                    let dict = json as! Dictionary<String,AnyObject>
                    var msg = dict["Err"] as! String
                    if msg == ""{
                        msg = "删除成功"
                    }
                    //初始化提示框；
                    let alertController = UIAlertController(title: "标题", message: msg, preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.default, handler: nil)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    self.Infos.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                }
            }

        }
    }

    
}
