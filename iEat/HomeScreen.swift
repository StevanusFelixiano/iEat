//
//  HomeScreen.swift
//  iEat
//
//  Created by Stevanus Felixiano on 14/09/26.
//

import SwiftUI

struct HomeScreen: View {
    
    let cravings = [
        ("🍚", "Rice"),
        ("🍜", "Noodles"),
        ("🍢", "Satay"),
        ("🍗", "Fried Chicken"),
        ("☕️", "Coffee"),
        ("🥐", "Pastry"),
        ("🍕", "Pizza"),
        ("🍔", "Burger")
    ]
    
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
                    HStack(spacing: 8) {
                        Image(systemName: "mappin.and.ellipse")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundStyle(.gray)
                        
                        Text("Menteng, Jakarta")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.gray)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        Capsule()
                            .fill(Color(.systemGray6))
                    )
                    .padding(.top, 20)
                    .padding(.leading, 10)
                    
                    // MARK: Header
                    VStack(alignment: .leading, spacing: -4) {
                        Text("What are you")
                            .font(.system(size: 36, weight: .bold, design: .serif))
                            .foregroundStyle(.primary)
                        
                        HStack(spacing: 0) {
                            Text("craving")
                                .font(.system(size: 36, weight: .bold, design: .serif))
                                .italic()
                                .foregroundStyle(Color.orange)
                            
                            Text("?")
                                .font(.system(size: 36, weight: .bold, design: .serif))
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
                    
                    // MARK: Cravings
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(cravings, id: \.1) { craving in
                            CravingCard(
                                emoji: craving.0,
                                title: craving.1
                            )
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

// MARK: - Craving Card

struct CravingCard: View {
    let emoji: String
    let title: String
    
    var body: some View {
        Button {
            // Handle craving selection
        } label: {
            VStack(alignment: .leading, spacing: 0) {
                
                Text(emoji)
                    .font(.system(size: 36))
                    .frame(height: 65)
                    .padding(.bottom, -10)
                
                Spacer()
                
                Text(title)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.primary)
                    .padding(.bottom, 15)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 80)
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 28)
                    .fill(Color(.systemBackground))
                    .shadow(
                        color: .black.opacity(0.07),
                        radius: 12,
                        x: 0,
                        y: 5
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HomeScreen()
}
