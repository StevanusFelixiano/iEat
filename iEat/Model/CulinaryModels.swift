//
//  CulinaryModels.swift
//  iEat
//
//  Created by Stevanus Felixiano on 15/09/26.
//

import Foundation

// MARK: - Structure
struct FoodPreference: Identifiable {
    let id = UUID()
    let emoji: String
    let name: String
    let searchQuery: String
}

// MARK: - Base Class
class Place: Identifiable {
    let id = UUID()

    let name: String
    let address: String
    let distance: Double
    let category: String

    // MARK: Optional Values
    let rating: Double?
    let reviewCount: Int?
    let phoneNumber: String?
    let websiteURL: URL?
    let openingHours: String?

    init(
        name: String,
        address: String,
        distance: Double,
        category: String,
        rating: Double? = nil,
        reviewCount: Int? = nil,
        phoneNumber: String? = nil,
        websiteURL: URL? = nil,
        openingHours: String? = nil
    ) {
        self.name = name
        self.address = address
        self.distance = distance
        self.category = category
        self.rating = rating
        self.reviewCount = reviewCount
        self.phoneNumber = phoneNumber
        self.websiteURL = websiteURL
        self.openingHours = openingHours
    }
}

// MARK: - Inheritance
class Restaurant: Place {
    let cuisine: String

    init(
        name: String,
        address: String,
        distance: Double,
        category: String,
        cuisine: String,
        rating: Double? = nil,
        reviewCount: Int? = nil,
        phoneNumber: String? = nil,
        websiteURL: URL? = nil,
        openingHours: String? = nil
    ) {
        self.cuisine = cuisine

        super.init(
            name: name,
            address: address,
            distance: distance,
            category: category,
            rating: rating,
            reviewCount: reviewCount,
            phoneNumber: phoneNumber,
            websiteURL: websiteURL,
            openingHours: openingHours
        )
    }
}
