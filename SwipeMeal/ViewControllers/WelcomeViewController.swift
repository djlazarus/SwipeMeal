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
   case SetupProfile, AddPayments, BuyOrSell
   
   var next: WelcomeViewControllerMode? {
      switch self {
      case .SetupProfile: return .AddPayments
      case .AddPayments: return .BuyOrSell
      case .BuyOrSell: return nil
      }
   }
   
   var previous: WelcomeViewControllerMode? {
      switch self {
      case .SetupProfile: return nil
      case .AddPayments: return .SetupProfile
      case .BuyOrSell: return .AddPayments
      }
   }
   
   var image: UIImage? {
      switch self {
      case .SetupProfile: return UIImage(named: "walkthrough-1sm")
      case .AddPayments: return UIImage(named: "walkthrough-2sm")
      case .BuyOrSell: return UIImage(named: "walkthrough-3sm")
      }
   }
   
   var mainLabelText: String {
      switch self {
      case .SetupProfile: return "Setup and complete your profile"
      case .AddPayments: return "Add your payment options"
      case .BuyOrSell: return "Buy or sell Swipes"
      }
   }
   
   var subLabelText: String {
      switch self {
      case .SetupProfile: return "A complete profile helps others identify you while you buy and/or sell Swipes."
      case .AddPayments: return "Setup your payment options to buy and sell Swipes instantly."
      case .BuyOrSell: return "You can find Swipes for sale near you or sell Swipes for cash."
      }
   }
   
   var nextButtonText: String {
      return self != .BuyOrSell ? "Next" : "Got it!"
   }
   
   var pageControlIndex: Int {
      switch self {
      case .SetupProfile: return 0
      case .AddPayments: return 1
      case .BuyOrSell: return 2
      }
   }
}

protocol WelcomeViewControllerDelegate: class
{
   func welcomeViewControllerShouldFinish(controller: WelcomeViewController)
}

class WelcomeViewController: UIViewController
{
   // MARK: - Outlets
   @IBOutlet private var _imageView: UIImageView!
   @IBOutlet private var _mainLabel: UILabel!
   @IBOutlet private var _subLabel: UILabel!
   @IBOutlet private var _pageControl: UIPageControl!
   
   @IBOutlet private var _previousButton: SwipeMealRoundedButton!
   @IBOutlet private var _nextButton: SwipeMealRoundedButton!
   
   private var _currentMode = WelcomeViewControllerMode.SetupProfile
   
   weak var delegate: WelcomeViewControllerDelegate?
   
   override func viewWillAppear(animated: Bool) {
      _currentMode = .SetupProfile
      _updateUI(_currentMode)
   }
   
   override func preferredStatusBarStyle() -> UIStatusBarStyle {
      return .LightContent
   }
   
   // MARK: - Private
   private func _updateUI(mode: WelcomeViewControllerMode)
   {
      _imageView.image = mode.image
      _mainLabel.text = mode.mainLabelText
      _subLabel.text = mode.subLabelText
      _pageControl.currentPage = mode.pageControlIndex
      
      _previousButton.enabled = mode.previous != nil
      _previousButton.alpha = mode.previous != nil ? 1 : 0.5
      
      UIView.setAnimationsEnabled(false)
      _nextButton.setTitle(mode.nextButtonText, forState: .Normal)
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
