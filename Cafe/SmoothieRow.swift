import SwiftUI

struct SmoothieRow: View {
    let smoothie: Smoothie
    let quantity: UInt
    let addToCart: () -> Void
    let removeFromCart: () -> Void

    init(
        smoothie: Smoothie,
        quantity: UInt,
        addToCart: @escaping () -> Void = {},
        removeFromCart: @escaping () -> Void = {}
    ) {
        self.smoothie = smoothie
        self.quantity = quantity
        self.addToCart = addToCart
        self.removeFromCart = removeFromCart
    }

    var body: some View {
        HStack {
            let imageClipShape = RoundedRectangle(cornerRadius: 10, style: .continuous)
            smoothie.image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60)
                .clipShape(imageClipShape)
                .overlay(imageClipShape.strokeBorder(.quaternary, lineWidth: 0.5))

            if quantity == 0 {
                Text(smoothie.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button(action: addToCart) {
                    Text("Add")
                }
                .buttonStyle(.borderedProminent)
            } else {
                Stepper(
                    label: {
                        Text(smoothie.title) + Text(": \(quantity)")
                    },
                    onIncrement: addToCart,
                    onDecrement: removeFromCart
                )
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
    }
}

struct SmoothieRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SmoothieRow(smoothie: .berryBlue, quantity: 0)
            SmoothieRow(smoothie: .hulkingLemonade, quantity: 1)
        }
        .previewLayout(.sizeThatFits)
    }
}
