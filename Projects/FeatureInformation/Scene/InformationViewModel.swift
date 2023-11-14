//
//  InformationViewModel.swift
//  FeatureInformation
//
//  Created by Eric Lee on 11/4/23.
//  Copyright © 2023 com.tenten. All rights reserved.
//

import SwiftUI
import Core
import Utils

final class InformationViewModel: ObservableObject {
	
	let makHolyId: Int
	let userId: Int = Int(KeyChainManager.shared.read(account: .userId)) ?? -1
	let maHolyRepo: DefaultMakgeolliRepository
	let userRepo: DefaultUserRepository
	
	init(makHolyId: Int, maHolyRepo: DefaultMakgeolliRepository, userRepo: DefaultUserRepository) {
		self.makHolyId = makHolyId
		self.maHolyRepo = maHolyRepo
		self.userRepo = userRepo
	}
	
	@Published var isFetchCompleted: Bool = false
	@Published var makHoly: MakHoly = MakHoly()
	@Published var myReaction: MyReaction = MyReaction()
	@Published var likeDetail: LikeDetail = LikeDetail()
	@Published var comments: [VisibleComment] = []
	
	@Published var showActionSheet: Bool = false
	@Published var showCommentSheet: Bool = false
	@Published var showDetailCommentListSheet: Bool = false
	@Published var showDeleteAlert: Bool = false
	@Published var commentText: String = ""
	
	private var user: User = User.user1
	
	@MainActor
	func fetchDatas() {
		Task {
			await withTaskGroup(of: Void.self) { group in
				group.addTask {
					await self.fetchMakHoly()
				}
				group.addTask {
					await self.fetchReactions()
				}
				
				for _ in 0..<2 {
					await group.next()
				}
				
				isFetchCompleted = true
			}
		}
	}
	
	// detail api
	@MainActor
	func fetchMakHoly() {
		Task {
			
			do {
				let result = try await maHolyRepo.fetchDetail(makNumber: self.makHolyId, userId: self.userId)
				self.makHoly = result.0
				self.myReaction = result.1
				print("fetchMakHoly Completed : -------")
				print("makHoly : \(makHoly)")
				print("myReaction : \(myReaction)")
				print("----------------------------------")
			} catch {
				Logger.debug(error: error, message: "InformationViewModel -fetchMakHoly()")
			}
			
		}
	}
	
	// makLikesAndComments  api
	@MainActor
	func fetchReactions() {
		Task {
			
			do {
				let result = try await maHolyRepo.fetchMakLikesAndComments(makNumber: self.makHolyId)
				self.likeDetail = result.0
				self.comments = result.1
				print("fetchReactions Completed : -------")
				print("likeDetail : \(likeDetail)")
				print("comments : \(comments)")
				print("----------------------------------")
			} catch {
				Logger.debug(error: error, message: "InformationViewModel -fetchReactions()")
			}
			
		}
	}
	
	// Comment Visibe 변경
	@MainActor 
	func toggleCommentVisible() {
		
		self.myReaction.comment?.isVisible.toggle()
		
		// Comment Visible 업데이트 API 연결
		guard let comment = myReaction.comment else {
			return
		}
		self.updateComment(myComment: MyComment(isVisible: comment.isVisible, contents: comment.contents, date: "데이트 추가"))
	}
	
	func likeButtonTapped() {
		
		switch self.myReaction.likeState {
		case .like:
			self.myReaction.likeState = .none
		default:
			self.myReaction.likeState = .like
		}
		
	}
	
	func dislikeButtonTapped() {
		
		switch self.myReaction.likeState {
		case .dislike:
			self.myReaction.likeState = .none
		default:
			self.myReaction.likeState = .dislike
		}
		
	}
	
	@MainActor
	func postLikeState() {
		Task {
			do {
				let response = try await userRepo.evaluateMak(EvaluateMakRequest(
					userId: self.userId,
					makNumber: self.makHolyId,
					likeState: self.myReaction.likeState))
				print("postLikeState Completed : -------")
				print("response : \(response)")
				print("----------------------------------")
			} catch {
				Logger.debug(error: error, message: "InformationViewModel -postLikeState()")
			}
		}
	}
	
	@MainActor 
	func toggleBookMark() {
		myReaction.isBookMarked.toggle()
		if self.myReaction.isBookMarked {
			addBookMark()
		} else {
			deleteBookMark()
		}
	}
	
	@MainActor
	func addBookMark() {
		Task {
			do {
				let response = try await userRepo.addWishList(WishListRequest(userId: self.userId, makNumber: 1))
				print("addBookMark Completed : -------")
				print("response : \(response)")
				print("----------------------------------")
			} catch {
				Logger.debug(error: error, message: "InformationViewModel -addBookMark()")
			}
		}
	}
	
	@MainActor
	func deleteBookMark() {
		Task {
			do {
				let response = try await userRepo.deleteWishList(WishListRequest(userId: self.userId, makNumber: 1))
				print("deleteBookMark Completed : -------")
				print("response : \(response)")
				print("----------------------------------")
			} catch {
				Logger.debug(error: error, message: "InformationViewModel -deleteBookMark()")
			}
		}
	}

	@MainActor
	func deleteComment() {
		Task {
			do {
				let response = try await userRepo.deleteComment(DeleteCommentRequest(userId: self.userId, makNumber: self.makHolyId))
				print("deleteComment Completed : -------")
				print("response : \(response)")
				print("----------------------------------")
				//TODO: reponse 확인 로직
				self.myReaction.comment = nil
			} catch {
				Logger.debug(error: error, message: "InformationViewModel -deleteComment()")
			}
		}
	}
	
	@MainActor
	func updateComment(myComment: MyComment) {
		Task {
			do {
				let response = try await userRepo.updateComment(
					UpdateCommentRequest(userId: self.userId, makNumber: self.makHolyId, contents: myComment.contents, isVisible: myComment.isVisible))
				print("deleteComment Completed : -------")
				print("response : \(response)")
				print("----------------------------------")
				//TODO: reponse 확인 로직
				self.myReaction.comment = myComment
			} catch {
				Logger.debug(error: error, message: "InformationViewModel -deleteComment()")
			}
		}
	}
	
	@MainActor
	func insertComment(myComment: MyComment) {
		Task {
			do {
				let response = try await userRepo.insertComment(InsertCommentRequest(userId: self.userId, makNumber: self.makHolyId, contents: myComment.contents, isVisible: myComment.isVisible))
				print("deleteComment Completed : -------")
				print("response : \(response)")
				print("----------------------------------")
				//TODO: reponse 확인 로직
				self.myReaction.comment = myComment
			} catch {
				Logger.debug(error: error, message: "InformationViewModel -deleteComment()")
			}
		}
	}
	
}


