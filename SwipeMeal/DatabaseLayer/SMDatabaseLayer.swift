//
//  SMDatabaseLayer.swift
//  SwipeMeal
//
//  Created by Gregory Klein on 6/9/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit
import Firebase

private let kStorageURL = "gs://project-3806765351218467701.appspot.com"
private let kProfileImagesPathName = "profileImages"

typealias UserDataUploadCompletion = (error: NSError?, downloadURL: NSURL?) -> Void

struct SMDatabaseLayer
{
	static func upload(profileImage: UIImage, forSwipeMealUser user: SwipeMealUser, completion: UserDataUploadCompletion? = nil)
	{
		guard let imageData = UIImageJPEGRepresentation(profileImage, 0.5) else {
			return
		}
		
		let storage = FIRStorage.storage()
		let imagesRef = storage.referenceForURL(kStorageURL).child(kProfileImagesPathName)
		
		let fileName = "\(user.uid).jpg"
		let profileImageRef = imagesRef.child(fileName)
		
		profileImageRef.putData(imageData, metadata: nil) { (metadata, error) in
			
			let url = metadata?.downloadURL()
			completion?(error: error, downloadURL: url)
		}
	}
}
