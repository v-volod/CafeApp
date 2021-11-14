import Foundation

protocol MenuApi {
    func getSmoothies(_ handler: @escaping (Result<[Smoothie], Error>) -> Void)
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
}
