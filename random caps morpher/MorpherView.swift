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
            HStack {
                // iOS 17 only as they have the nice counter API
                // backporting not essential as it's more of a nice to have feature
                if #available(iOS 17, *), #available(macOS 14, *) {
                    Text(vm.morphed.count, format: .number)
                        .contentTransition(.numericText(value: Double(vm.morphed.count)))
                        .animation(.default, value: vm.morphed.count)
                }
                
                Spacer()
                clearButton
            }
            
            
            // side-by-side view only looks good on iPhone
            if compactHeight {
                HStack {
                    displayableData
                }
            } else {
                VStack {
                    displayableData
                }
                .padding(.all, vm.morphedTextIsEmpty ? -8 : 0)
            }
        }
        .animation(.spring(response: 0.2, dampingFraction: 2, blendDuration: 0.1), value: vm.morphedTextIsEmpty)
        .padding()
        .background {
            bg
            .ignoresSafeArea()
        }
        #if os(iOS)
        .onRotate { orientation in
            isLandscape = orientation != .portrait
        }
        #endif
    }
    
    ///  determine if we on an iPhone while on landscape
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
        
        /// adjusts the vibe of the appearing & disapearing transition.
        /// I also want to say even I called `.spring` to get  the animation, it will *not* making it bouncy. This is by design as bouncy animation doesn't feel in place on this app
        let animation: Animation = .spring(response: 0.3, dampingFraction: 1.5, blendDuration: 0.2).speed(1.5)
        
        return base
            .combined(with: .opacity)
            .combined(with: .scale(scale: 0.85, anchor: scaleAnchor))
            .animation(animation)
    }
    
    /// adjust ]s how nuch uppercasing do we want on output
    private var sliderValue: Binding<Double> {
        .init {
            .init(vm.upperCaseness)
        } set: { newValue in
            vm.upperCaseness = .init(newValue)
        }

    }
    
    /// pre-defined background colors so the app look _kinda_ unique
    private var bg: Color {
        let dark: Color
        let light: Color
        
        dark = .secondarySystemBackground
        light = .systemGray6
        
        return colorScheme == .dark ? dark : light
    }
    
    /// the textfield with slight customization
    private var inputField: some View {
        TextEditor(text: $vm.userText)
            .padding()
            .background {
                // we did that way so we can have a rounded-rec effect
                Color.textBackgroundColor
            }
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
    
    private var clearButton: some View {
        Button(role: .destructive) {
            vm.userText = ""
        } label: {
            // `vm.morphedTextIsEmpty` ≠ `vm.userText.isEmpty`
            //  - `vm.morphedTextIsEmpty` determines if we made "real changes" on output
            //  as it accounts to triming white spaces & new lines
            // - while `vm.userText.isEmpty` is only checking if there's any raw input
            //  on the field from the user
            //
            // with that infomation, the icon on the button **remains unchanged** until the user
            // inputs a charcter we can capitalize/uncapitalise
            Label("clear", systemImage: vm.morphedTextIsEmpty ? "clear.fill" : "clear")
        }
        .disabled(vm.userText.isEmpty)
    }
    
    /// copy button with custom design and keyboard shortcut
    private var copyButton: some View {
        Button(action: vm.copyToClipboard) {
            Label("copy", systemImage: "arrow.right.doc.on.clipboard")
        }
        .buttonStyle(.bordered)
        .keyboardShortcut(KeyEquivalent("c"), modifiers: .command)
        .disabled(vm.morphed.count < 4)
    }
    
    /// let's the user determine how much capitalization the output should have and the button to copy to clipboard
    private var controls: some View {
        HStack {
            // copy button is moved depending in compact mode because I wanted to keep the user on their toes
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
            .contentTransition(.interpolate)
            .padding()
            .frame(maxWidth: .infinity, alignment: .trailing)
            .background {
                // the color really sticks out if we leave the opacity
                // and not in a good way
                Color.systemBackground.opacity(colorScheme == .dark ? 0.2 : 0.6)
            }
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }
    
    /// for when the input field is empty (exclusing whitespaces)
    private var directionToUser: some View {
        Text("enter text ") + Text(compactHeight ? "on side" : "above")
    }
}

#Preview {
    MorpherView()
}
