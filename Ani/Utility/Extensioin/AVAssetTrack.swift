//
//  AVAssetTrack.swift
//  Ani
//
//  Created by jeonminseop on 2018/12/18.
//  Copyright © 2018年 JeonMinseop. All rights reserved.
//

import UIKit
import AVKit

extension AVAssetTrack {
  func getTransform(cropRect: CGRect) -> CGAffineTransform {
    let renderSize = cropRect.size
    let renderScale = renderSize.width / cropRect.width
    let offset = CGPoint(x: -cropRect.origin.x, y: -cropRect.origin.y)
    let rotation = atan2(self.preferredTransform.b, self.preferredTransform.a)
    
    var rotationOffset = CGPoint(x: 0, y: 0)
    
    if self.preferredTransform.b == -1.0 {
      rotationOffset.y = self.naturalSize.width
    } else if self.preferredTransform.c == -1.0 {
      rotationOffset.x = self.naturalSize.height
    } else if self.preferredTransform.a == -1.0 {
      rotationOffset.x = self.naturalSize.width
      rotationOffset.y = self.naturalSize.height
    }
    
    var transform = CGAffineTransform.identity
    transform = transform.scaledBy(x: renderScale, y: renderScale)
    transform = transform.translatedBy(x: offset.x + rotationOffset.x, y: offset.y + rotationOffset.y)
    transform = transform.rotated(by: rotation)
    return transform
  }
}
