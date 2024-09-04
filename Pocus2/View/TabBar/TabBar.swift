//
//  TabBar.swift
//  Pocus2
//
//  Created by Wojciech Kozioł on 04/09/2024.
//

import SwiftUI

struct TabBar: View {
    let items: [TabBarItem]
    @Binding var selection: TabBarItem

    @Namespace private var namespace

    var body: some View {
        HStack {
            Spacer()

            ForEach(items, id: \.self) { item in
                VStack {
                    if item == selection {
                        UnevenRoundedRectangle(bottomLeadingRadius: 15, bottomTrailingRadius: 15)
                            .fill(.accent)
                            .frame(height: 5)
                            .matchedGeometryEffect(id: "indicator", in: namespace)
                    } else {
                        Rectangle()
                            .frame(height: 5)
                            .hidden()
                    }

                    Spacer()

                    Image(systemName: item.iconName)
                        .onTapGesture {
                            selection = item
                        }
                        .foregroundStyle(item == selection ? .accent : .secondary.opacity(0.5))

                    Spacer()
                }
                .frame(width: 50, height: 50)

                Spacer()
            }
        }
        .background(
            RoundedTabBar()
                .stroke(.secondary.opacity(0.5), lineWidth: 1)
                .ignoresSafeArea(edges: .bottom)
        )
        .animation(.default, value: selection)
    }
}

struct RoundedTabBar: Shape {
    func path(in rect: CGRect) -> Path {
        let radius = 20.0

        var path = Path()

        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))

        path.addArc(center: CGPoint(x: rect.minX + radius, y: rect.minY + radius), radius: radius, startAngle: .degrees(270 - 90), endAngle: .degrees(0 - 90), clockwise: false)

        path.addArc(center: CGPoint(x: rect.maxX - radius, y: rect.minY + radius), radius: radius, startAngle: .degrees(0 - 90), endAngle: .degrees(90 - 90), clockwise: false)

        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))

        return path
    }
}

#Preview {
    let items: [TabBarItem] = [.timer, .settings]

    return VStack {
        Spacer()
        TabBar(items: items, selection: .constant(items.first!))
    }
}

//struct TabBarUsingGeometryReader: View {
//    let items: [TabBarItem]
//    @Binding var selection: TabBarItem
//
//    @State var indicatorPositionX = 0.0
//
//    var body: some View {
//        HStack {
//            Spacer()
//
//            ForEach(items, id: \.self) { item in
//                Image(systemName: item.iconName)
//                    .onTapGesture {
//                        withAnimation {
//                            selection = item
//                        }
//                    }
//                    .foregroundStyle(item == selection ? .blue : .secondary.opacity(0.5))
//                    .background(
//                        GeometryReader { geometry in
//                            Color.clear
//                                .onChange(of: selection) {
//                                    guard item == selection else { return }
//                                    withAnimation {
//                                        indicatorPositionX = geometry.frame(in: .global).midX
//                                    }
//                                }
//                                .onAppear {
//                                    guard item == selection else { return }
//                                    indicatorPositionX = geometry.frame(in: .global).midX
//                                }
//                        }
//                    )
//
//                Spacer()
//            }
//        }
//        .padding()
//        .frame(maxWidth: .infinity)
//        .background(
//            RoundedTabBar()
//                .stroke(.secondary.opacity(0.5), lineWidth: 1)
//                .ignoresSafeArea(edges: .bottom)
//        )
//        .overlay(
//            UnevenRoundedRectangle(bottomLeadingRadius: 15, bottomTrailingRadius: 15)
//                .fill(.blue)
//                .frame(width: 50, height: 5)
//                .position(x: indicatorPositionX)
//                .padding(.top, 2.5)
//        )
//    }
//}

