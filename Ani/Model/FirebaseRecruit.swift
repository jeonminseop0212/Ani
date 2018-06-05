//
//  FirebaseRecruit.swift
//  Ani
//
//  Created by jeonminseop on 2018/06/05.
//  Copyright © 2018年 JeonMinseop. All rights reserved.
//

import UIKit

struct FirebaseRecruit: Codable {
  var headerImageUrl: String?
  let title: String
  let kind: String
  let age: String
  let sex: String
  let home: String
  let vaccine: String
  let castration: String
  let reason: String
  let introduce: String
  var introduceImageUrls: [String]?
  let passing: String
  let isRecruit: Bool
  let userId: String
  let userName: String
  let profileImageUrl: String
  let supportCount: Int
  let loveCount: Int
}
