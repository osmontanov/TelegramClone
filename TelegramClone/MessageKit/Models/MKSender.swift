//
//  File.swift
//  TelegramClone
//
//  Created by talgar osmonov on 18/6/21.
//

import Foundation
import MessageKit
import UIKit


enum MKit {
    static let outgoingColor = UIColor.init(hex: "D2FDBB")
    static let incomingColor = UIColor.white
}


struct MKSender: SenderType, Equatable {
    var senderId: String
    var displayName: String
}



