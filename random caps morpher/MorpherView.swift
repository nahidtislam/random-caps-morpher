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
            TextField("input", text: $vm.userText)
            Spacer()
            Text(vm.morphed)
        }
    }
}

#Preview {
    MorpherView()
}
