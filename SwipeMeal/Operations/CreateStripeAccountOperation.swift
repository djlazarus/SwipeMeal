//
//  CreateStripeAccountOperation.swift
//  SwipeMeal
//
//  Created by Gregory Klein on 9/8/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit
import SwiftSpinner

// Return IP address of WiFi interface (en0) as a String, or `nil`
func getIFAddresses() -> [String] {
	var addresses = [String]()
	
	// Get list of all interfaces on the local machine:
	var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
	if getifaddrs(&ifaddr) == 0 {
		
		// For each interface ...
		var ptr = ifaddr
		while ptr != nil {
			defer { ptr = ptr?.pointee.ifa_next }
			
			let flags = Int32((ptr?.pointee.ifa_flags)!)
			var addr = ptr?.pointee.ifa_addr.pointee
			
			// Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
			if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
				if addr?.sa_family == UInt8(AF_INET) || addr?.sa_family == UInt8(AF_INET6) {
					
					// Convert interface address to a human readable string:
					var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
					if (getnameinfo(&addr!, socklen_t((addr?.sa_len)!), &hostname, socklen_t(hostname.count),
						nil, socklen_t(0), NI_NUMERICHOST) == 0) {
						if let address = String(validatingUTF8: hostname) {
							addresses.append(address)
						}
					}
				}
			}
		}
		freeifaddrs(ifaddr)
	}
	return addresses
}

class CreateStripeAccountOperation: BaseOperation {
	
	let _user: SwipeMealUser
	
	init(user: SwipeMealUser) {
		_user = user
		super.init()
	}
	
	override func execute() {
		guard let email = _user.email, let ipAddress = getIFAddresses().first else {
			finish()
			return
		}
		
		SwiftSpinner.show("Creating Stripe Account...")
		let service = StripePaymentService.shared()
		
		print("creating account for: \(email), with ipAddress: \(ipAddress)")
		service?.createCustomer(withUserID: _user.uid, email: email, ipAddress: ipAddress) { (info, error) in
			if error != nil {
				self.error = error as NSError?
			}
			
			SwiftSpinner.hide()
			self.finish()
		}
	}
}
