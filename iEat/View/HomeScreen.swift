//
//  HomeScreen.swift
//  iEat
//
//  Created by Stevanus Felixiano on 14/09/26.
//

import SwiftUI

struct HomeScreen: View {

    @StateObject private var manager = CulinaryManager()
    @State private var customCraving = ""

    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {

        ZStack {

            Color(.systemBackground)
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {

                VStack(alignment: .leading, spacing: 0) {

                    // MARK: Location

                    LocationPill(location: "Menteng, Jakarta")
                        .padding(.top, 20)
                        .padding(.leading, 10)

                    // MARK: Header

                    VStack(alignment: .leading, spacing: -4) {

                        Text("What are you")
                            .font(
                                .system(
                                    size: 36,
                                    weight: .bold,
                                    design: .serif
                                )
                            )
                            .foregroundStyle(.primary)

                        HStack(spacing: 0) {

                            Text("craving")
                                .font(
                                    .system(
                                        size: 36,
                                        weight: .bold,
                                        design: .serif
                                    )
                                )
                                .italic()
                                .foregroundStyle(Color.orange)

                            Text("?")
                                .font(
                                    .system(
                                        size: 36,
                                        weight: .bold,
                                        design: .serif
                                    )
                                )
                                .foregroundStyle(.primary)
                        }
                    }
                    .padding(.top, 28)
                    .padding(.leading, 10)

                    Text("Find something delicious nearby.")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundStyle(.gray)
                        .padding(.top, 10)
                        .padding(.leading, 14)
                    
                    // MARK: Custom Craving

                    CravingField(text: $customCraving) { preference in
                        manager.selectCraving(preference)
                    }
                    .padding(.top, 20)
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                    .padding(.bottom, -8)

                    // MARK: Cravings

                    LazyVGrid(columns: columns, spacing: 16) {

                        ForEach(cravings) { craving in

                            CravingCard(
                                emoji: craving.emoji,
                                title: craving.name
                            ){
                                manager.selectCraving(craving)
                            }
                        }
                    }
                    .padding(.top, 44)
                    .padding(.leading, 10)

                    // MARK: Distance

                    Text("Ready to find your next bite?")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Color(.systemGray2))
                        .frame(maxWidth: .infinity)
                        .padding(.top, 32)
                        .padding(.bottom, 24)
                }
                .padding(.horizontal, 10)
            }
        }
    }
}

#Preview {
    HomeScreen()
}
