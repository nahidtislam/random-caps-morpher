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
        
        @Published var userText: String
        @Published var morphed: String
        /// the determinant on how much uppercasing we will do on output
        @Published var upperCaseness: Int
        
        @Published private(set) var morphedTextIsEmpty: Bool
        /// this is used for validation when it's ready to show the output to the user
        /// should be used in a notification sense
        @Published var shouldShowMorped: Bool
        
        private var cancelables: Set<AnyCancellable> = .init()
        
        convenience init() {
            self.init(userText: .init(), morphed: .init(), upperCaseness: 5, shouldShowMorped: false)
        }
        
        init(userText: String, morphed: String, upperCaseness: Int, morphedTextIsEmpty: Bool? = nil, shouldShowMorped: Bool) {
            self.userText = userText
            self.morphed = morphed
            self.upperCaseness = upperCaseness
            
            self.morphedTextIsEmpty = morphedTextIsEmpty ?? morphed.isEmpty
            self.shouldShowMorped = shouldShowMorped
            
            self.cancelables = .init()
            
            setupSubscribers()
        }
        
        /// prepares the relevant varibles to update eachother as effeciently as possible
        private func setupSubscribers() {
            $userText
                .debounce(for: .milliseconds(75), scheduler: DispatchQueue.main)
                .combineLatest($upperCaseness)
                .debounce(for: .milliseconds(25), scheduler: DispatchQueue.main)
                .map(performMorph)
                .sink { [weak self] morphed in
                    guard let self else { return }
                    self.morphed = morphed
                    self.morphedTextIsEmpty = morphed.isEmpty
                    self.shouldShowMorped = morphed.count > 3
                }
                .store(in: &cancelables)
//                .assign(to: &$morphed)
                
        }
        
        private func performMorph(on text: String, upCaseness: Int) -> String {
            var output: String = .init()
            
            // TODO: figure out how to map the string's character
            text.trimmingCharacters(in: .whitespacesAndNewlines).forEach { character in
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
