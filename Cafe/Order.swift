import Foundation

struct Order {
    var quantity: [Smoothie.Id: UInt] = [:]

    mutating func addSmoothie(_ smoothie: Smoothie) {
        quantity[smoothie.id] = quantity[smoothie.id, default: 0] + 1
    }

    mutating func removeSmoothie(_ smoothie: Smoothie) {
        let quantity = quantity[smoothie.id, default: 0]

        guard quantity > 0 else {
            return
        }

        self.quantity[smoothie.id] = quantity - 1
    }
}

extension Order {
    static let empty = Self()
}
