//
//  RatingView.swift
//  StoreSearchApp
//
//  Created by hasung jung on 2023/03/22.
//

import SwiftUI

struct RatingView: View {
    private var rating: Double
    private var maximumRating = 5

    private var emptyImage = Image(systemName: "star")
    private var halfFillImage = Image(systemName: "star.leadinghalf.filled")
    private var fillImage = Image(systemName: "star.fill")

    public init(currentRating: Double) {
        let maximum = Double(maximumRating)
        if currentRating > maximum {
            self.rating = maximum
        } else {
            self.rating = currentRating
        }
    }

    var body: some View {
        VStack {
            Text(String(format: "%.1f", rating)).font(.title.bold())
            Spacer().frame(height: 10)
            HStack(spacing: 0) {
                ForEach(1..<fullStartCount+1, id: \.self) { _ in
                    fillImage
                }
                ForEach(1..<halfStartCount+1, id: \.self) { _ in
                    halfFillImage
                }
                ForEach(1..<emptyStarCount+1, id: \.self) { _ in
                    emptyImage
                }
            }
        }
    }
}

extension RatingView {
    var fullStartCount: Int {
        return Int(floor(rating))
    }

    var halfStartCount: Int {
        let diff = rating - floor(rating)
        return diff > 0 ? 1 : 0
    }

    var emptyStarCount: Int {
        return (maximumRating - halfStartCount) - fullStartCount
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(currentRating: 3.8)
    }
}
