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
                vm.userText = ""
            }
            .disabled(vm.userText.isEmpty)
            .frame(maxWidth: .infinity, alignment: .topTrailing)
            
            TextEditor(text: $vm.userText)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            HStack {
                Slider(value: sliderValue, in: 3...7, step: 1.0)
                    .onAppear {
                        vm.upperCaseness = 4
                    }
                Button("copy") {
                    UIPasteboard.general.setValue(vm.morphed, forPasteboardType: "public.plain-text")
                }
                .buttonStyle(.bordered)
            }
            Text(vm.morphed)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Material.thin)
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            
            .disabled(vm.morphed.count < 4)
        }
        .padding()
        .background {
            bg
                .ignoresSafeArea()
        }
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
}

#Preview {
    MorpherView()
}
