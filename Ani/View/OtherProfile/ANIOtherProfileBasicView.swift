//
//  ANIOtherProfileBasicView.swift
//  Ani
//
//  Created by jeonminseop on 2018/06/12.
//  Copyright © 2018年 JeonMinseop. All rights reserved.
//

import UIKit
import FirebaseDatabase
import CodableFirebase

protocol ANIOtherProfileBasicViewDelegate {
  func recruitViewCellDidSelect(selectedRecruit: FirebaseRecruit)
  func storyViewCellDidSelect(selectedStory: FirebaseStory)
  func qnaViewCellDidSelect(selectedQna: FirebaseQna)
}

class ANIOtherProfileBasicView: UIView {
  
  enum SectionType:Int { case top = 0; case content = 1 }
  enum ContentType:Int { case profile; case recruit; case story; case qna;}
  
  private var contentType:ContentType = .profile {
    didSet {
      self.basicTableView?.reloadData()
      self.layoutIfNeeded()
    }
  }
  
  private weak var basicTableView: UITableView?
  
  var recruits = [FirebaseRecruit]()
  
  var stories = [FirebaseStory]()
  
  var qnas = [FirebaseQna]()
  
  var user: FirebaseUser? {
    didSet {
      loadRecruit()
      loadStory()
      loadQna()
      
      guard let basicTableView = self.basicTableView else { return }
      basicTableView.reloadData()
    }
  }
  
  var userId: String? {
    didSet {
      loadUser()
    }
  }
  
  var delegate: ANIOtherProfileBasicViewDelegate?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setup() {
    let basicTableView = UITableView()
    basicTableView.backgroundColor = ANIColor.bg
    basicTableView.separatorStyle = .none
    basicTableView.dataSource = self
    basicTableView.delegate = self
    let topCellId = NSStringFromClass(ANIOtherProfileTopCell.self)
    basicTableView.register(ANIOtherProfileTopCell.self, forCellReuseIdentifier: topCellId)
    let profileCellid = NSStringFromClass(ANIOtherProfileCell.self)
    basicTableView.register(ANIOtherProfileCell.self, forCellReuseIdentifier: profileCellid)
    let recruitCellid = NSStringFromClass(ANIRecruitViewCell.self)
    basicTableView.register(ANIRecruitViewCell.self, forCellReuseIdentifier: recruitCellid)
    let storyCellid = NSStringFromClass(ANIStoryViewCell.self)
    basicTableView.register(ANIStoryViewCell.self, forCellReuseIdentifier: storyCellid)
    let qnaCellid = NSStringFromClass(ANIQnaViewCell.self)
    basicTableView.register(ANIQnaViewCell.self, forCellReuseIdentifier: qnaCellid)
    addSubview(basicTableView)
    basicTableView.edgesToSuperview()
    self.basicTableView = basicTableView
  }
  
  private func loadUser() {
    guard let userId = self.userId else { return }
    
    DispatchQueue.global().async {
      let databaseRef = Database.database().reference()
      databaseRef.child(KEY_USERS).child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
        
        guard let value = snapshot.value else { return }
        do {
          let user = try FirebaseDecoder().decode(FirebaseUser.self, from: value)
          
          self.user = user
        } catch let error {
          print(error)
        }
      })
    }
  }
  
  private func loadRecruit() {
    guard let user = self.user,
          let uid = user.uid else { return }
    
    DispatchQueue.global().async {
      let databaseRef = Database.database().reference()
      databaseRef.child(KEY_USERS).child(uid).child(KEY_POST_RECRUIT_IDS).queryLimited(toFirst: 20).observe(.childAdded) { (snapshot) in
        databaseRef.child(KEY_RECRUITS).child(snapshot.key).observeSingleEvent(of: .value, with: { (snapshot) in
          
          guard let value = snapshot.value else { return }
          do {
            let recruit = try FirebaseDecoder().decode(FirebaseRecruit.self, from: value)
            self.recruits.insert(recruit, at: 0)
            
            DispatchQueue.main.async {
              guard let basicTableView = self.basicTableView else { return }
              basicTableView.reloadData()
            }
          } catch let error {
            print(error)
          }
        })
      }
    }
  }
  
  private func loadStory() {
    guard let user = self.user,
          let uid = user.uid else { return }
    
    DispatchQueue.global().async {
      let databaseRef = Database.database().reference()
      databaseRef.child(KEY_USERS).child(uid).child(KEY_POST_STORY_IDS).queryLimited(toFirst: 20).observe(.childAdded) { (snapshot) in
        databaseRef.child(KEY_STORIES).child(snapshot.key).observeSingleEvent(of: .value, with: { (snapshot) in
          
          guard let value = snapshot.value else { return }
          do {
            let story = try FirebaseDecoder().decode(FirebaseStory.self, from: value)
            self.stories.insert(story, at: 0)
            
            DispatchQueue.main.async {
              guard let basicTableView = self.basicTableView else { return }
              basicTableView.reloadData()
            }
          } catch let error {
            print(error)
          }
        })
      }
    }
  }
  
  private func loadQna() {
    guard let user = self.user,
          let uid = user.uid else { return }
    
    DispatchQueue.global().async {
      let databaseRef = Database.database().reference()
      databaseRef.child(KEY_USERS).child(uid).child(KEY_POST_QNA_IDS).queryLimited(toFirst: 20).observe(.childAdded) { (snapshot) in
        databaseRef.child(KEY_QNAS).child(snapshot.key).observeSingleEvent(of: .value, with: { (snapshot) in
          
          guard let value = snapshot.value else { return }
          do {
            let qna = try FirebaseDecoder().decode(FirebaseQna.self, from: value)
            self.qnas.insert(qna, at: 0)
            
            DispatchQueue.main.async {
              guard let basicTableView = self.basicTableView else { return }
              basicTableView.reloadData()
            }
          } catch let error {
            print(error)
          }
        })
      }
    }
  }
}

//MARK: UITableViewDataSource
extension ANIOtherProfileBasicView: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return 1
    } else {
      if contentType == .profile {
        return 1
      } else if contentType == .recruit {
        return recruits.count
      } else if contentType == .story {
        return stories.count
      } else {
        return qnas.count
      }
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let section = indexPath.section
    
    if section == 0 {
      let topCellId = NSStringFromClass(ANIOtherProfileTopCell.self)
      let cell = tableView.dequeueReusableCell(withIdentifier: topCellId, for: indexPath) as! ANIOtherProfileTopCell
      cell.delegate = self
      cell.selectedIndex = contentType.rawValue
      cell.user = user
      return cell
    } else {
      if contentType == .profile {
        let profileCellid = NSStringFromClass(ANIOtherProfileCell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: profileCellid, for: indexPath) as! ANIOtherProfileCell
        cell.user = user
        return cell
      } else if contentType == .recruit {
        let recruitCellid = NSStringFromClass(ANIRecruitViewCell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: recruitCellid, for: indexPath) as! ANIRecruitViewCell
        
        cell.recruit = recruits[indexPath.row]
        
        return cell
      } else if contentType == .story {
        let storyCellid = NSStringFromClass(ANIStoryViewCell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: storyCellid, for: indexPath) as! ANIStoryViewCell
        
        cell.story = stories[indexPath.row]
        cell.observeStory()
        
        return cell
      } else {
        let qnaCellid = NSStringFromClass(ANIQnaViewCell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: qnaCellid, for: indexPath) as! ANIQnaViewCell
        
        cell.qna = qnas[indexPath.row]
        cell.observeQna()
        
        return cell
      }
    }
  }
}

//MARK: UITableViewDelegate
extension ANIOtherProfileBasicView: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch contentType {
    case .profile:
      return
    case .recruit:
      self.delegate?.recruitViewCellDidSelect(selectedRecruit: recruits[indexPath.row])
    case .story:
      self.delegate?.storyViewCellDidSelect(selectedStory: stories[indexPath.row])
    case .qna:
      self.delegate?.qnaViewCellDidSelect(selectedQna: qnas[indexPath.row])
    }
  }
}

//MARK: ANIProfileMenuBarDelegate
extension ANIOtherProfileBasicView: ANIProfileMenuBarDelegate {
  func didSelecteMenuItem(selectedIndex: Int) {
    guard let basicTableView = self.basicTableView else { return }
    
    switch selectedIndex {
    case ContentType.profile.rawValue:
      contentType = .profile
    case ContentType.story.rawValue:
      contentType = .story
    case ContentType.recruit.rawValue:
      contentType = .recruit
    case ContentType.qna.rawValue:
      contentType = .qna
    default:
      print("default")
    }
    
    basicTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
  }
}