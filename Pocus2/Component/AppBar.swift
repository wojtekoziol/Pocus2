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

            Button {
                // TODO: Go to settings
            } label: {
                Image(systemName: "gearshape.fill")
                    .font(.title2)
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
