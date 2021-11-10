import Foundation

struct Smoothie: Identifiable, Equatable {
    struct Id: Hashable, ExpressibleByStringLiteral {
        let value: String

        init(stringLiteral value: StringLiteralType) {
            self.value = value
        }
    }

    let id: Id
    let title: String
}

extension Smoothie {
    // Used in previews.
    static let berryBlue = Self(id: "berry-blue", title: "Berry Blue")
    static let carrotChops = Self(id: "carrot-chops", title: "Carrot Chops")
    static let pinaYCoco = Self(id: "pina-y-coco", title: "Piña y Coco")
    static let hulkingLemonade = Self(id: "hulking-lemonade", title: "Hulking Lemonade")
    static let kiwiCutie = Self(id: "kiwi-cutie", title: "Kiwi Cutie")

    
}

extension Array where Element == Smoothie {
    static let all: [Element] = [
        .berryBlue,
        .carrotChops,
        .pinaYCoco,
        .hulkingLemonade,
        .kiwiCutie,
        .init(id: "lemonberry", title: "Lemonberry"),
        .init(id: "love-you-berry-much", title: "Love You Berry Much"),
        .init(id: "mango-jambo", title: "Mango Jambo"),
        .init(id: "one-in-a-melon", title: "One in a Melon"),
        .init(id: "papas-papaya", title: "Papa's Papaya"),
        .init(id: "peanut-butter-cup", title: "Peanut Butter Cup"),
        .init(id: "sailor-man", title: "Sailor Man"),
        .init(id: "thats-a-smore", title: "That's a Smore!"),
        .init(id: "thats-berry-bananas", title: "That's Berry Bananas!"),
        .init(id: "tropical-blue", title: "Tropical Blue")
    ]
}

// MARK: - SwiftUI.Image
import SwiftUI

extension Smoothie {
    func image() async -> Image {
        guard let image = UIImage(named: "\(id.value)"),
              let thumbnail = await image.byPreparingThumbnail(ofSize: CGSize(width: 20, height: 20))
        else {
            return Image("\(id.value)", label: Text(title))
                .renderingMode(.original)
        }

        return Image(uiImage: thumbnail)
    }
}
