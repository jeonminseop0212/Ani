//
//  ANIProfileTopCell.swift
//  Ani
//
//  Created by 전민섭 on 2018/04/19.
//  Copyright © 2018年 JeonMinseop. All rights reserved.
//

import UIKit

protocol ANIProfileTopCellDelegate {
  func presentImageBrowser(index: Int, imageUrls: [String])
  func didSelecteMenuItem(selectedIndex: Int)
}

class ANIProfileTopCell: UITableViewCell {
  
  private weak var familyView: ANIFamilyView?
  private let FAMILY_VIEW_HEIGHT: CGFloat = 95.0
  
  private weak var stackView: UIStackView?

  private weak var menuBar: ANIProfileMenuBar?
  private let MENU_BAR_HEIGHT: CGFloat = 40.0
    
  var user: FirebaseUser? {
    didSet {
      guard let familyView = self.familyView,
            let user = self.user else { return }
      
      familyView.user = user
    }
  }
  
  var selectedIndex: Int? {
    didSet {
      reloadLayout()
    }
  }
  
  var delegate: ANIProfileTopCellDelegate?
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setup() {
    self.selectionStyle = .none
    self.backgroundColor = .white
    
    //familyView
    let familyView = ANIFamilyView()
    familyView.delegate = self
    addSubview(familyView)
    familyView.topToSuperview()
    familyView.leftToSuperview()
    familyView.rightToSuperview()
    familyView.widthToSuperview()
    familyView.height(FAMILY_VIEW_HEIGHT)
    self.familyView = familyView
    
    //stackView
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.distribution = .equalSpacing
    addSubview(stackView)
    stackView.topToBottom(of: familyView, offset: 10.0)
    stackView.edgesToSuperview(excluding: .top)
    self.stackView = stackView

    //menuBar
    let menuBar = ANIProfileMenuBar()
    menuBar.delegate = self
    stackView.addArrangedSubview(menuBar)
    menuBar.height(MENU_BAR_HEIGHT, priority: .defaultHigh)
    self.menuBar = menuBar
  }
  
  private func reloadLayout() {
    guard let menuBar = self.menuBar,
          let selectedIndex = self.selectedIndex else { return }
    let indexPath = IndexPath(item: selectedIndex, section: 0)
    menuBar.menuCollectionView?.selectItem(at: indexPath, animated: false, scrollPosition: .left)
  }
}

//MARK: ANIProfileMenuBarDelegate
extension ANIProfileTopCell: ANIProfileMenuBarDelegate {
  func didSelecteMenuItem(selectedIndex: Int) {
    self.delegate?.didSelecteMenuItem(selectedIndex: selectedIndex)
  }
}

//MARK: ANIFamilyViewDelegate
extension ANIProfileTopCell: ANIFamilyViewDelegate {
  func presentImageBrowser(index: Int, imageUrls: [String]) {
    self.delegate?.presentImageBrowser(index: index, imageUrls: imageUrls)
  }
}
