//
//  LegalDocumentationViewController.swift
//  SwipeMeal
//
//  Created by Gregory Klein on 9/14/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit
import WebKit

enum LegalDocType {
	case termsOfUse, privacyPolicy
	
	var documentName: String {
		switch self {
		case .termsOfUse: return "swipe_meal_terms_of_use.pdf"
		case .privacyPolicy: return "swipe_meal_privacy_policy.pdf"
		}
	}
	
	var url: URL {
		let path = Bundle.main.path(forResource: documentName, ofType: nil)
		return URL(fileURLWithPath: path!)
	}
}

class LegalDocumentationViewController: UIViewController {
	
	@IBOutlet fileprivate var webView: UIWebView!
	var type: LegalDocType = .termsOfUse
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		
		let request = URLRequest(url: type.url)
		webView.loadRequest(request)
	}
	
	@IBAction fileprivate func _doneButtonPressed() {
		dismiss(animated: true, completion: nil)
	}
}
