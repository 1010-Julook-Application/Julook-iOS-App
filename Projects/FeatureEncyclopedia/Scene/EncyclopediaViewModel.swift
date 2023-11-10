//
//  EncyclopediaViewModel.swift
//  FeatureEncyclopedia
//
//  Created by 박지은 on 2023/11/10.
//  Copyright © 2023 com.tenten. All rights reserved.
//

import Foundation
import Core
import Utils

final class EncyclopediaViewModel: ObservableObject {
    @Published var testModel: [GetUserMakFolderContent] = []
    
    var fetchLoading = false
    
    let userRepository: DefaultUserRepository
    
    init(userRepository: DefaultUserRepository) {
        self.userRepository = userRepository
    }
    
    // getUserMakFolder 호출
    @MainActor
    func getUserMakFolder() {
        Task {
            do {
                let response = try await self.userRepository.getUserMakFolder(GetUserMakFolderRequest(userId: 1578568449))
                testModel = (response.result?.makUserTable!.content!) ?? []
                print("resposne = \(response)")
                
                fetchLoading = true
            } catch {
                Logger.debug(error: error, message: "")
            }
        }
    }
}
