//
//  AppBar.swift
//  Pocus2
//
//  Created by Wojciech Kozioł on 04/09/2024.
//

import SwiftUI

struct AppBar: View {
    var body: some View {
        HStack {
            Image(.tomato)
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)

            Spacer()

            Text("Pocus")
                .font(.title2.bold())

            Spacer()

            NavigationLink {
                SettingsView()
            } label: {
                Image(systemName: "gearshape")                    
            }
        }
        .foregroundStyle(.accent)
        .padding(.horizontal)
    }
}

#Preview {
    VStack {
        AppBar()
        Spacer()
    }
}
