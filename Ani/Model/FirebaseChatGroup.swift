//
//  FirebaseChatGroup.swift
//  Ani
//
//  Created by jeonminseop on 2018/06/28.
//  Copyright © 2018年 JeonMinseop. All rights reserved.
//

import UIKit

struct FirebaseChatGroup: Codable {
  let groupId: String
  let memberIds: [String: Bool]
  let updateDate: String
  let lastMessage: String
}