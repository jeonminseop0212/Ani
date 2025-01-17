//
//  ANIInitialView.swift
//  Ani
//
//  Created by jeonminseop on 2018/05/23.
//  Copyright © 2018年 JeonMinseop. All rights reserved.
//

import UIKit

protocol ANIInitialViewDelegate {
  func loginButtonTapped()
  func signUpButtonTapped()
  func startAnonymous()
  func showTerms()
  func showPrivacyPolicy()
  func reject(notiText: String)
  func startAnimaing()
  func stopAnimating()
  func successTwitterLogin()
  func googleLoginButtonTapped()
}

class ANIInitialView: UIView {
  
  private weak var initialImageView: UIImageView?

  private weak var titleLabel: UILabel?
  private weak var subTitleLabel: UILabel?
  
  private weak var buttonStackView: UIStackView?
  private let LOGIN_BUTTON_HEIGHT: CGFloat = 40.0
  private weak var loginButton: ANIAreaButtonView?
  private weak var loginButtonLabel: UILabel?
  private weak var signUpButton: ANIAreaButtonView?
  private weak var signUpButtonLabel: UILabel?
  
  private weak var otherLoginLeftLineView: UIView?
  private weak var otherLoginLabel: UILabel?
  private weak var otherLoginRightLineView: UIView?
  
  private weak var twitterLoginButton: ANIAreaButtonView?
  private weak var twitterImageView: UIImageView?
  private weak var twitterLoginLabel: UILabel?
  
  private weak var googleLoginButton: ANIAreaButtonView?
  private weak var googleImageView: UIImageView?
  private weak var googleLoginLabel: UILabel?
  
  private weak var anonymousLabel: UILabel?
  
  private weak var bottomStackView: UIStackView?
  private weak var termsLabel: UILabel?
  private let dotViewHeight: CGFloat = 2.0
  private weak var dotView: UIView?
  private weak var privacyPolicyLabel: UILabel?
  
  var myTabBarController: ANITabBarController?
  
  var delegate: ANIInitialViewDelegate?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setup() {
    //initialImageView
    let initialImageView = UIImageView()
    initialImageView.contentMode = .scaleAspectFill
    initialImageView.image = UIImage(named: "initial")
    addSubview(initialImageView)
    initialImageView.edgesToSuperview()
    self.initialImageView = initialImageView
    
    //bottomStackView
    let bottomStackView = UIStackView()
    bottomStackView.axis = .horizontal
    bottomStackView.alignment = .center
    bottomStackView.distribution = .equalSpacing
    bottomStackView.spacing = 5.0
    addSubview(bottomStackView)
    bottomStackView.bottomToSuperview(offset: -24.0)
    bottomStackView.centerXToSuperview()
    self.bottomStackView = bottomStackView
    
    //termsLabel
    let termsLabel = UILabel()
    termsLabel.font = UIFont.systemFont(ofSize: 13.0)
    termsLabel.textColor = ANIColor.darkGray
    termsLabel.text = "利用規約"
    termsLabel.isUserInteractionEnabled = true
    let termsTapGesture = UITapGestureRecognizer(target: self, action: #selector(showTerms))
    termsLabel.addGestureRecognizer(termsTapGesture)
    bottomStackView.addArrangedSubview(termsLabel)
    self.termsLabel = termsLabel
    
    //dotView
    let dotView = UIView()
    dotView.backgroundColor = ANIColor.darkGray
    dotView.layer.cornerRadius = dotViewHeight / 2
    dotView.layer.masksToBounds = true
    bottomStackView.addArrangedSubview(dotView)
    dotView.width(dotViewHeight)
    dotView.height(dotViewHeight)
    self.dotView = dotView
    
    //privacyPolicyLabel
    let privacyPolicyLabel = UILabel()
    privacyPolicyLabel.font = UIFont.systemFont(ofSize: 13.0)
    privacyPolicyLabel.textColor = ANIColor.darkGray
    privacyPolicyLabel.text = "プライバシーポリシー"
    privacyPolicyLabel.isUserInteractionEnabled = true
    let privacyPolicyTapGesture = UITapGestureRecognizer(target: self, action: #selector(showPrivacyPolicy))
    privacyPolicyLabel.addGestureRecognizer(privacyPolicyTapGesture)
    bottomStackView.addArrangedSubview(privacyPolicyLabel)
    self.privacyPolicyLabel = privacyPolicyLabel
    
    //anonymousLabel
    let anonymousLabel = UILabel()
    anonymousLabel.font = UIFont.systemFont(ofSize: 13.0)
    anonymousLabel.textColor = ANIColor.darkGray
    anonymousLabel.text = "ログインしないで始める"
    anonymousLabel.isUserInteractionEnabled = true
    let anonymousTapGesture = UITapGestureRecognizer(target: self, action: #selector(startAnonymous))
    anonymousLabel.addGestureRecognizer(anonymousTapGesture)
    addSubview(anonymousLabel)
    anonymousLabel.bottomToTop(of: bottomStackView, offset: -10.0)
    anonymousLabel.centerXToSuperview()
    self.anonymousLabel = anonymousLabel
    
    //gooleLoginButton
    let googleLoginButton = ANIAreaButtonView()
    googleLoginButton.base?.layer.cornerRadius = LOGIN_BUTTON_HEIGHT / 2
    googleLoginButton.base?.backgroundColor = ANIColor.pink
    googleLoginButton.delegate = self
    addSubview(googleLoginButton)
    googleLoginButton.bottomToTop(of: anonymousLabel, offset: -12.0)
    googleLoginButton.leftToSuperview(offset: 40.0)
    googleLoginButton.rightToSuperview(offset: -40.0)
    googleLoginButton.height(LOGIN_BUTTON_HEIGHT)
    self.googleLoginButton = googleLoginButton
    
    //googleLoginLabel
    let googleLoginLabel = UILabel()
    googleLoginLabel.textColor = .white
    googleLoginLabel.textAlignment = .center
    googleLoginLabel.text = "Google"
    googleLoginLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
    googleLoginButton.addContent(googleLoginLabel)
    googleLoginLabel.centerXToSuperview(offset: 14.0)
    googleLoginLabel.centerYToSuperview()
    self.googleLoginLabel = googleLoginLabel
    
    //googleImageView
    let googleImageView = UIImageView()
    googleImageView.image = UIImage(named: "google")
    googleImageView.contentMode = .scaleAspectFit
    googleLoginButton.addContent(googleImageView)
    googleImageView.width(25.0)
    googleImageView.height(20.0)
    googleImageView.rightToLeft(of: googleLoginLabel, offset: -5.0)
    googleImageView.centerYToSuperview()
    self.googleImageView = googleImageView
    
    //twitterLoginButton
    let twitterLoginButton = ANIAreaButtonView()
    twitterLoginButton.base?.layer.cornerRadius = LOGIN_BUTTON_HEIGHT / 2
    twitterLoginButton.base?.backgroundColor = ANIColor.lightBlue
    twitterLoginButton.delegate = self
    addSubview(twitterLoginButton)
    twitterLoginButton.bottomToTop(of: googleLoginButton, offset: -10.0)
    twitterLoginButton.leftToSuperview(offset: 40.0)
    twitterLoginButton.rightToSuperview(offset: -40.0)
    twitterLoginButton.height(LOGIN_BUTTON_HEIGHT)
    self.twitterLoginButton = twitterLoginButton
    
    //twitterLoginLabel
    let twitterLoginLabel = UILabel()
    twitterLoginLabel.textColor = .white
    twitterLoginLabel.textAlignment = .center
    twitterLoginLabel.text = "Twitter"
    twitterLoginLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
    twitterLoginButton.addContent(twitterLoginLabel)
    twitterLoginLabel.centerXToSuperview(offset: 10.0)
    twitterLoginLabel.centerYToSuperview()
    self.twitterLoginLabel = twitterLoginLabel
    
    //twitterImageView
    let twitterImageView = UIImageView()
    twitterImageView.image = UIImage(named: "twitterWhite")
    twitterImageView.contentMode = .scaleAspectFit
    twitterLoginButton.addContent(twitterImageView)
    twitterImageView.width(20.0)
    twitterImageView.height(20.0)
    twitterImageView.rightToLeft(of: twitterLoginLabel, offset: -5.0)
    twitterImageView.centerYToSuperview()
    self.twitterImageView = twitterImageView
    
    //otherLoginLabel
    let otherLoginLabel = UILabel()
    otherLoginLabel.text = "その他ログイン"
    otherLoginLabel.font = UIFont.systemFont(ofSize: 13.0)
    otherLoginLabel.textColor = ANIColor.darkGray
    addSubview(otherLoginLabel)
    otherLoginLabel.centerXToSuperview()
    otherLoginLabel.bottomToTop(of: twitterLoginButton, offset: -5.0)
    self.otherLoginLabel = otherLoginLabel
    
    //otherLoginLeftLineView
    let otherLoginLeftLineView = UIView()
    otherLoginLeftLineView.backgroundColor = ANIColor.darkGray
    addSubview(otherLoginLeftLineView)
    otherLoginLeftLineView.leftToSuperview(offset: 50.0)
    otherLoginLeftLineView.rightToLeft(of: otherLoginLabel, offset: -10.0)
    otherLoginLeftLineView.height(0.5)
    otherLoginLeftLineView.centerY(to: otherLoginLabel)
    self.otherLoginLeftLineView = otherLoginLeftLineView
    
    //otherLoginRightLineView
    let otherLoginRightLineView = UIView()
    otherLoginRightLineView.backgroundColor = ANIColor.darkGray
    addSubview(otherLoginRightLineView)
    otherLoginRightLineView.leftToRight(of: otherLoginLabel, offset: 10.0)
    otherLoginRightLineView.rightToSuperview(offset: -50.0)
    otherLoginRightLineView.height(0.5)
    otherLoginRightLineView.centerY(to: otherLoginLabel)
    self.otherLoginRightLineView = otherLoginRightLineView
    
    //buttonStackView
    let buttonStackView = UIStackView()
    buttonStackView.axis = .horizontal
    buttonStackView.alignment = .center
    buttonStackView.distribution = .fillEqually
    buttonStackView.spacing = 10.0
    addSubview(buttonStackView)
    buttonStackView.bottomToTop(of: otherLoginLabel, offset: -5.0)
    buttonStackView.leftToSuperview(offset: 40.0)
    buttonStackView.rightToSuperview(offset: -40.0)
    self.buttonStackView = buttonStackView
    
    //loginButton
    let loginButton = ANIAreaButtonView()
    loginButton.base?.layer.cornerRadius = LOGIN_BUTTON_HEIGHT / 2
    loginButton.base?.backgroundColor = ANIColor.emerald
    loginButton.delegate = self
    buttonStackView.addArrangedSubview(loginButton)
    loginButton.height(LOGIN_BUTTON_HEIGHT)
    self.loginButton = loginButton
    
    //loginButtonLabel
    let loginButtonLabel = UILabel()
    loginButtonLabel.textColor = .white
    loginButtonLabel.textAlignment = .center
    loginButtonLabel.text = "ログイン"
    loginButtonLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
    loginButton.addContent(loginButtonLabel)
    loginButtonLabel.edgesToSuperview()
    self.loginButtonLabel = loginButtonLabel
    
    //signUpButton
    let signUpButton = ANIAreaButtonView()
    signUpButton.base?.layer.cornerRadius = LOGIN_BUTTON_HEIGHT / 2
    signUpButton.base?.backgroundColor = .clear
    signUpButton.base?.layer.borderColor = ANIColor.emerald.cgColor
    signUpButton.base?.layer.borderWidth = 2.0
    signUpButton.delegate = self
    buttonStackView.addArrangedSubview(signUpButton)
    signUpButton.height(LOGIN_BUTTON_HEIGHT)
    self.signUpButton = signUpButton
    
    //signUpButtonLabel
    let signUpButtonLabel = UILabel()
    signUpButtonLabel.textColor = ANIColor.emerald
    signUpButtonLabel.textAlignment = .center
    signUpButtonLabel.text = "登録"
    signUpButtonLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
    signUpButton.addContent(signUpButtonLabel)
    signUpButtonLabel.edgesToSuperview()
    self.signUpButtonLabel = signUpButtonLabel

    //subTitleLabel
    let subTitleLabel = UILabel()
    subTitleLabel.textColor = ANIColor.subTitle
    subTitleLabel.font = UIFont.systemFont(ofSize: 18.0)
    subTitleLabel.numberOfLines = 2
    subTitleLabel.textAlignment = .center
    subTitleLabel.text = "猫と猫好き、猫好きと猫好きが\nつながるコミュニティ"
    addSubview(subTitleLabel)
    subTitleLabel.centerXToSuperview()
    subTitleLabel.bottomToTop(of: buttonStackView, offset: -24.0)
    self.subTitleLabel = subTitleLabel
    
    //titleLabel
    let titleLabel = UILabel()
    titleLabel.textColor = ANIColor.dark
    titleLabel.font = UIFont.boldSystemFont(ofSize: 55.0)
    titleLabel.text = "MYAU"
    addSubview(titleLabel)
    titleLabel.bottomToTop(of: subTitleLabel, offset: -20.0)
    titleLabel.centerXToSuperview()
    self.titleLabel = titleLabel
  }
  
  @objc private func startAnonymous() {
    self.delegate?.startAnonymous()
  }
  
  @objc private func showTerms() {
    self.delegate?.showTerms()
  }
  
  @objc private func showPrivacyPolicy() {
    self.delegate?.showPrivacyPolicy()
  }
}

//MARK: ANIButtonViewDelegate
extension ANIInitialView: ANIButtonViewDelegate {
  func buttonViewTapped(view: ANIButtonView) {
    if view === loginButton {
      self.delegate?.loginButtonTapped()
    }
    if view === signUpButton {
      self.delegate?.signUpButtonTapped()
    }
    if view === twitterLoginButton {
      self.delegate?.startAnimaing()
      ANITwitter.login(isLink: false) { (success, errorMessage) in
        if !success, let errorMessage = errorMessage {
          self.delegate?.reject(notiText: errorMessage)
          self.delegate?.stopAnimating()
          return
        }
        
        self.myTabBarController?.isLoadedUser = false
        self.myTabBarController?.isLoadedFirstData = false
        self.myTabBarController?.loadUser() {
          self.delegate?.successTwitterLogin()
          self.myTabBarController?.observeChatGroup()
          
          self.delegate?.stopAnimating()
        }
      }
    }
    if view === googleLoginButton {
      self.delegate?.googleLoginButtonTapped()
    }
  }
}
