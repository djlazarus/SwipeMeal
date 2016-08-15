//
//  ProfileViewController.swift
//  SwipeMeal
//
//  Created by Gregory Klein on 8/15/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
	
	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	// MARK: - Actions
	@IBAction private func _signOutButtonPressed() {
		SMAuthLayer.currentUser?.signOut()
	}
}
