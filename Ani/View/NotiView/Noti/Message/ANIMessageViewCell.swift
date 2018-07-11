//
//  ANIMessageViewCell.swift
//  Ani
//
//  Created by 전민섭 on 2018/04/15.
//  Copyright © 2018年 JeonMinseop. All rights reserved.
//

import UIKit
import FirebaseDatabase
import CodableFirebase

class ANIMessageViewCell: UITableViewCell {
  
  private let PROFILE_IMAGE_VIEW_HEIGHT: CGFloat = 50.0
  private weak var profileImageView: UIImageView?
  private weak var userNameLabel: UILabel?
  private weak var updateDateLabel: UILabel?
  private weak var messageLabel: UILabel?
  
  var chatGroup: FirebaseChatGroup? {
    didSet {
      loadUser()
      reloadLayout()
    }
  }
  
  private var user: FirebaseUser? {
    didSet {
      reloadUserLayout()
    }
  }
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setup() {
    self.selectionStyle = .none
    backgroundColor = .white
    self.isUserInteractionEnabled = true
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
    self.addGestureRecognizer(tapGesture)
    
    //profileImageView
    let profileImageView = UIImageView()
    profileImageView.backgroundColor = ANIColor.bg
    profileImageView.layer.cornerRadius = PROFILE_IMAGE_VIEW_HEIGHT / 2
    profileImageView.layer.masksToBounds = true
    profileImageView.isUserInteractionEnabled = true
    let profileImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageViewTapped))
    profileImageView.addGestureRecognizer(profileImageTapGesture)
    addSubview(profileImageView)
    profileImageView.topToSuperview(offset: 10.0)
    profileImageView.leftToSuperview(offset: 10.0)
    profileImageView.width(PROFILE_IMAGE_VIEW_HEIGHT)
    profileImageView.height(PROFILE_IMAGE_VIEW_HEIGHT)
    self.profileImageView = profileImageView
    
    //userNameLabel
    let userNameLabel = UILabel()
    userNameLabel.textColor = ANIColor.dark
    userNameLabel.font = UIFont.systemFont(ofSize: 16.0)
    addSubview(userNameLabel)
    userNameLabel.topToSuperview(offset: 13.0)
    userNameLabel.leftToRight(of: profileImageView, offset: 10.0)
    userNameLabel.height(18.0)
    self.userNameLabel = userNameLabel
    
    //updateDateLabel
    let updateDateLabel = UILabel()
    updateDateLabel.textColor = ANIColor.darkGray
    updateDateLabel.font = UIFont.systemFont(ofSize: 11.0)
    addSubview(updateDateLabel)
    updateDateLabel.centerY(to: userNameLabel)
    updateDateLabel.leftToRight(of: userNameLabel, offset: 10.0)
    updateDateLabel.rightToSuperview()
    updateDateLabel.width(70.0)
    self.updateDateLabel = updateDateLabel
    
    //messageLabel
    let messageLabel = UILabel()
    messageLabel.numberOfLines = 1
    messageLabel.font = UIFont.systemFont(ofSize: 14.0)
    messageLabel.textColor = ANIColor.subTitle
    addSubview(messageLabel)
    messageLabel.topToBottom(of: userNameLabel, offset: 10.0)
    messageLabel.left(to: userNameLabel)
    messageLabel.rightToSuperview(offset: 10.0)
    self.messageLabel = messageLabel
    
    //bottomSpace
    let spaceView = UIView()
    spaceView.backgroundColor = ANIColor.bg
    addSubview(spaceView)
    spaceView.topToBottom(of: profileImageView, offset: 10)
    spaceView.leftToSuperview()
    spaceView.rightToSuperview()
    spaceView.height(10.0)
    spaceView.bottomToSuperview()
  }
  
  private func reloadLayout() {
    guard let updateDateLabel = self.updateDateLabel,
          let messageLabel = self.messageLabel,
          let chatGroup = self.chatGroup else { return }
    
    updateDateLabel.text = String(chatGroup.updateDate.prefix(10))
    messageLabel.text = chatGroup.lastMessage
  }
  
  private func reloadUserLayout() {
    guard let profileImageView = self.profileImageView,
          let userNameLabel = self.userNameLabel,
          let user = self.user,
          let profileImageUrl = user.profileImageUrl else { return }
    
    profileImageView.sd_setImage(with: URL(string: profileImageUrl), completed: nil)
    userNameLabel.text = user.userName
  }
  
  func observeGroup() {
    guard let chatGroup = self.chatGroup else { return }
    
    let databaseRef = Database.database().reference()
    databaseRef.child(KEY_CHAT_GROUPS).child(chatGroup.groupId).observe(.value) { (snapshot) in
      if let groupValue = snapshot.value {
        do {
          let group = try FirebaseDecoder().decode(FirebaseChatGroup.self, from: groupValue)
          self.chatGroup = group
        } catch let error {
          print(error)
        }
      }
    }
  }
  
  func unobserveChatGroup() {
    guard let chatGroup = self.chatGroup else { return }
    
    let databaseRef = Database.database().reference()
    DispatchQueue.global().async {
      databaseRef.child(KEY_CHAT_GROUPS).child(chatGroup.groupId).removeAllObservers()
    }
  }
  
  @objc private func cellTapped() {
    guard let user = self.user else { return }
    
    ANINotificationManager.postMessageCellTapped(user: user)
  }
  
  @objc private func profileImageViewTapped() {
    guard let user = self.user,
          let userId = user.uid else { return }
    
    ANINotificationManager.postProfileImageViewTapped(userId: userId)
  }
}

//MARK: data
extension ANIMessageViewCell {
  private func loadUser() {
    guard let chatGroup = self.chatGroup,
          let currentUserUid = ANISessionManager.shared.currentUserUid,
          let memberIds = chatGroup.memberIds else { return }
    
    for memberId in memberIds.keys {
      if currentUserUid != memberId {
        DispatchQueue.global().async {
          let databaseRef = Database.database().reference()
          databaseRef.child(KEY_USERS).child(memberId).observeSingleEvent(of: .value, with: { (userSnapshot) in
            if let userValue = userSnapshot.value {
              do {
                let user = try FirebaseDecoder().decode(FirebaseUser.self, from: userValue)
                self.user = user
              } catch let error {
                print(error)
              }
            }
          })
        }
      }
    }
  }
}
