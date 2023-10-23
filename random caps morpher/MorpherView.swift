//
//  MorpherView.swift
//  random caps morpher
//
//  Created by Nahid Islam on 23/10/2023.
//

import SwiftUI

struct MorpherView: View {
    
    @StateObject var vm: ViewModel = .init()
    
    var body: some View {
        VStack {
            Button("clear text", role: .destructive) {
                vm.userText = ""
            }
            .disabled(vm.userText.isEmpty)
            .frame(maxWidth: .infinity, alignment: .topTrailing)
            TextEditor(text: $vm.userText)
                .lineLimit(12)
            Slider(value: sliderValue, in: 3...7, step: 1.0)
                .onAppear {
                    vm.upperCaseness = 4
                }
            Text(vm.morphed)
            Button("copy") {
                UIPasteboard.general.setValue(vm.morphed, forPasteboardType: "public.plain-text")
            }
            .buttonStyle(.bordered)
            .disabled(vm.morphed.count < 4)
        }
        .padding()
    }
    
    var sliderValue: Binding<Double> {
        .init {
            .init(vm.upperCaseness)
        } set: { newValue in
            vm.upperCaseness = .init(newValue)
        }

    }
}

#Preview {
    MorpherView()
}
