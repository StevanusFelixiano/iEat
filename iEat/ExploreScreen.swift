//
//  ExploreScreen.swift
//  iEat
//
//  Created by Stevanus Felixiano on 14/09/26.
//

import SwiftUI

struct ExploreScreen: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    
                    // MARK: Top Bar
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            HStack(spacing: 5) {
                                Image(systemName: "chevron.left")
                                Text("Discover")
                            }
                            .font(.system(size: 20, weight: .regular))
                            .foregroundStyle(.orange)
                        }
                        
                        Spacer()
                        
                        // List / Map
                        HStack(spacing: 0) {
                            HStack(spacing: 5) {
                                Image(systemName: "line.3.horizontal")
                                Text("List")
                            }
                            .foregroundStyle(.primary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 7)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(.systemBackground))
                                    .shadow(
                                        color: .black.opacity(0.08),
                                        radius: 3,
                                        y: 1
                                    )
                            )
                            
                            HStack(spacing: 5) {
                                Image(systemName: "square.grid.2x2.fill")
                                Text("Map")
                            }
                            .foregroundStyle(Color(.systemGray))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 7)
                        }
                        .font(.system(size: 14, weight: .semibold))
                        .padding(3)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemGray6))
                        )
                    }
                    
                    // MARK: Title
                    HStack(alignment: .bottom) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Rice near you")
                                .font(
                                    .system(
                                        size: 28,
                                        weight: .bold,
                                        design: .serif
                                    )
                                )
                                .foregroundStyle(.primary)
                            
                            Text("1 place found")
                                .font(.system(size: 14))
                                .foregroundStyle(.gray)
                                .padding(.top, 4)
                        }
                        
                        Spacer()
                        
                        Button {
                            // Open filter
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "line.3.horizontal.decrease")
                                Text("Filter")
                            }
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.primary)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(
                                Capsule()
                                    .fill(Color(.systemGray6))
                            )
                        }
                    }
                    .padding(.top, 32)
                    .tint(.primary)
                    
                    // MARK: Place Card
                    PlaceCard(
                        imageName: "nasiPadang",
                        name: "Nasi Padang Sederhana",
                        category: "Rice · Minang",
                        rating: "4.6",
                        reviews: "894",
                        distance: "300 m",
                        closingTime: "Closes 21:00"
                    )
                    .padding(.top, 22)
                }
                .padding(.horizontal, 24)
                .padding(.top, 18)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Place Card

struct PlaceCard: View {
    
    let imageName: String
    let name: String
    let category: String
    let rating: String
    let reviews: String
    let distance: String
    let closingTime: String
    
    var body: some View {
        VStack(spacing: 0) {
            
            // MARK: Image
            ZStack(alignment: .topTrailing) {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 210)
                    .frame(maxWidth: .infinity)
                    .clipped()
                
                // Open status
                Text("Open · \(closingTime)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 11)
                    .background(
                        Capsule()
                            .fill(Color.green)
                    )
                    .padding(.top, 18)
                    .padding(.trailing, 18)
            }
            
            // MARK: Information
            VStack(alignment: .leading, spacing: 8) {
                
                HStack {
                    Text(name)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color(.systemGray3))
                }
                
                Text(category)
                    .font(.system(size: 18))
                    .foregroundStyle(.gray)
                
                HStack(spacing: 7) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 17))
                        .foregroundStyle(.orange)
                    
                    Text(rating)
                        .font(.system(size: 18, weight: .semibold))
                    
                    Text("(\(reviews))")
                        .font(.system(size: 17))
                        .foregroundStyle(.gray)
                    
                    Image(systemName: "mappin.and.ellipse")
                        .font(.system(size: 15))
                        .foregroundStyle(Color(.systemGray3))
                        .padding(.leading, 7)
                    
                    Text(distance)
                        .font(.system(size: 17))
                        .foregroundStyle(.gray)
                }
                .padding(.top, 8)
            }
            .padding(.trailing, 18)
            .padding(.leading, 22)
            .padding(.vertical, 22)
        }
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(Color(.systemBackground))
        )
        .clipShape(
            RoundedRectangle(cornerRadius: 28)
        )
        .shadow(
            color: .black.opacity(0.08),
            radius: 12,
            x: 0,
            y: 5
        )
    }
}

#Preview {
    ExploreScreen()
}
