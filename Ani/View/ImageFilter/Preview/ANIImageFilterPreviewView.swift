//
//  ANIImageFilterPreviewView.swift
//  Ani
//
//  Created by jeonminseop on 2018/05/11.
//  Copyright © 2018年 JeonMinseop. All rights reserved.
//

import UIKit

protocol ANIImageFilterPreviewViewDelegate {
  func selectedPreviewItem(selectedFilterIndex: Int)
}

class ANIImageFilterPreviewView: UIView {
  
  private weak var previewCollectionView: UICollectionView?
  var images = [UIImage?]() {
    didSet {
      filteredImages = images
      
      selectedFilterIndexs.removeAll()
      for _ in images {
        selectedFilterIndexs.append(0)
      }
    }
  }
  
  var filteredImages = [UIImage?]() {
    didSet {
      guard let previewCollectionView = self.previewCollectionView else { return }
    
      previewCollectionView.reloadData()
    }
  }
  
  var filter: ANIFilter? {
    didSet {
      if let filterUnrap = filter, let selectedImage = images[selectedItemIndex] {
        let filteredImage = filterUnrap.filter(selectedImage)
        filteredImages[selectedItemIndex] = filteredImage
      }
    }
  }
  
  var selectedFilterIndexs = [Int]()
  var selectedFilterIndex = Int() {
    didSet {
      selectedFilterIndexs[selectedItemIndex] = selectedFilterIndex
    }
  }
  
  private var selectedItemIndex: Int = 0
  
  var delegate: ANIImageFilterPreviewViewDelegate?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setup() {
    //basic
    backgroundColor = .white
    
    //previewCollectionView
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.minimumLineSpacing = 0
    flowLayout.minimumInteritemSpacing = 0
    flowLayout.scrollDirection = .horizontal
    let previewCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    previewCollectionView.backgroundColor = .white
    previewCollectionView.dataSource = self
    previewCollectionView.delegate = self
    previewCollectionView.isPagingEnabled = true
    previewCollectionView.showsHorizontalScrollIndicator = false
    let id = NSStringFromClass(ANIImageFilterPreviewCell.self)
    previewCollectionView.register(ANIImageFilterPreviewCell.self, forCellWithReuseIdentifier: id)
    addSubview(previewCollectionView)
    previewCollectionView.edgesToSuperview()
    self.previewCollectionView = previewCollectionView
  }
}

extension ANIImageFilterPreviewView: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return filteredImages.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let id = NSStringFromClass(ANIImageFilterPreviewCell.self)
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath) as! ANIImageFilterPreviewCell
    cell.imageView?.image = filteredImages[indexPath.item]
    return cell
  }
}

extension ANIImageFilterPreviewView: UICollectionViewDelegate {
  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    let selectedIndexPath = IndexPath(item: Int(targetContentOffset.pointee.x / self.frame.width), section: 0)
    selectedItemIndex = selectedIndexPath.item
    
    self.delegate?.selectedPreviewItem(selectedFilterIndex: selectedFilterIndexs[selectedItemIndex])
  }
}

extension ANIImageFilterPreviewView: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.width, height: collectionView.frame.width)
  }
}