//
//  ViewController.swift
//  Ani
//
//  Created by 전민섭 on 2018/04/02.
//  Copyright © 2018年 JeonMinseop. All rights reserved.
//

import UIKit
import TinyConstraints

class ANIRecruitViewController: UIViewController {
  
  private weak var categoriesView: ANIRecruitCategoriesView?
  private let CATEGORIES_VIEW_HEIGHT: CGFloat = 50.0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  private func setup() {
    self.view.backgroundColor = .white
    //nav barの下からviewが開始するように
    self.navigationController?.navigationBar.isTranslucent = false
    
    //categoriesView
    let categoriesView = ANIRecruitCategoriesView()
    self.view.addSubview(categoriesView)
    categoriesView.topToSuperview()
    categoriesView.leftToSuperview()
    categoriesView.rightToSuperview()
    categoriesView.height(CATEGORIES_VIEW_HEIGHT)
    self.categoriesView = categoriesView
    
    //searchBar
    let searchBar = UISearchBar()
    searchBar.placeholder = "Search"
    searchBar.textField?.backgroundColor = ANIColor.lightGray
//    searchBar.showsCancelButton = true
//    searchBar.delegate = self
    navigationItem.titleView = searchBar
  }
}

