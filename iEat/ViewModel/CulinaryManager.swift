//
//  CulinaryManager.swift
//  iEat
//
//  Created by Stevanus Felixiano on 15/09/26.
//

import Foundation
import Combine

class CulinaryManager: ObservableObject {

    @Published var selectedCraving: FoodPreference?
    @Published var places: [Place] = []

    init() {
        places = [nasiPadang]
    }

    func selectCraving(_ craving: FoodPreference) {
        selectedCraving = craving
    }
}
