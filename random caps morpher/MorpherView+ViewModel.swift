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
        @Published var shouldShowMorped: Bool = false
        
        private var cancelables: Set<AnyCancellable> = .init()
        
        convenience init() {
            self.init(userText: .init(), morphed: .init(), upperCaseness: 5, shouldShowMorped: false, cancelables: .init())
        }
        
        init(userText: String, morphed: String, upperCaseness: Int, shouldShowMorped: Bool, cancelables: Set<AnyCancellable>) {
            self.userText = userText
            self.morphed = morphed
            self.upperCaseness = upperCaseness
            self.shouldShowMorped = shouldShowMorped
            self.cancelables = cancelables
            
            setupSubscribers()
        }
        
        func setupSubscribers() {
            $userText
                .debounce(for: .milliseconds(75), scheduler: DispatchQueue.main)
                .combineLatest($upperCaseness)
                .debounce(for: .milliseconds(25), scheduler: DispatchQueue.main)
                .map(performMorph)
                .assign(to: &$morphed)
                
        }
        
        private func performMorph(on text: String, upCaseness: Int) -> String {
            var output: String = .init()
            
            text.forEach { character in
                output += Int.random(in: 0..<10) < upCaseness ? character.uppercased() : character.lowercased()
            }
            
            return output
        }
        
        public func copyToClipboard() {
            #if os(macOS)
            NSPasteboard.general.declareTypes([.string], owner: nil)
            NSPasteboard.general.setString(morphed, forType: .string)
            #else
            UIPasteboard.general.setValue(morphed, forPasteboardType: "public.plain-text")
            #endif
        }
    }
}
