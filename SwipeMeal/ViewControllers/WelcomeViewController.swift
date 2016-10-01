//
//  WelcomeViewController.swift
//  SwipeMeal
//
//  Created by Gregory Klein on 6/17/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

private enum WelcomeViewControllerMode
{
   case dontAbuseSwipeMeal, setupProfile, addPayments, buyOrSell, referAFriend
   
   var next: WelcomeViewControllerMode? {
      switch self {
		case .dontAbuseSwipeMeal: return .setupProfile
      case .setupProfile: return .addPayments
      case .addPayments: return .buyOrSell
      case .buyOrSell: return .referAFriend
		case .referAFriend: return nil
      }
   }
   
   var previous: WelcomeViewControllerMode? {
      switch self {
		case .dontAbuseSwipeMeal: return nil
      case .setupProfile: return .dontAbuseSwipeMeal
      case .addPayments: return .setupProfile
      case .buyOrSell: return .addPayments
		case .referAFriend: return .buyOrSell
      }
   }
   
   var image: UIImage? {
      switch self {
		case .dontAbuseSwipeMeal: return UIImage(named: "walkthrough-3sm")
      case .setupProfile: return UIImage(named: "walkthrough-1sm")
      case .addPayments: return UIImage(named: "walkthrough-2sm")
		case .buyOrSell: return UIImage(named: "walkthrough-3sm")
		case .referAFriend: return UIImage(named: "walkthrough-1sm")
      }
   }
   
   var mainLabelText: String {
      switch self {
		case .dontAbuseSwipeMeal: return "Unlimited Swipes Prohibited"
      case .setupProfile: return "Setup and Complete Your Profile"
      case .addPayments: return "Add your Payment Options"
      case .buyOrSell: return "Buy or Sell Swipes"
		case .referAFriend: return "Refer a Friend"
      }
   }
   
   var subLabelText: String {
      switch self {
		case .dontAbuseSwipeMeal: return "Swipe Meal does not condone the sale of Swipes if it's prohibited by the school."
      case .setupProfile: return "A complete profile helps others identify you while you buy and/or sell Swipes."
      case .addPayments: return "Setup your payment options to buy and sell Swipes instantly."
      case .buyOrSell: return "You can find Swipes for sale near you or sell Swipes for cash."
		case .referAFriend: return "You can refer a friend via your profile page, and get $1 upon their first buy or sell of a Swipe."
      }
   }
   
   var nextButtonText: String {
		switch self {
		case .dontAbuseSwipeMeal: return "I Agree"
		case .referAFriend: return "Got it!"
		default: return "Next"
		}
   }
   
   var pageControlIndex: Int {
      switch self {
		case .dontAbuseSwipeMeal: return 0
      case .setupProfile: return 1
      case .addPayments: return 2
      case .buyOrSell: return 3
		case .referAFriend: return 4
      }
   }
}

protocol WelcomeViewControllerDelegate: class
{
   func welcomeViewControllerShouldFinish(_ controller: WelcomeViewController)
}

class WelcomeViewController: UIViewController
{
   // MARK: - Outlets
   @IBOutlet fileprivate var _imageView: UIImageView!
   @IBOutlet fileprivate var _mainLabel: UILabel!
   @IBOutlet fileprivate var _subLabel: UILabel!
   @IBOutlet fileprivate var _pageControl: UIPageControl!
   
   @IBOutlet fileprivate var _previousButton: SwipeMealRoundedButton!
   @IBOutlet fileprivate var _nextButton: SwipeMealRoundedButton!
   
   fileprivate var _currentMode = WelcomeViewControllerMode.setupProfile
   
   weak var delegate: WelcomeViewControllerDelegate?
   
   override func viewWillAppear(_ animated: Bool) {
      _currentMode = .dontAbuseSwipeMeal
      _updateUI(_currentMode)
   }
   
   override var preferredStatusBarStyle : UIStatusBarStyle {
      return .lightContent
   }
   
   // MARK: - Private
   fileprivate func _updateUI(_ mode: WelcomeViewControllerMode)
   {
      _imageView.image = mode.image
      _mainLabel.text = mode.mainLabelText
      _subLabel.text = mode.subLabelText
      _pageControl.currentPage = mode.pageControlIndex
      
      _previousButton.isEnabled = mode.previous != nil
      _previousButton.alpha = mode.previous != nil ? 1 : 0.5
      
      UIView.setAnimationsEnabled(false)
      _nextButton.setTitle(mode.nextButtonText, for: UIControlState())
      _nextButton.layoutIfNeeded()
      UIView.setAnimationsEnabled(true)
   }
   
   // MARK: - Actions
   @IBAction internal func _nextButtonPressed()
   {
      if let mode = _currentMode.next {
         _currentMode = mode
         _updateUI(mode)
      }
      else {
         delegate?.welcomeViewControllerShouldFinish(self)
      }
   }
   
   @IBAction internal func _previousButtonPressed()
   {
      guard let mode = _currentMode.previous else { return }
      
      _currentMode = mode
      _updateUI(mode)
   }
}
