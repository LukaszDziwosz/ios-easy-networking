import XCTest
import Combine
@testable import EasyNetworking

final class EasyNetworkingTests: XCTestCase {

    func test_decodableRequest() {
        let sut = mockAPIClient

        mockDecodableRequest(client: sut)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                case .finished:
                    break
                }
            } receiveValue: { response in
                XCTAssertEqual(response.id, "testID")
            }
            .store(in: &cancellables)

        waitOrFail(timeout: 0.1)
    }

    // MARK: - Test/mock data

    let testBaseURL = URL(string: "http://test.com")!

    var mockAPIClient: APIClient {
        APIClient(baseURL: testBaseURL)
    }

    func mockDecodableRequest(client: APIClient) -> AnyPublisher<MockDecodableResponse, Error> {
        client.request(configuration: RequestConfiguration(endpointPath: "wrong", timeoutInterval: 0.01))
    }

    // MARK: - Helpers

    var cancellables = Set<AnyCancellable>()

    func waitOrFail(timeout: TimeInterval) {
        let expectation = self.expectation(description: #function)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + timeout, execute: {
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: timeout + 2)
    }
}
