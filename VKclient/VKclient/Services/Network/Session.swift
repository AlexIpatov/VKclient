//
//  Session.swift
//  VKclient
//
//  Created by Mac on 08.08.2020.
//  Copyright © 2020 Alexander. All rights reserved.
//

import UIKit

class Session {
    static let shared = Session()
    private init() {}
    var token: String = ""
    var userId: Int = 0
    var nextFrom: String = ""
}
