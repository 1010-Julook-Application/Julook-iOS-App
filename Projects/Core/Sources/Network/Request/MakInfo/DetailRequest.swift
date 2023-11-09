//
//  MakgeolliRequest.swift
//  Core
//
//  Created by Kim SungHun on 2023/11/02.
//  Copyright © 2023 com.tenten. All rights reserved.
//

import Foundation

public struct DetailRequest: Codable {
	let makNumber: Int
	let userId: Int
	
	public init(makNumber: Int, userId: Int) {
		self.makNumber = makNumber
		self.userId = userId
	}
}
