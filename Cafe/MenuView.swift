import SwiftUI

final class MenuViewModel: ObservableObject {
    let waiter = Waiter()

    @Published var smoothies: [Smoothie]?
    @Published var order: Order?
    @Published var showError = false

    init(
        smoothies: [Smoothie]? = nil,
        order: Order? = nil
    ) {
        self.smoothies = smoothies
        self.order = order
    }

    func load() {
        showError = false
        smoothies = nil
        order = nil

        waiter.getSmoothies { [waiter] smoothiesResult in
            waiter.getCurrentOrder { [weak self] orderResult in
                do {
                    self?.smoothies = try smoothiesResult.get()
                    self?.order = try orderResult.get()
                } catch {
                    self?.showError = true
                }
            }
        }
    }

    func addToCart(_ smoothie: Smoothie) {
        order?.addSmoothie(smoothie)

        waiter.addSmoothieToOrderAsync(smoothie) { [weak self] orderResult in
            do {
                self?.order = try orderResult.get()
            } catch {
                self?.showError = true
            }
        }
    }

    func removeFromCart(_ smoothie: Smoothie) {
        order?.removeSmoothie(smoothie)

        waiter.removeSmoothieFromOrderAsync(smoothie) { [weak self] orderResult in
            do {
                self?.order = try orderResult.get()
            } catch {
                self?.showError = true
            }
        }
    }
}

struct MenuView: View {
    @StateObject var viewModel = MenuViewModel()
    @State var showError = false

    var body: some View {
        Group {
            if let smoothies = viewModel.smoothies, let order = viewModel.order {
                SmoothieList(
                    smoothies: smoothies,
                    quantity: { order.quantity[$0.id, default: 0] },
                    addToCart: { smoothie in
                        viewModel.addToCart(smoothie)
                    },
                    removeFromCart: { smoothie in
                        viewModel.removeFromCart(smoothie)
                    }
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
