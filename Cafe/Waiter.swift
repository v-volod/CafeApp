import Foundation

typealias ResultHandler<T> = (Result<T, Error>) -> Void

// Mocked implementation.
final class Waiter {
    var order = Order()

    func smoothies() async throws -> [Smoothie] {
        try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                continuation.resume(returning: .all)
            }
        }
    }

    func currentOrder() async throws -> Order {
        try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [order] in
                continuation.resume(returning: order)
            }
        }
    }

    func addSmoothieToOrder(_ smoothie: Smoothie) async throws -> Order {
        order.addSmoothie(smoothie)
        
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [order] in
                continuation.resume(returning: order)
            }
        }
    }

    func removeSmoothieFromOrder(_ smoothie: Smoothie) async throws -> Order {
        order.removeSmoothie(smoothie)
        
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [order] in
                continuation.resume(returning: order)
            }
        }
    }
}
