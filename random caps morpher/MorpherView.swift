//
//  MorpherView.swift
//  random caps morpher
//
//  Created by Nahid Islam on 23/10/2023.
//

import SwiftUI

struct MorpherView: View {
    
    @StateObject var vm: ViewModel = .init()
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    @State private var isLandscape: Bool = false
    
    var body: some View {
        VStack {
            clearButton
            .frame(maxWidth: .infinity, alignment: .topTrailing)
            
            if compactHeight {
                HStack {
                    displayableData
                }
            } else {
                
                VStack {
                    displayableData
                }
            }
        }
        .animation(.spring(response: 0.2, dampingFraction: 2, blendDuration: 0.1), value: vm.morphedTextIsEmpty)
        .padding()
        .background {
            bg
            .ignoresSafeArea()
        }
        .onRotate { orientation in
            isLandscape = orientation != .portrait
        }
    }
    
    private var compactHeight: Bool {
        verticalSizeClass == .compact && isLandscape
    }
    
    @ViewBuilder
    private var displayableData: some View {
        inputField
            #if os(macOS)
            .frame(minWidth: 800, minHeight: 450)
            #endif
        if vm.morphedTextIsEmpty {
            directionToUser
        } else {
            VStack {
                controls
                output
            }
            .transition(controlTransition)
        }
    }
    
    private var controlTransition: AnyTransition {
        let base: AnyTransition = compactHeight ? .identity : .move(edge: .bottom)
        let scaleAnchor: UnitPoint = compactHeight ? .leading : .bottom
        
        let animation: Animation = .spring(response: 0.3, dampingFraction: 1.5, blendDuration: 0.2).speed(1.5)
        
        return base
                .combined(with: .opacity)
                .combined(with: .scale(scale: 0.85, anchor: scaleAnchor))
                .animation(animation)
    }
    
    private var sliderValue: Binding<Double> {
        .init {
            .init(vm.upperCaseness)
        } set: { newValue in
            vm.upperCaseness = .init(newValue)
        }

    }
    
    private var bg: Color {
        let dark: Color
        let light: Color
        
        dark = .secondarySystemBackground
        light = .systemGray6
        
        return colorScheme == .dark ? dark : light
    }
    
    private var inputField: some View {
        TextEditor(text: $vm.userText)
            .padding()
            .background {
                Color.textBackgroundColor
            }
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
    
    private var clearButton: some View {
        Button(role: .destructive) {
            vm.userText = ""
        } label: {
            Label("clear", systemImage: vm.morphedTextIsEmpty ? "clear.fill" : "clear")
        }
        .disabled(vm.userText.isEmpty)
    }
    
    private var copyButton: some View {
        Button(action: vm.copyToClipboard) {
            Label("copy", systemImage: "arrow.right.doc.on.clipboard")
        }
        .buttonStyle(.bordered)
        .keyboardShortcut(KeyEquivalent("c"), modifiers: .command)
        .disabled(vm.morphed.count < 4)
    }
    
    private var controls: some View {
        HStack {
            if compactHeight { copyButton }
            Slider(value: sliderValue, in: 3...7, step: 1.0)
            if !compactHeight { copyButton }
        }
        .onAppear {
            vm.upperCaseness = 4
        }
    }
    
    private var output: some View {
        Text(vm.morphed)
            .padding()
            .frame(maxWidth: .infinity, alignment: .trailing)
            .background {
                
                Color.systemBackground.opacity(colorScheme == .dark ? 0.2 : 0.6)
            }
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }
    
    private var directionToUser: some View {
        Text("enter text ") + Text(compactHeight ? "on side" : "above")
    }
}

#Preview {
    MorpherView()
}

extension Color {
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
