import Foundation

protocol MenuApi {
    @available(*, deprecated, message: "Prefer async alternative instead")
    func getSmoothies(_ handler: @escaping (Result<[Smoothie], Error>) -> Void)
    
    func getSmoothies() async throws -> [Smoothie]
}

// MARK: - Mocked implementation -

// NOT FOR PRESENTATION!

func provideMenuApi() -> MenuApi {
    MockedMenuApi()
}

final class MockedMenuApi: MenuApi {
    var order = Order()

    func getSmoothies(_ handler: @escaping (Result<[Smoothie], Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            handler(.success(.all))
        }
    }
    
    func getSmoothies() async throws -> [Smoothie] {
        try await withCheckedThrowingContinuation { continuation in
            getSmoothies(continuation.resume(with:))
        }
    }
}
