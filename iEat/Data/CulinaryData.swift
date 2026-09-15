//
//  CulinaryData.swift
//  iEat
//
//  Created by Stevanus Felixiano on 15/09/26.
//

import Foundation

let cravings: [FoodPreference] = [
    FoodPreference(
        emoji: "🍚",
        name: "Rice",
        searchQuery: "rice"
    ),
    FoodPreference(
        emoji: "🍜",
        name: "Noodles",
        searchQuery: "noodles"
    ),
    FoodPreference(
        emoji: "🍢",
        name: "Satay",
        searchQuery: "satay"
    ),
    FoodPreference(
        emoji: "🍗",
        name: "Fried Chicken",
        searchQuery: "fried chicken"
    ),
    FoodPreference(
        emoji: "☕️",
        name: "Coffee",
        searchQuery: "coffee"
    ),
    FoodPreference(
        emoji: "🥐",
        name: "Pastry",
        searchQuery: "pastry"
    ),
    FoodPreference(
        emoji: "🍕",
        name: "Pizza",
        searchQuery: "pizza"
    ),
    FoodPreference(
        emoji: "🍔",
        name: "Burger",
        searchQuery: "burger"
    )
]

let nasiPadang = Restaurant(
    name: "Nasi Padang Sederhana",
    address: "45 Jalan H. Agus Salim, Sabang",
    distance: 300,
    category: "Rice",
    cuisine: "Minang",
    rating: 4.6,
    reviewCount: 894,
    openingHours: "Daily 08:00 – 21:00"
)
