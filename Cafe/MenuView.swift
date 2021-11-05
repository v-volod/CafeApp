import SwiftUI

@MainActor
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

    func load() async {
        showError = false

        do {
            smoothies = try await waiter.smoothies()
            order = try await waiter.currentOrder()
        } catch {
            showError = true
        }
    }

    func addToCart(_ smoothie: Smoothie) async {
        order?.addSmoothie(smoothie)

        do {
            order = try await waiter.addSmoothieToOrder(smoothie)
        } catch {
            showError = true
        }
    }

    func removeFromCart(_ smoothie: Smoothie) async {
        order?.removeSmoothie(smoothie)

        do {
            order = try await waiter.removeSmoothieFromOrder(smoothie)
        } catch {
            showError = true
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
                        Task {
                            await viewModel.addToCart(smoothie)
                        }
                    },
                    removeFromCart: { smoothie in
                        Task {
                            await viewModel.removeFromCart(smoothie)
                        }
                    }
                )
            } else {
                ProgressView("Loading")
                    .progressViewStyle(.circular)
                    .onAppear {
                        Task {
                            await viewModel.load()
                        }
                    }
            }
        }
        .navigationTitle("Menu")
        .alert("Something went wrong", isPresented: $viewModel.showError) {
            Button {
                Task {
                    await viewModel.load()
                }
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
