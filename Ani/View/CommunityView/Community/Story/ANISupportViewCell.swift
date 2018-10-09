//
//  ANISupportViewCell.swift
//  Ani
//
//  Created by jeonminseop on 2018/06/20.
//  Copyright © 2018年 JeonMinseop. All rights reserved.
//

import UIKit
import WCLShineButton
import FirebaseFirestore
import CodableFirebase

protocol ANISupportViewCellDelegate {
  func supportCellTapped(story: FirebaseStory, user: FirebaseUser)
  func supportCellRecruitTapped(recruit: FirebaseRecruit, user: FirebaseUser)
  func reject()
  func loadedRecruit(recruitId: String, recruit: FirebaseRecruit?)
  func popupOptionView(isMe: Bool, contentType: ContentType, id: String)
  func loadedStoryIsLoved(indexPath: Int, isLoved: Bool)
  func loadedStoryUser(user: FirebaseUser)
}

class ANISupportViewCell: UITableViewCell {
  
  private weak var messageLabel: UILabel?
  
  private weak var recruitBase: UIView?
  private weak var recruitImageView: UIImageView?
  private weak var basicInfoStackView: UIStackView?
  private weak var recruitStateLabel: UILabel?
  private weak var homeLabel: UILabel?
  private weak var ageLabel: UILabel?
  private weak var sexLabel: UILabel?
  private weak var titleLabel: UILabel?
  private weak var subTitleLabel: UILabel?
  
  private weak var deleteRecruitBase: UIView?
  private weak var deleteRecruitImageView: UIImageView?
  private weak var deleteRecruitAlertLabel: UILabel?
  
  private let PROFILE_IMAGE_VIEW_HEIGHT: CGFloat = 32.0
  private weak var profileImageView: UIImageView?
  private weak var userNameLabel: UILabel?
  private weak var loveButtonBG: UIView?
  private weak var loveButton: WCLShineButton?
  private weak var loveCountLabel: UILabel?
  private weak var commentButton: UIButton?
  private weak var commentCountLabel: UILabel?
  private weak var optionButton: UIButton?
  private weak var line: UIImageView?
  
  var delegate: ANISupportViewCellDelegate?
  
  var story: FirebaseStory? {
    didSet {
      guard let story = self.story else { return }
      
      if user == nil {
        loadUser()
      }
      if recruit == nil, isDeleteRecruit == nil {
        loadRecruit()
      }
      if story.isLoved == nil {
        isLoved()
      }
      reloadLayout()
      observeLove()
      observeComment()
    }
  }
  
  var recruit: FirebaseRecruit? {
    didSet {
      guard let recruit = self.recruit else { return }
      
      loadRecruitUser()
      reloadRecruitLayout(recruit: recruit)
    }
  }
  
  var isDeleteRecruit: Bool? {
    didSet {
      guard let isDeleteRecruit = self.isDeleteRecruit,
            let deleteRecruitBase = self.deleteRecruitBase,
            let deleteRecruitImageView = self.deleteRecruitImageView,
            let deleteRecruitAlertLabel = self.deleteRecruitAlertLabel else { return }

      if isDeleteRecruit {
        deleteRecruitBase.isHidden = false
        deleteRecruitImageView.isHidden = false
        deleteRecruitAlertLabel.isHidden = false
      } else {
        deleteRecruitBase.isHidden = true
        deleteRecruitImageView.isHidden = true
        deleteRecruitAlertLabel.isHidden = true
      }
    }
  }
  
  var user: FirebaseUser? {
    didSet {
      DispatchQueue.main.async {
        self.reloadUserLayout()
      }
    }
  }

  private var recruitUser: FirebaseUser?
  
  private var loveListener: ListenerRegistration?
  private var commentListener: ListenerRegistration?
  
  var indexPath: Int?
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setup() {
    self.selectionStyle = .none
    self.backgroundColor = ANIColor.bg
    
    //messageLabel
    let messageLabel = UILabel()
    messageLabel.font = UIFont.systemFont(ofSize: 16.0)
    messageLabel.textAlignment = .left
    messageLabel.textColor = ANIColor.subTitle
    messageLabel.numberOfLines = 0
    messageLabel.isUserInteractionEnabled = true
    let labelTapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
    messageLabel.addGestureRecognizer(labelTapGesture)
    addSubview(messageLabel)
    messageLabel.topToSuperview(offset: 10.0)
    messageLabel.leftToSuperview(offset: 10.0)
    messageLabel.rightToSuperview(offset: -10.0)
    self.messageLabel = messageLabel
    
    //recruitBase
    let recruitBase = UIView()
    recruitBase.backgroundColor = .white
    recruitBase.layer.cornerRadius = 10.0
    recruitBase.layer.masksToBounds = true
    recruitBase.isUserInteractionEnabled = true
    let recruitTapGesture = UITapGestureRecognizer(target: self, action: #selector(recruitTapped))
    recruitBase.addGestureRecognizer(recruitTapGesture)
    addSubview(recruitBase)
    recruitBase.topToBottom(of: messageLabel, offset: 10.0)
    recruitBase.leftToSuperview(offset: 10.0)
    recruitBase.rightToSuperview(offset: -10.0)
    self.recruitBase = recruitBase
    
    //recruitImageView
    let recruitImageView = UIImageView()
    recruitImageView.backgroundColor = .white
    recruitImageView.contentMode = .redraw
    recruitBase.addSubview(recruitImageView)
    let recruitImageViewHeight: CGFloat = (UIScreen.main.bounds.width - 20) * UIViewController.HEADER_IMAGE_VIEW_RATIO
    recruitImageView.topToSuperview()
    recruitImageView.leftToSuperview()
    recruitImageView.rightToSuperview()
    recruitImageView.height(recruitImageViewHeight)
    self.recruitImageView = recruitImageView
    
    //basicInfoStackView
    let basicInfoStackView = UIStackView()
    basicInfoStackView.axis = .horizontal
    basicInfoStackView.distribution = .fillEqually
    basicInfoStackView.alignment = .center
    basicInfoStackView.spacing = 8.0
    recruitBase.addSubview(basicInfoStackView)
    basicInfoStackView.topToBottom(of: recruitImageView, offset: 10.0)
    basicInfoStackView.leftToSuperview(offset: 10.0)
    basicInfoStackView.rightToSuperview(offset: -10.0)
    self.basicInfoStackView = basicInfoStackView
    
    //recruitStateLabel
    let recruitStateLabel = UILabel()
    recruitStateLabel.textColor = .white
    recruitStateLabel.textAlignment = .center
    recruitStateLabel.font = UIFont.boldSystemFont(ofSize: 13.0)
    recruitStateLabel.layer.cornerRadius = 5.0
    recruitStateLabel.layer.masksToBounds = true
    recruitStateLabel.backgroundColor = ANIColor.green
    basicInfoStackView.addArrangedSubview(recruitStateLabel)
    recruitStateLabel.height(24.0)
    self.recruitStateLabel = recruitStateLabel
    
    //homeLabel
    let homeLabel = UILabel()
    homeLabel.textColor = ANIColor.darkGray
    homeLabel.textAlignment = .center
    homeLabel.font = UIFont.boldSystemFont(ofSize: 13.0)
    homeLabel.layer.cornerRadius = 5.0
    homeLabel.layer.masksToBounds = true
    homeLabel.layer.borderColor = ANIColor.darkGray.cgColor
    homeLabel.layer.borderWidth = 1.2
    basicInfoStackView.addArrangedSubview(homeLabel)
    homeLabel.height(24.0)
    self.homeLabel = homeLabel
    
    //ageLabel
    let ageLabel = UILabel()
    ageLabel.textColor = ANIColor.darkGray
    ageLabel.textAlignment = .center
    ageLabel.font = UIFont.boldSystemFont(ofSize: 13.0)
    ageLabel.layer.cornerRadius = 5.0
    ageLabel.layer.masksToBounds = true
    ageLabel.layer.borderColor = ANIColor.darkGray.cgColor
    ageLabel.layer.borderWidth = 1.2
    basicInfoStackView.addArrangedSubview(ageLabel)
    ageLabel.height(24.0)
    self.ageLabel = ageLabel
    
    //sexLabel
    let sexLabel = UILabel()
    sexLabel.textColor = ANIColor.darkGray
    sexLabel.textAlignment = .center
    sexLabel.font = UIFont.boldSystemFont(ofSize: 13.0)
    sexLabel.layer.cornerRadius = 5.0
    sexLabel.layer.masksToBounds = true
    sexLabel.layer.borderColor = ANIColor.darkGray.cgColor
    sexLabel.layer.borderWidth = 1.2
    basicInfoStackView.addArrangedSubview(sexLabel)
    sexLabel.height(24.0)
    self.sexLabel = sexLabel
    
    //titleLabel
    let titleLabel = UILabel()
    titleLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
    titleLabel.textAlignment = .left
    titleLabel.textColor = ANIColor.dark
    titleLabel.numberOfLines = 0
    recruitBase.addSubview(titleLabel)
    titleLabel.topToBottom(of: basicInfoStackView, offset: 10.0)
    titleLabel.leftToSuperview(offset: 10.0)
    titleLabel.rightToSuperview(offset: -10.0)
    self.titleLabel = titleLabel
    
    //subTitleLabel
    let subTitleLabel = UILabel()
    subTitleLabel.numberOfLines = 3
    subTitleLabel.font = UIFont.systemFont(ofSize: 14.0)
    subTitleLabel.textColor = ANIColor.subTitle
    recruitBase.addSubview(subTitleLabel)
    subTitleLabel.topToBottom(of: titleLabel, offset: 10.0)
    subTitleLabel.leftToSuperview(offset: 10.0)
    subTitleLabel.rightToSuperview(offset: -10.0)
    subTitleLabel.bottomToSuperview(offset: -10)
    self.subTitleLabel = subTitleLabel
    
    //deleteRecruitBase
    let deleteRecruitBase = UIView()
    deleteRecruitBase.backgroundColor = .white
    deleteRecruitBase.layer.cornerRadius = 10.0
    deleteRecruitBase.layer.masksToBounds = true
    addSubview(deleteRecruitBase)
    deleteRecruitBase.edges(to: recruitBase)
    self.deleteRecruitBase = deleteRecruitBase
    
    //deleteRecruitImageView
    let deleteRecruitImageView = UIImageView()
    deleteRecruitImageView.image = UIImage(named: "notSee")
    deleteRecruitImageView.contentMode = .center
    deleteRecruitImageView.isHidden = true
    deleteRecruitBase.addSubview(deleteRecruitImageView)
    deleteRecruitImageView.widthToSuperview(multiplier: 0.2)
    deleteRecruitImageView.heightToWidth(of: deleteRecruitImageView)
    deleteRecruitImageView.centerXToSuperview()
    deleteRecruitImageView.centerYToSuperview(offset: -20.0)
    self.deleteRecruitImageView = deleteRecruitImageView
    
    //deleteRecruitAlertLabel
    let deleteRecruitAlertLabel = UILabel()
    deleteRecruitAlertLabel.text = "募集が削除されました。"
    deleteRecruitAlertLabel.textColor = ANIColor.dark
    deleteRecruitAlertLabel.textAlignment = .center
    deleteRecruitAlertLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
    deleteRecruitAlertLabel.isHidden = true
    deleteRecruitBase.addSubview(deleteRecruitAlertLabel)
    deleteRecruitAlertLabel.topToBottom(of: deleteRecruitImageView, offset: 30)
    deleteRecruitAlertLabel.leftToSuperview(offset: 10)
    deleteRecruitAlertLabel.rightToSuperview(offset: -10)
    self.deleteRecruitAlertLabel = deleteRecruitAlertLabel
    
    //profileImageView
    let profileImageView = UIImageView()
    profileImageView.backgroundColor = ANIColor.bg
    profileImageView.isUserInteractionEnabled = true
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageViewTapped))
    profileImageView.addGestureRecognizer(tapGesture)
    addSubview(profileImageView)
    profileImageView.topToBottom(of: recruitBase, offset: 10.0)
    profileImageView.leftToSuperview(offset: 10.0)
    profileImageView.width(PROFILE_IMAGE_VIEW_HEIGHT)
    profileImageView.height(PROFILE_IMAGE_VIEW_HEIGHT)
    profileImageView.layer.cornerRadius = PROFILE_IMAGE_VIEW_HEIGHT / 2
    profileImageView.layer.masksToBounds = true
    self.profileImageView = profileImageView
    
    //optionButton
    let optionButton = UIButton()
    optionButton.setImage(UIImage(named: "optionButton")?.withRenderingMode(.alwaysTemplate), for: .normal)
    optionButton.addTarget(self, action: #selector(showOption), for: .touchUpInside)
    optionButton.tintColor = ANIColor.darkGray
    addSubview(optionButton)
    optionButton.centerY(to: profileImageView)
    optionButton.rightToSuperview(offset: -10.0)
    optionButton.width(25.0)
    optionButton.height(25.0)
    self.optionButton = optionButton
    
    //commentCountLabel
    let commentCountLabel = UILabel()
    commentCountLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
    commentCountLabel.textColor = ANIColor.dark
    addSubview(commentCountLabel)
    commentCountLabel.centerY(to: profileImageView)
    commentCountLabel.rightToLeft(of: optionButton, offset: -10.0)
    commentCountLabel.width(25.0)
    commentCountLabel.height(20.0)
    self.commentCountLabel = commentCountLabel
    
    //commentButton
    let commentButton = UIButton()
    commentButton.setImage(UIImage(named: "comment"), for: .normal)
    commentButton.addTarget(self, action: #selector(cellTapped), for: .touchUpInside)
    addSubview(commentButton)
    commentButton.centerY(to: profileImageView)
    commentButton.rightToLeft(of: commentCountLabel, offset: -10.0)
    commentButton.width(25.0)
    commentButton.height(24.0)
    self.commentButton = commentButton
    
    //loveCountLabel
    let loveCountLabel = UILabel()
    loveCountLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
    loveCountLabel.textColor = ANIColor.dark
    addSubview(loveCountLabel)
    loveCountLabel.centerY(to: profileImageView)
    loveCountLabel.rightToLeft(of: commentButton, offset: -10.0)
    loveCountLabel.width(25.0)
    loveCountLabel.height(20.0)
    self.loveCountLabel = loveCountLabel
    
    //loveButtonBG
    let loveButtonBG = UIView()
    loveButtonBG.isUserInteractionEnabled = false
    let loveButtonBGtapGesture = UITapGestureRecognizer(target: self, action: #selector(loveButtonBGTapped))
    loveButtonBG.addGestureRecognizer(loveButtonBGtapGesture)
    addSubview(loveButtonBG)
    loveButtonBG.centerY(to: profileImageView)
    loveButtonBG.rightToLeft(of: loveCountLabel, offset: -10.0)
    loveButtonBG.width(20.0)
    loveButtonBG.height(20.0)
    self.loveButtonBG = loveButtonBG
    
    //loveButton
    var param = WCLShineParams()
    param.bigShineColor = ANIColor.red
    param.smallShineColor = ANIColor.pink
    let loveButton = WCLShineButton(frame: CGRect(x: 0.0, y: 0.0, width: 20.0, height: 20.0), params: param)
    loveButton.fillColor = ANIColor.red
    loveButton.color = ANIColor.gray
    loveButton.image = .heart
    loveButton.isEnabled = false
    loveButton.addTarget(self, action: #selector(love), for: .valueChanged)
    addSubview(loveButton)
    loveButton.centerY(to: profileImageView)
    loveButton.rightToLeft(of: loveCountLabel, offset: -10.0)
    loveButton.width(20.0)
    loveButton.height(20.0)
    self.loveButton = loveButton
    
    //userNameLabel
    let userNameLabel = UILabel()
    userNameLabel.font = UIFont.systemFont(ofSize: 13.0)
    userNameLabel.textColor = ANIColor.subTitle
    userNameLabel.numberOfLines = 2
    addSubview(userNameLabel)
    userNameLabel.leftToRight(of: profileImageView, offset: 10.0)
    userNameLabel.rightToLeft(of: loveButton, offset: -10.0)
    userNameLabel.centerY(to: profileImageView)
    self.userNameLabel = userNameLabel
    
    //line
    let line = UIImageView()
    line.image = UIImage(named: "line")
    addSubview(line)
    line.topToBottom(of: profileImageView, offset: 10.0)
    line.leftToSuperview()
    line.rightToSuperview()
    line.height(0.5)
    line.bottomToSuperview()
    self.line = line
  }
  
  private func reloadLayout() {
    guard let messageLabel = self.messageLabel,
          let titleLabel = self.titleLabel,
          let subTitleLabel = self.subTitleLabel,
          let loveButtonBG = self.loveButtonBG,
          let loveButton = self.loveButton,
          let story = self.story else { return }
    
    messageLabel.text = story.story
    
    titleLabel.text = story.recruitTitle
    subTitleLabel.text = story.recruitSubTitle

    if ANISessionManager.shared.isAnonymous {
      loveButtonBG.isUserInteractionEnabled = true
      loveButton.isEnabled = false
    } else {
      loveButtonBG.isUserInteractionEnabled = false
      loveButton.isEnabled = true
    }
    loveButton.isSelected = false
    if let isLoved = story.isLoved {
      if isLoved {
        loveButton.isSelected = true
      } else {
        loveButton.isSelected = false
      }
    }
  }
  
  private func reloadUserLayout() {
    guard let userNameLabel = self.userNameLabel,
          let profileImageView = self.profileImageView else { return }

    if let user = self.user, let profileImageUrl = user.profileImageUrl {
      profileImageView.sd_setImage(with: URL(string: profileImageUrl), completed: nil)
    } else {
      profileImageView.image = UIImage()
    }
    
    if let user = self.user, let userName = user.userName {
      userNameLabel.text = userName
    } else {
      userNameLabel.text = ""
    }
  }
  
  private func reloadRecruitLayout(recruit: FirebaseRecruit) {
    guard let recruitImageView = self.recruitImageView,
          let recruitStateLabel = self.recruitStateLabel,
          let homeLabel = self.homeLabel,
          let ageLabel = self.ageLabel,
          let sexLabel = self.sexLabel,
          let headerImageUrl = recruit.headerImageUrl else { return }
    
    recruitImageView.sd_setImage(with: URL(string: headerImageUrl), completed: nil)
    if recruit.recruitState == 0 {
      recruitStateLabel.text = "募集中"
      recruitStateLabel.backgroundColor  = ANIColor.green
    } else if recruit.recruitState == 1 {
      recruitStateLabel.text = "家族決定"
      recruitStateLabel.backgroundColor  = ANIColor.pink
    } else if recruit.recruitState == 2 {
      recruitStateLabel.text = "中止"
      recruitStateLabel.backgroundColor  = ANIColor.darkGray
    }
    homeLabel.text = recruit.home
    ageLabel.text = recruit.age
    sexLabel.text = recruit.sex
  }
  
  private func loadRecruitUser() {
    guard let recruit = self.recruit else { return }
    
    DispatchQueue.global().async {
      let database = Firestore.firestore()
      database.collection(KEY_USERS).document(recruit.userId).getDocument(completion: { (snapshot, error) in
        if let error = error {
          DLog("Error get document: \(error)")
          
          return
        }
        
        guard let snapshot = snapshot, let data = snapshot.data() else { return }
        
        do {
          let recruitUser = try FirebaseDecoder().decode(FirebaseUser.self, from: data)
          
          self.recruitUser = recruitUser
        } catch let error {
          DLog(error)
        }
      })
    }
  }
  
  private func observeLove() {
    guard let story = self.story,
          let storyId = story.id,
          let loveCountLabel = self.loveCountLabel else { return }
    
    loveCountLabel.text = "0"

    let database = Firestore.firestore()
    DispatchQueue.global().async {
      self.loveListener = database.collection(KEY_STORIES).document(storyId).collection(KEY_LOVE_IDS).addSnapshotListener({ (snapshot, error) in
        if let error = error {
          DLog("Error get document: \(error)")
          
          return
        }
        
        DispatchQueue.main.async {
          if let snapshot = snapshot {
            loveCountLabel.text = "\(snapshot.documents.count)"
          } else {
            loveCountLabel.text = "0"
          }
        }
      })
    }
  }
  
  func unobserveLove() {
    guard let loveListener = self.loveListener else { return }
    
    loveListener.remove()
  }
  
  private func observeComment() {
    guard let story = self.story,
      let storyId = story.id,
      let commentCountLabel = self.commentCountLabel else { return }
    
    commentCountLabel.text = "0"
    
    let database = Firestore.firestore()
    DispatchQueue.global().async {
      self.commentListener = database.collection(KEY_STORIES).document(storyId).collection(KEY_COMMENTS).addSnapshotListener({ (snapshot, error) in
        if let error = error {
          DLog("Error get document: \(error)")
          
          return
        }
        
        DispatchQueue.main.async {
          if let snapshot = snapshot {
            commentCountLabel.text = "\(snapshot.documents.count)"
          } else {
            commentCountLabel.text = "0"
          }
        }
      })
    }
  }
  
  func unobserveComment() {
    guard let commentListener = self.commentListener else { return }
    
    commentListener.remove()
  }
  
  private func isLoved() {
    guard let story = self.story,
          let storyId = story.id,
          let currentUserId = ANISessionManager.shared.currentUserUid else { return }

    let database = Firestore.firestore()
    DispatchQueue.global().async {
      database.collection(KEY_STORIES).document(storyId).collection(KEY_LOVE_IDS).getDocuments(completion: { (snapshot, error) in
        if let error = error {
          DLog("Error get document: \(error)")
          
          return
        }
        
        guard let snapshot = snapshot else { return }
        
        var isLoved = false
        
        DispatchQueue.main.async {
          for document in snapshot.documents {
            if document.documentID == currentUserId {
              guard let loveButton = self.loveButton else { return }
              
              loveButton.isSelected = true
              isLoved = true
              break
            } else {
              isLoved = false
            }
          }
          
          if let indexPath = self.indexPath {
            self.delegate?.loadedStoryIsLoved(indexPath: indexPath, isLoved: isLoved)
          }
        }
      })
    }
  }
  
  private func updateNoti() {
    guard let story = self.story,
          let storyId = story.id,
          let currentUser = ANISessionManager.shared.currentUser,
          let currentUserName = currentUser.userName,
          let currentUserId = ANISessionManager.shared.currentUserUid,
          let user = self.user,
          let userId = user.uid,
          currentUserId != userId else { return }
    
    let database = Firestore.firestore()
    
    DispatchQueue.global().async {
      database.collection(KEY_STORIES).document(storyId).collection(KEY_LOVE_IDS).getDocuments(completion: { (snapshot, error) in
        if let error = error {
          DLog("Error get document: \(error)")
          
          return
        }
        
        var noti = ""
        
        if let snapshot = snapshot, snapshot.documents.count > 1 {
          noti = "\(currentUserName)さん、他\(snapshot.documents.count - 1)人が「\(story.story)」ストーリーを「いいね」しました。"
        } else {
          noti = "\(currentUserName)さんが「\(story.story)」ストーリーを「いいね」しました。"
        }
        
        do {
          let date = ANIFunction.shared.getToday()
          let notification = FirebaseNotification(userId: currentUserId, noti: noti, contributionKind: KEY_CONTRIBUTION_KIND_STROY, notiKind: KEY_NOTI_KIND_LOVE, notiId: storyId, commentId: nil, updateDate: date)
          let data = try FirestoreEncoder().encode(notification)
          
          database.collection(KEY_USERS).document(userId).collection(KEY_NOTIFICATIONS).document(storyId).setData(data)
          database.collection(KEY_USERS).document(userId).updateData([KEY_IS_HAVE_UNREAD_NOTI: true])
        } catch let error {
          DLog(error)
        }
      })
    }
  }
  
  //MARK: action
  @objc private func love() {
    guard let story = self.story,
      let storyId = story.id,
      let currentUserId = ANISessionManager.shared.currentUserUid,
      let loveButton = self.loveButton,
      let indexPath = self.indexPath else { return }
    
    let database = Firestore.firestore()
    
    if loveButton.isSelected == true {
      DispatchQueue.global().async {
        let date = ANIFunction.shared.getToday()
        
        database.collection(KEY_STORIES).document(storyId).collection(KEY_LOVE_IDS).document(currentUserId).setData([currentUserId: true, KEY_DATE: date])
        
        database.collection(KEY_USERS).document(currentUserId).collection(KEY_LOVE_STORY_IDS).document(storyId).setData([KEY_DATE: date])
        
        self.updateNoti()
        
        self.delegate?.loadedStoryIsLoved(indexPath: indexPath, isLoved: true)
      }
    } else {
      DispatchQueue.global().async {
        database.collection(KEY_STORIES).document(storyId).collection(KEY_LOVE_IDS).document(currentUserId).delete()
        database.collection(KEY_USERS).document(currentUserId).collection(KEY_LOVE_STORY_IDS).document(storyId).delete()
        
        self.delegate?.loadedStoryIsLoved(indexPath: indexPath, isLoved: false)
      }
    }
  }
  
  @objc private func loveButtonBGTapped() {
    self.delegate?.reject()
  }
  
  @objc private func profileImageViewTapped() {
    guard let story = self.story else { return }
    
    ANINotificationManager.postProfileImageViewTapped(userId: story.userId)
  }
  
  @objc private func cellTapped() {
    guard let story = self.story,
          let user = self.user else { return }
    
    self.delegate?.supportCellTapped(story: story, user: user)
  }
  
  @objc private func recruitTapped() {
    guard let recruit = self.recruit,
          let recruitUser = self.recruitUser else { return }
    
    self.delegate?.supportCellRecruitTapped(recruit: recruit, user: recruitUser)
  }
  
  @objc private func showOption() {
    guard let user = self.user,
          let story = self.story,
          let storyId = story.id else { return }
    
    let contentType: ContentType = .story
    
    if let currentUserId = ANISessionManager.shared.currentUserUid, user.uid == currentUserId {
      self.delegate?.popupOptionView(isMe: true, contentType: contentType, id: storyId)
    } else {
      self.delegate?.popupOptionView(isMe: false, contentType: contentType, id: storyId)
    }
  }
}

//MARK: data
extension ANISupportViewCell {
  private func loadUser() {
    guard let story = self.story else { return }
    
    DispatchQueue.global().async {
      let database = Firestore.firestore()
      database.collection(KEY_USERS).document(story.userId).getDocument(completion: { (snapshot, error) in
        if let error = error {
          DLog("Error get document: \(error)")
          
          return
        }
        
        guard let snapshot = snapshot, let data = snapshot.data() else { return }
        
        do {
          let user = try FirebaseDecoder().decode(FirebaseUser.self, from: data)
          self.user = user
          self.delegate?.loadedStoryUser(user: user)
        } catch let error {
          DLog(error)
        }
      })
    }
  }
  
  private func loadRecruit() {
    guard let story = self.story,
          let recruitId = story.recruitId else { return }
    
    DispatchQueue.global().async {
      let database = Firestore.firestore()
      
      database.collection(KEY_RECRUITS).document(recruitId).getDocument(completion: { (snapshot, error) in
        if let error = error {
          DLog("Error get document: \(error)")
          
          return
        }
        
        guard let snapshot = snapshot, let data = snapshot.data() else {
          self.delegate?.loadedRecruit(recruitId: recruitId ,recruit: nil)
          self.isDeleteRecruit = true
          return }
        
        do {
          let recruit = try FirestoreDecoder().decode(FirebaseRecruit.self, from: data)
          self.recruit = recruit
          self.delegate?.loadedRecruit(recruitId: recruitId ,recruit: recruit)
          self.isDeleteRecruit = false
        } catch let error {
          DLog(error)
          
          self.isDeleteRecruit = false
        }
      })
    }
  }
}
