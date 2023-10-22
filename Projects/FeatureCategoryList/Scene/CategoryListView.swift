//
//  CategoryListView.swift
//  ProjectDescriptionHelpers
//
//  Created by Kim SungHun on 2023/10/20.
//

import SwiftUI
import DesignSystem
import Common
import Core

public struct CategoryListView: View {
	@StateObject private var viewModel = CategoryListViewModel()
	
	let type: CategoryType
	
	@State var targetTitle: String
	
	public init(type: CategoryType, targetTitle: String) {
		self.type = type
		self.targetTitle = targetTitle
	}
	
	public var body: some View {
		VStack {
			HashtagView(viewModel: viewModel,
						type: self.type,
						targetTitle: $targetTitle)
				.padding(.leading, 16)
			
			Spacer()
				.frame(height: 16)
			
			if viewModel.fetchLoading {
				ProgressView()
					.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
			} else {
				MakgeolliInfoView()
					.padding(.horizontal, 16)
			}
		}
		.background(Color(uiColor: .designSystem(.bgColor)!))
		.navigationTitle(targetTitle)
		.navigationBarTitleDisplayMode(.inline)
		.navigationBarBackButtonHidden(true)
		.navigationBarItems(leading: CustomBackButton())
		.onAppear {
			viewModel.fetchCategoryList()
		}
	}
}