//
//  UserSearchView.swift
//  Ani
//
//  Created by 전민섭 on 2018/04/16.
//  Copyright © 2018年 JeonMinseop. All rights reserved.
//

import UIKit

protocol ANIUserSearchViewDelegate {
  func userSearchViewDidScroll(scrollY: CGFloat)
}

class ANIUserSearchView: UIView {
  
  private weak var userTableView: UITableView?
  
  private var testUserSearchResult = [User]()
  
  var delegate: ANIUserSearchViewDelegate?

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
    setupTestUser()
    setupNotifications()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setup() {
    let tableView = UITableView()
    tableView.separatorStyle = .none
    let topInset = UIViewController.NAVIGATION_BAR_HEIGHT + ANIRecruitViewController.CATEGORIES_VIEW_HEIGHT
    tableView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
    tableView.scrollIndicatorInsets  = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
    tableView.setContentOffset(CGPoint(x: 0, y: -topInset), animated: false)
    tableView.backgroundColor = .white
    let id = NSStringFromClass(ANIUserSearchViewCell.self)
    tableView.register(ANIUserSearchViewCell.self, forCellReuseIdentifier: id)
    tableView.dataSource = self
    tableView.delegate = self
    addSubview(tableView)
    tableView.edgesToSuperview()
    self.userTableView = tableView
  }
  
  private func setupNotifications() {
    ANINotificationManager.receive(searchTabTapped: self, selector: #selector(scrollToTop))
  }
  
  private func setupTestUser() {
    let familyImages = [UIImage(named: "family1")!, UIImage(named: "family2")!, UIImage(named: "family3")!]
    let user1 = User(id: "jeonminseop", password: "aaaaa", profileImage: UIImage(named: "profileImage")!,name: "jeon minseop", familyImages: familyImages, kind: "個人", introduce: "一人で猫たちのためにボランティア活動をしています")
    let user2 = User(id: "jeonminseop", password: "aaaaa", profileImage: UIImage(named: "profileImage")!,name: "inoue chiaki", familyImages: familyImages, kind: "個人", introduce: "一人で猫たちのためにボランティア活動をしています")
    let user3 = User(id: "jeonminseop", password: "aaaaa", profileImage: UIImage(named: "profileImage")!,name: "jeon minseop", familyImages: familyImages, kind: "団体", introduce: "団体で猫たちのためにボランティア活動をしています")
    let user4 = User(id: "jeonminseop", password: "aaaaa", profileImage: UIImage(named: "profileImage")!,name: "jeon minseop", familyImages: familyImages, kind: "個人", introduce: "一人で猫たちのためにボランティア活動をしています")
    let user5 = User(id: "jeonminseop", password: "aaaaa", profileImage: UIImage(named: "profileImage")!,name: "inoue chiaki", familyImages: familyImages, kind: "個人", introduce: "一人で猫たちのためにボランティア活動をしています")
    let user6 = User(id: "jeonminseop", password: "aaaaa", profileImage: UIImage(named: "profileImage")!,name: "jeon minseop", familyImages: familyImages, kind: "団体", introduce: "団体で猫たちのためにボランティア活動をしています")
    let user7 = User(id: "jeonminseop", password: "aaaaa", profileImage: UIImage(named: "profileImage")!,name: "jeon minseop", familyImages: familyImages, kind: "個人", introduce: "一人で猫たちのためにボランティア活動をしています")
    let user8 = User(id: "jeonminseop", password: "aaaaa", profileImage: UIImage(named: "profileImage")!,name: "inoue chiaki", familyImages: familyImages, kind: "個人", introduce: "一人で猫たちのためにボランティア活動をしています")
    let user9 = User(id: "jeonminseop", password: "aaaaa", profileImage: UIImage(named: "profileImage")!,name: "jeon minseop", familyImages: familyImages, kind: "団体", introduce: "団体で猫たちのためにボランティア活動をしています")
    let user10 = User(id: "jeonminseop", password: "aaaaa", profileImage: UIImage(named: "profileImage")!,name: "jeon minseop", familyImages: familyImages, kind: "個人", introduce: "一人で猫たちのためにボランティア活動をしています")
    let user11 = User(id: "jeonminseop", password: "aaaaa", profileImage: UIImage(named: "profileImage")!,name: "inoue chiaki", familyImages: familyImages, kind: "個人", introduce: "一人で猫たちのためにボランティア活動をしています")
    let user12 = User(id: "jeonminseop", password: "aaaaa", profileImage: UIImage(named: "profileImage")!,name: "jeon minseop", familyImages: familyImages, kind: "団体", introduce: "団体で猫たちのためにボランティア活動をしています")
    let user13 = User(id: "jeonminseop", password: "aaaaa", profileImage: UIImage(named: "profileImage")!,name: "jeon minseop", familyImages: familyImages, kind: "個人", introduce: "一人で猫たちのためにボランティア活動をしています")
    let user14 = User(id: "jeonminseop", password: "aaaaa", profileImage: UIImage(named: "profileImage")!,name: "inoue chiaki", familyImages: familyImages, kind: "個人", introduce: "一人で猫たちのためにボランティア活動をしています")
    let user15 = User(id: "jeonminseop", password: "aaaaa", profileImage: UIImage(named: "profileImage")!,name: "jeon minseop", familyImages: familyImages, kind: "団体", introduce: "団体で猫たちのためにボランティア活動をしています")
    let user16 = User(id: "jeonminseop", password: "aaaaa", profileImage: UIImage(named: "profileImage")!,name: "jeon minseop", familyImages: familyImages, kind: "個人", introduce: "一人で猫たちのためにボランティア活動をしています")
    let user17 = User(id: "jeonminseop", password: "aaaaa", profileImage: UIImage(named: "profileImage")!,name: "inoue chiaki", familyImages: familyImages, kind: "個人", introduce: "一人で猫たちのためにボランティア活動をしています")
    let user18 = User(id: "jeonminseop", password: "aaaaa", profileImage: UIImage(named: "profileImage")!,name: "jeon minseop", familyImages: familyImages, kind: "団体", introduce: "団体で猫たちのためにボランティア活動をしています")
    
    testUserSearchResult = [user1, user2, user3, user4, user5, user6, user7, user8, user9, user10, user11, user12, user13, user14, user15, user16, user17, user18]
  }
  
  @objc private func scrollToTop() {
    guard let userTableView = userTableView,
          !testUserSearchResult.isEmpty else { return }
    
    userTableView.scrollToRow(at: [0, 0], at: .top, animated: true)
  }
}

//MARK: UITableViewDataSource
extension ANIUserSearchView: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return testUserSearchResult.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let id = NSStringFromClass(ANIUserSearchViewCell.self)
    let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! ANIUserSearchViewCell
    
    cell.profileImageView?.image = testUserSearchResult[indexPath.row].profileImage
    cell.userNameLabel?.text = testUserSearchResult[indexPath.row].name
    
    return cell
  }
}

//MARK: UITableViewDelegate
extension ANIUserSearchView: UITableViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    ANINotificationManager.postViewScrolled()
    
    //navigation bar animation
    let scrollY = scrollView.contentOffset.y
    self.delegate?.userSearchViewDidScroll(scrollY: scrollY)
  }
}
