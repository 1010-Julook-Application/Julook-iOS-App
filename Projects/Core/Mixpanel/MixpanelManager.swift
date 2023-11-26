//
//  MixpanelManager.swift
//  Core
//
//  Created by Eric Lee on 11/26/23.
//  Copyright © 2023 com.teamten. All rights reserved.
//

import Foundation
import Mixpanel

final public class MixpanelManager {
	static public let shared = MixpanelManager()
	
	public func initMixpanel() {
		if let apiKey = Bundle.main.infoDictionary?["MIXPANEL_API_KEY"] as? String {
			Mixpanel.initialize(token: apiKey, trackAutomaticEvents: true)
		} else {
			print("Mixpanel API key not found")
		}
	}
}

// MARK: - User Profiles
extension MixpanelManager {
	public func setUserProfile(userId: String, name: String, sex: String, yearOfBirth: String, signupMethod: SignUpMethod) {
		Mixpanel.mainInstance().identify(distinctId: userId)
		Mixpanel.mainInstance().people.set(property: "$name", to: name)
		Mixpanel.mainInstance().people.set(property: "sex", to: sex)
		Mixpanel.mainInstance().people.set(property: "yearOfBirth", to: yearOfBirth)
		Mixpanel.mainInstance().people.set(property: signupMethod.mpProperty, to: signupMethod.mpMixpanelType)
		Mixpanel.mainInstance().flush()
	}
}

// MARK: - Sign Up
extension MixpanelManager {
	public func signupEvent(method: SignUpMethod) {
		Mixpanel.mainInstance().track(event: EventName.signup.mpName, properties: [method.mpProperty : method.mpMixpanelType])
	}
	
	public func signupStart() {
		Mixpanel.mainInstance().time(event: EventName.signup.mpName)
	}
	
}
