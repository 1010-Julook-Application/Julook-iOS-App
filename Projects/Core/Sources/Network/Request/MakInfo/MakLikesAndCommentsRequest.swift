//
//  MakgeolliLikesAndCommentsRequest.swift
//  Core
//
//  Created by Kim SungHun on 2023/11/06.
//  Copyright © 2023 com.tenten. All rights reserved.
//

import Foundation

public struct MakLikesAndCommentsRequest: Codable {
	let makNumber: Int
	let offset: Int
	
	public init(makNumber: Int, offset: Int = 0) {
		self.makNumber = makNumber
		self.offset = offset
	}
}
