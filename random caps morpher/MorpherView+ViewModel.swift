//
//  MorpherView+ViewModel.swift
//  random caps morpher
//
//  Created by Nahid Islam on 23/10/2023.
//

import SwiftUI
import Combine

extension MorpherView {
    class ViewModel: ObservableObject {
        
        @Published var userText: String = .init()
        @Published var morphed: String = .init()
        @Published var upperCaseness: Int = .init()
        
        private var cancelables: Set<AnyCancellable> = .init()
        
        
        
        private func setupSubscribers() {
            $userText
                .debounce(for: .milliseconds(75), scheduler: DispatchQueue.main)
                .combineLatest($upperCaseness)
                .map(performMorph)
                .assign(to: &$morphed)
                
        }
        
        private func performMorph(on text: String, upCaseness: Int) -> String {
            var output: String = .init()
            
            text.forEach { character in
                output += Int.random(in: 0..<10) < upCaseness ? text.uppercased() : text.lowercased()
            }
            
            return output
        }
    }
}
