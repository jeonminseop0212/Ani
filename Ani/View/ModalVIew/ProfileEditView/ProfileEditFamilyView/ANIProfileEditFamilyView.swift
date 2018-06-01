//
//  ANIProfileEditFamilyView.swift
//  Ani
//
//  Created by jeonminseop on 2018/05/19.
//  Copyright © 2018年 JeonMinseop. All rights reserved.
//

import UIKit

protocol ANIProfileEditFamilyViewDelegate {
  func imagePickerCellTapped()
  func imageEditButtonTapped(index: Int)
}

class ANIProfileEditFamilyView: UIView {
  
  private weak var familyCollectionView: UICollectionView?
  
  var profileImage: UIImage? {
    didSet {
      guard let familyCollectionView = self.familyCollectionView else { return }
      
      familyCollectionView.reloadData()
    }
  }
  
  var currentUser: FirebaseUser? {
    didSet {
      guard let familyCollectionView = self.familyCollectionView else { return }
      
      familyCollectionView.reloadData()
    }
  }
  
  var delegate: ANIProfileEditFamilyViewDelegate?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setup() {
    //familyCollectionView
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .horizontal
    flowLayout.minimumInteritemSpacing = 0
    flowLayout.minimumLineSpacing = 0
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    let id = NSStringFromClass(ANIProfileEditFamilyCell.self)
    collectionView.register(ANIProfileEditFamilyCell.self, forCellWithReuseIdentifier: id)
    collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    collectionView.backgroundColor = .white
    collectionView.alwaysBounceHorizontal = true
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.delegate = self
    collectionView.dataSource = self
    addSubview(collectionView)
    collectionView.edgesToSuperview()
    self.familyCollectionView = collectionView
  }
}

//MARK: UICollectionViewDataSource
extension ANIProfileEditFamilyView: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//    guard let currentUser = self.currentUser else { return 0 }
    
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let id = NSStringFromClass(ANIProfileEditFamilyCell.self)
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath) as! ANIProfileEditFamilyCell
    
    if let profileImage = self.profileImage {
      cell.familyImageView?.image = profileImage
    } else if let currentUser = currentUser, let profileImageUrl = currentUser.profileImageUrl {
      cell.familyImageView?.sd_setImage(with: URL(string: profileImageUrl), completed: nil)
    }
    
    return cell
    
//    guard let user = self.user,
//          let familyImages = user.familyImages else { return UICollectionViewCell() }
//    let id = NSStringFromClass(ANIProfileEditFamilyCell.self)
//    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath) as! ANIProfileEditFamilyCell
//    if indexPath.item != familyImages.count {
//      cell.familyImageView?.image = familyImages[indexPath.item]
//      cell.imagePickImageView?.alpha = 1.0
//    } else {
//      cell.familyImageView?.image = UIImage(named: "familyImageAdd")
//      cell.imagePickImageView?.alpha = 0.0
//    }
//    return cell
  }
}

//MARK: UICollectionViewDelegate
extension ANIProfileEditFamilyView: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//    guard let user = self.user,
//          let familyImages = user.familyImages else { return }
//    
//    if indexPath.item == familyImages.count {
//      self.delegate?.imagePickerCellTapped()
//    } else {
      self.delegate?.imageEditButtonTapped(index: indexPath.item)
//    }
  }
}

//MARK: UICollectionViewDelegateFlowLayout
extension ANIProfileEditFamilyView: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let size = CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
    return size
  }
}
