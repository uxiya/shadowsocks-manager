//
//  Port.swift
//  SecondApp
//
//  Created by 赵锦涛 on 16/9/25.
//  Copyright © 2016年 uxiya. All rights reserved.
//

import UIKit

class Port: NSObject {
    var port:NSString
    var pass:NSString
    var flow:NSNumber
    
    init(port:NSString,pass:NSString,flow:NSNumber){
        self.port=port
        self.pass=pass
        self.flow=flow
    }
}
