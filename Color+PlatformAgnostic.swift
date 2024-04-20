//
//  Color+PlatformAgnostic.swift
//  random caps morpher
//
//  Created by Nahid Islam on 20/04/2024.
//

import SwiftUI

// this makes really easy to work tge colors across systems
private extension Color {
    static var systemBackground: Color {
        #if os(macOS)
        .init(nsColor: .controlBackgroundColor)
        #else
        .init(uiColor: .systemBackground)
        #endif
    }
    
    static var secondarySystemBackground: Color {
        #if os(macOS)
        .init(nsColor: NSColor.scrubberTexturedBackground)
        #else
        .init(uiColor: .secondarySystemBackground)
        #endif
    }
    static var systemGray6: Color {
        #if os(macOS)
        .init(#colorLiteral(red: 0.8948548286, green: 0.8948548286, blue: 0.8948548286, alpha: 1))
        #else
        .init(uiColor: .systemGray6)
        #endif
    }
    
    static var textBackgroundColor: Color {
        #if os(macOS)
        Color(nsColor: .textBackgroundColor)
        #else
        Color(uiColor: .systemBackground)
        #endif
    }
}
