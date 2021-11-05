import SwiftUI

struct SmoothieList: View {
    let smoothies: [Smoothie]
    let quantity: (Smoothie) -> UInt
    let addToCart: (Smoothie) -> Void
    let removeFromCart: (Smoothie) -> Void

    init(
        smoothies: [Smoothie],
        quantity: @escaping (Smoothie) -> UInt,
        addToCart: @escaping (Smoothie) -> Void = { _ in },
        removeFromCart: @escaping (Smoothie) -> Void = { _ in }
    ) {
        self.smoothies = smoothies
        self.quantity = quantity
        self.addToCart = addToCart
        self.removeFromCart = removeFromCart
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(smoothies) { smoothie in
                    SmoothieRow(smoothie: smoothie, quantity: quantity(smoothie)) {
                        addToCart(smoothie)
                    } removeFromCart: {
                        removeFromCart(smoothie)
                    }

                    Divider()
                }
            }
        }
    }
}

struct SmoothieList_Previews: PreviewProvider {
    static var previews: some View {
        SmoothieList(smoothies: .all, quantity: { _ in 0})
    }
}
