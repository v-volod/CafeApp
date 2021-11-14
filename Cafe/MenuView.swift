import SwiftUI

// MARK: - Order -

final class Order {
    var quantity: [Smoothie.Id: UInt] = [:]

    init(quantity: [Smoothie.Id: UInt] = [:]) {
        self.quantity = quantity
    }

    func addSmoothie(_ smoothie: Smoothie) {
        quantity[smoothie.id] = quantity[smoothie.id, default: 0] + 1
    }

    func removeSmoothie(_ smoothie: Smoothie) {
        let quantity = quantity[smoothie.id, default: 0]

        guard quantity > 0 else {
            return
        }

        self.quantity[smoothie.id] = quantity - 1
    }
}

// MARK: - ViewModel -

final class MenuViewModel: ObservableObject {
    let api: MenuApi
    let order: Order

    @Published var smoothies: [Smoothie]?
    @Published var showError = false

    init(
        api: MenuApi = /* HIDE IN PRESENTATION */ provideMenuApi(),
        smoothies: [Smoothie]? = nil,
        order: Order = .init()
    ) {
        self.api = api
        self.smoothies = smoothies
        self.order = order
    }

    func load() {
        showError = false

        api.getSmoothies { [weak self] smoothiesResult in
            do {
                self?.smoothies = try smoothiesResult.get()
            } catch {
                self?.showError = true
            }
        }
    }

    func addToCartTapped(_ smoothie: Smoothie) {
        order.addSmoothie(smoothie)

        objectWillChange.send()
    }

    func removeFromCartTapped(_ smoothie: Smoothie) {
        order.removeSmoothie(smoothie)

        objectWillChange.send()
    }
}

// MARK: - View -

struct MenuView: View {
    @StateObject var viewModel = MenuViewModel()
    @State var showError = false

    var body: some View {
        Group {
            if let smoothies = viewModel.smoothies {
                SmoothieList(
                    smoothies: smoothies,
                    quantity: { viewModel.order.quantity[$0.id, default: 0] },
                    addToCart: viewModel.addToCartTapped,
                    removeFromCart: viewModel.removeFromCartTapped
                )
            } else {
                ProgressView("Loading")
                    .progressViewStyle(.circular)
                    .onAppear {
                        viewModel.load()
                    }
            }
        }
        .navigationTitle("Menu")
        .alert("Something went wrong", isPresented: $viewModel.showError) {
            Button {
                viewModel.load()
            } label: {
                Text("Try again")
            }
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MenuView(viewModel: MenuViewModel(smoothies: nil))
            MenuView(
                viewModel: MenuViewModel(
                    smoothies: .all,
                    order: Order(
                        quantity: [
                            Smoothie.berryBlue.id: 1,
                            Smoothie.hulkingLemonade.id: 2
                        ]
                    )
                )
            )
        }
    }
}
