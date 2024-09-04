//
//  Banner.swift
//  Pocus2
//
//  Created by Wojciech Kozioł on 03/09/2024.
//

import SwiftUI

struct BannerData {
    var title: String
    var message: String
    var emoji: String

    static let afterFocus = BannerData(title: "Your focus session has ended!", message: "Make sure to get some rest.", emoji: "🎊")
    static let afterBreak = BannerData(title: "It's time to focus!", message: "Give it all you've got.", emoji: "⚡️")
}

struct BannerModifier: ViewModifier {
    @Binding var show: Bool

    let bannerData: BannerData

    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content
            if show {
                HStack {
                    Text(bannerData.emoji)
                        .font(.largeTitle)

                    VStack(alignment: .leading) {
                        Text(bannerData.title)
                            .bold()

                        Text(bannerData.message)
                            .font(.caption)
                    }

                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .foregroundStyle(.white)
                .padding()
                .containerRelativeFrame(.horizontal) { width, _ in width * 0.9 }
                .background(.accent)
                .clipShape(.rect(cornerRadius: 10))
                .shadow(radius: 10)
                .padding()
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .onTapGesture {
                    show = false
                }
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            if value.translation.height > 0 { 
                                show = false
                            }
                        }
                )
                .onAppear {
                    Task {
                        try? await Task.sleep(nanoseconds: 3_000_000_000)
                        show = false
                    }
                }
            }
        }
        .animation(.bouncy(duration: 0.5), value: show)
    }
}

extension View {
    func banner(show: Binding<Bool>, with bannerData: BannerData) -> some View {
        modifier(BannerModifier(show: show, bannerData: bannerData))
    }
}
