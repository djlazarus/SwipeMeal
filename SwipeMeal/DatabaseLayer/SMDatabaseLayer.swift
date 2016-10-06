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
private let kProfileImagesPathName = "profile_images"

private let kUsersPathName = "users"
private let kUserInfoPathName = "user_info"
private let kUserGroupsPathName = "user-groups"
private let kUserProfileSetupCompletePathName = "profile_setup_complete"
private let kUserRatingsPathName = "ratings"

typealias UserDataUploadCompletion = (_ error: NSError?, _ downloadURL: URL?) -> Void

@objc class SMDatabaseLayer: NSObject
{
	static func upload(_ profileImage: UIImage, forSwipeMealUser user: SwipeMealUser, completion: UserDataUploadCompletion? = nil)
	{
		guard let imageData = UIImageJPEGRepresentation(profileImage, 0.5) else { return }
		
		let storage = FIRStorage.storage()
		let imagesRef = storage.reference(forURL: kStorageURL).child(kProfileImagesPathName)
		
		let fileName = "\(user.uid).jpg"
		let profileImageRef = imagesRef.child(fileName)
		
		profileImageRef.put(imageData, metadata: nil) { (metadata, error) in
			
			let url = metadata?.downloadURL()
			completion?(error as NSError?, url)
		}
	}
	
	static func setProfileSetupComplete(_ complete: Bool, forUser user: SwipeMealUser)
	{
		let ref = FIRDatabase.database().reference()
		let userInfoRef = ref.child(kUsersPathName).child("\(user.uid)/\(kUserInfoPathName)")
		userInfoRef.updateChildValues([kUserProfileSetupCompletePathName : complete])
		
		let storage = SwipeMealUserStorage(user: user)
		storage.profileSetupComplete = complete
		
		if let referralUID = SwipeMealUserStorage.referralUID {
			userInfoRef.updateChildValues(["referral_uid" : referralUID])
		}
	}
	
	static func addUserToDatabase(_ user: SwipeMealUser)
	{
		let ref = FIRDatabase.database().reference()
		let userInfoRef = ref.child(kUsersPathName).child("\(user.uid)/\(kUserInfoPathName)")
		
		let storage = SwipeMealUserStorage(user: user)
		userInfoRef.updateChildValues([kUserProfileSetupCompletePathName : storage.profileSetupComplete])
	}
	
	static func profileSetupComplete(_ user: SwipeMealUser, callback: @escaping ((_ complete: Bool) -> ()))
	{
//		let ref = FIRDatabase.database().reference()
//		let userInfoRef = ref.child("\(kUsersPathName)/\(user.uid)/\(kUserInfoPathName)")
//		userInfoRef.observeSingleEvent(of: .value, with: { (snapshot) in
		
//			var complete = false
//			if let readValue = snapshot.value?[kUserProfileSetupCompletePathName] as? Bool {
//				complete = readValue
//			}
//			callback(complete)
//		})
	}
	
	static func addUserToRespectiveGroup(_ user: SwipeMealUser) {
		guard let groupID = user.groupID else { return }
		
		let ref = FIRDatabase.database().reference()
		let userGroupRef = ref.child("\(kUserGroupsPathName)/\(groupID)")
		userGroupRef.updateChildValues([user.uid : true])
		
		let userRef = ref.child(kUsersPathName).child(user.uid)
		userRef.updateChildValues(["group_id" : groupID])
	}
	
	static func generateFakeRatings(forUser user: SwipeMealUser) {
		let fakeUIDs = ["uid1", "uid2", "uid3", "uid4", "uid5", "uid6", "uid7", "uid8"]
		
		fakeUIDs.forEach {
			let randomRating = Int(arc4random_uniform(5))
			add(rating: randomRating, toUserWithUID: user.uid, fromUserWithUID: $0)
		}
	}
	
	static func requestRatings(forUser user: SwipeMealUser, callback: @escaping (_ ratings: [String : Int]) -> Void) {
		let ref = FIRDatabase.database().reference()
		let userRatingsRef = ref.child("\(kUserRatingsPathName)/\(user.uid)")
		
		userRatingsRef.observeSingleEvent(of: .value, with: { (snapshot) in
			var ratings: [String : Int] = [:]
			let enumerator = snapshot.children
			while let child = enumerator.nextObject() as? FIRDataSnapshot {
				print(child)
				if let value = child.value as? Int {
					ratings[child.key] = value
				}
			}
			callback(ratings)
		})
	}
	
	static func add(rating: Int, toUserWithUID toUID: String, fromUserWithUID fromUID: String) {
		let ref = FIRDatabase.database().reference()
		let userRatingsRef = ref.child("\(kUserRatingsPathName)/\(toUID)")
		userRatingsRef.updateChildValues([fromUID : rating])
	}
	
	static func update(deviceToken token: String, forUser user: SwipeMealUser) {
		let ref = FIRDatabase.database().reference()
		let userInfoRef = ref.child(kUsersPathName).child("\(user.uid)/\(kUserInfoPathName)")
		userInfoRef.updateChildValues(["deviceToken": token])
	}
	
	static func getDeviceToken(forUserWithUID uid: String, callback: @escaping (_ token: String?) -> Void) {
		let ref = FIRDatabase.database().reference()
		let userInfoRef = ref.child("\(kUsersPathName)/\(uid)/\(kUserInfoPathName)")
		userInfoRef.observeSingleEvent(of: .value, with: { (snapshot) in
			
			var token: String?
			let value = snapshot.value as? NSDictionary
			if let readValue = value?["deviceToken"] as? String {
				token = readValue
			}
			
			callback(token)
		})
	}
	
	static func getOneSignalPlayerID(forUserWithUID uid: String, callback: @escaping (_ oneSignalPlayerID: String?) -> Void) {
		let ref = FIRDatabase.database().reference()
		let userInfoRef = ref.child("\(kUsersPathName)/\(uid)/\(kUserInfoPathName)")
		userInfoRef.observeSingleEvent(of: .value, with: { (snapshot) in
			
			var playerID: String?
			let value = snapshot.value as? NSDictionary
			if let readValue = value?["oneSignalPlayerID"] as? String {
				playerID = readValue
			}
			
			callback(playerID)
		})
	}
	
	static func getReferralUID(forUserWithUID uid: String, callback: @escaping (_ referralUID: String?) -> Void) {
		let ref = FIRDatabase.database().reference()
		let userInfoRef = ref.child("\(kUsersPathName)/\(uid)/\(kUserInfoPathName)")
		userInfoRef.observeSingleEvent(of: .value, with: { (snapshot) in
			
			var referralUserUID: String?
			let value = snapshot.value as? NSDictionary
			if let readValue = value?["referral_uid"] as? String {
				referralUserUID = readValue
			}
			
			callback(referralUserUID)
		})
	}
	
	static func update(oneSignalPlayerID id: String, forUser user: SwipeMealUser) {
		let ref = FIRDatabase.database().reference()
		let userInfoRef = ref.child(kUsersPathName).child("\(user.uid)/\(kUserInfoPathName)")
		userInfoRef.updateChildValues(["oneSignalPlayerID": id])
	}
}
