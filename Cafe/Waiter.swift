import Foundation

typealias ResultHandler<T> = (Result<T, Error>) -> Void

// Mocked implementation.
final class Waiter {
    var order = Order()

    func getSmoothies(_ handler: @escaping ResultHandler<[Smoothie]>) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            handler(.success(.all))
        }
    }

    func getCurrentOrder(_ handler: @escaping ResultHandler<Order>) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [order] in
            handler(.success(order))
        }
    }

    func addSmoothieToOrderAsync(_ smoothie: Smoothie, handler: @escaping ResultHandler<Order>) {
        order.addSmoothie(smoothie)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [order] in
            handler(.success(order))
        }
    }

    func removeSmoothieFromOrderAsync(_ smoothie: Smoothie, handler: @escaping ResultHandler<Order>) {
        order.removeSmoothie(smoothie)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [order] in
            handler(.success(order))
        }
    }
}
