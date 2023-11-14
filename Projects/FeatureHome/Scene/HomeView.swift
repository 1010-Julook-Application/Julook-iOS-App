//
//  MainView.swift
//  ProjectDescriptionHelpers
//
//  Created by Kim SungHun on 2023/10/06.
//

import SwiftUI
import Core
import DesignSystem
import FeatureCategory

public struct HomeView: View {
	@StateObject var viewModel = HomeViewModel(
		makgeolliRepository: DefaultMakgeolliRepository(),
		homeRepository: DefaultHomeRepository()
	)
	
	@State var viewOpacityValue = 0.0
	
	public init() {}
	
	public var body: some View {
		if viewModel.fetchLoading {
			ProgressView()
				.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
				.tint(Color(uiColor: .designSystem(.white)!))
				.onAppear {
					viewModel.fetchNewMakList()
					viewModel.fetchRecentComments()
				}
		} else {
			NavigationStack {
				ScrollView(showsIndicators: false) {
					VStack {
						NavigationLink {
							CategoryView(type: .event, targetTitle: [.none])
						} label: {
							Image(uiImage: .designSystem(.banner)!)
								.resizable()
								.aspectRatio(contentMode: .fill)
								.padding(.bottom, 20)
						}
						
						CharacteristicsView()
						
						DividerView(topPadding: 10, bottomPadding: 20)
						
						NewItemView(viewModel: viewModel)
						
						DividerView(topPadding: 10, bottomPadding: 20)
						
						LatestCommentView(viewModel: viewModel)
					}
				}
				.ignoresSafeArea(.all, edges: .top)
				.opacity(viewOpacityValue)
				.onAppear {
					withAnimation {
						self.viewOpacityValue = 1.0
					}
				}
				.background(Color(uiColor: .designSystem(.darkbase)!))
			}
		}
	}
}
