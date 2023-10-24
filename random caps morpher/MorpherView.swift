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
    
    var body: some View {
        VStack {
            Button("clear text", role: .destructive) {
                withAnimation(controlTransitionAnimation) {
                    vm.userText = ""
                }
            }
            .disabled(vm.userText.isEmpty)
            .frame(maxWidth: .infinity, alignment: .topTrailing)
            
            TextEditor(text: $vm.userText.animation())
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            if vm.userText.isEmpty {
                directionToUser
            } else {
                VStack {
                    controls
                    output
                }
                .transition(.move(edge: .bottom).combined(with: .opacity).combined(with: .scale(scale: 0.85, anchor: .bottom)).animation(controlTransitionAnimation))
            }
        }
        .padding()
        .background {
            bg
            .ignoresSafeArea()
        }
    }
    
    private var controlTransitionAnimation: Animation {
        .spring(response: 0.3, dampingFraction: 1.5, blendDuration: 0.2).speed(1.5)
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
        
        dark = .init(uiColor: .secondarySystemBackground)
        light = .init(uiColor: .systemGray6)
        
        return colorScheme == .dark ? dark : light
    }
    
    private var controls: some View {
        HStack {
            Slider(value: sliderValue, in: 3...7, step: 1.0)
                .onAppear {
                    vm.upperCaseness = 4
                }
            Button("copy") {
                UIPasteboard.general.setValue(vm.morphed, forPasteboardType: "public.plain-text")
            }
            .buttonStyle(.bordered)
            .disabled(vm.morphed.count < 4)
        }
    }
    
    private var output: some View {
        Text(vm.morphed)
            .padding()
            .frame(maxWidth: .infinity, alignment: .trailing)
            .background {
                Color(uiColor: .systemBackground).opacity(colorScheme == .dark ? 0.2 : 0.6)
            }
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }
    
    private var directionToUser: some View {
        Text("enter text above")
    }
}

#Preview {
    MorpherView()
}
