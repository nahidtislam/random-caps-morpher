//
//  MorpherView+ViewModel.swift
//  random caps morpher
//
//  Created by Nahid Islam on 23/10/2023.
//

import Combine

extension MorpherView {
    class ViewModel: ObservableObject {
        
        @Published var userText: String = .init()
        @Published var morphed: String = .init()
        @Published var upperCaseness: Int = .init()
        
        private var cancelables: Set<AnyCancellable> = .init()
        
    }
}
