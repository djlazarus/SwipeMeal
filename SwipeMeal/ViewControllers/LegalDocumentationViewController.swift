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
	case TermsOfUse, PrivacyPolicy
	
	var documentName: String {
		switch self {
		case .TermsOfUse: return "swipe_meal_terms_of_use.pdf"
		case .PrivacyPolicy: return "swipe_meal_privacy_policy.pdf"
		}
	}
	
	var url: NSURL {
		let path = NSBundle.mainBundle().pathForResource(documentName, ofType: nil)
		return NSURL.fileURLWithPath(path!)
	}
}

class LegalDocumentationViewController: UIViewController {
	
	@IBOutlet private var webView: UIWebView!
	var type: LegalDocType = .TermsOfUse
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(true)
		
		let request = NSURLRequest(URL: type.url)
		webView.loadRequest(request)
	}
	
	@IBAction private func _doneButtonPressed() {
		dismissViewControllerAnimated(true, completion: nil)
	}
}
