//
//  Copyright © 2020 Tamas Dancsi. All rights reserved.
//

import Foundation
import Combine

public struct APIClient: API {

    private let session: URLSession
    private let baseURL: URL
    private let jsonDecoder: JSONDecoder

    public init(session: URLSession = .shared,
                baseURL: URL,
                jsonDecoder: JSONDecoder = JSONDecoder()) {

        self.session = session
        self.baseURL = baseURL
        self.jsonDecoder = jsonDecoder
    }

    public func request<T: Decodable>(configuration: RequestConfiguration) -> AnyPublisher<T, Error> {
        Future<T, Error> { promise in
            do {
                session.dataTask(with: try configuration.urlRequest(baseURL: baseURL)) { data, response, error in
                    let statusCode = (response as? HTTPURLResponse)?.statusCode

                    /// 1. In case of a networking error, it fails with a networking error
                    if let error = error {
                        promise(.failure(NetworkingError.networkingError(error: error, statusCode: statusCode)))
                        return
                    }

                    /// 2. In case data is empty, it should fail with an empty data error
                    guard let data = data else {
                        promise(.failure(NetworkingError.emptyData(statusCode: statusCode)))
                        return
                    }

                    /// 3. Tries parsing the result and returns with the result
                    do {
                        let result = try jsonDecoder.decode(T.self, from: data)
                        promise(.success(result))
                    } catch {
                        promise(.failure(NetworkingError.parsingFailed(data: data, statusCode: statusCode)))
                    }
                }
                .resume()

            } catch {
                promise(.failure(NetworkingError.preparingRequest))
                return
            }
        }
        .eraseToAnyPublisher()
    }

    public func request(configuration: RequestConfiguration) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { promise in
            do {
                session.dataTask(with: try configuration.urlRequest(baseURL: baseURL)) { data, response, error in
                    let statusCode = (response as? HTTPURLResponse)?.statusCode

                    /// 1. In case of a networking error, it fails with a networking error
                    if let error = error {
                        promise(.failure(NetworkingError.networkingError(error: error, statusCode: statusCode)))
                        return
                    }

                    /// 2. It returns with success
                    promise(.success(Void()))
                }
                .resume()

            } catch {
                promise(.failure(NetworkingError.preparingRequest))
                return
            }
        }
        .eraseToAnyPublisher()
    }

    public func requestData(configuration: RequestConfiguration) -> AnyPublisher<Data, Error> {
        Future<Data, Error> { promise in
            do {
                session.dataTask(with: try configuration.urlRequest(baseURL: baseURL)) { data, response, error in
                    let statusCode = (response as? HTTPURLResponse)?.statusCode

                    /// 1. In case of a networking error, it fails with a networking error
                    if let error = error {
                        promise(.failure(NetworkingError.networkingError(error: error, statusCode: statusCode)))
                        return
                    }

                    /// 2. In case data is empty, it should fail with an empty data error
                    guard let data = data else {
                        promise(.failure(NetworkingError.emptyData(statusCode: statusCode)))
                        return
                    }

                    /// 2. It returns with the data
                    promise(.success(data))
                }
                .resume()

            } catch {
                promise(.failure(NetworkingError.preparingRequest))
                return
            }
        }
        .eraseToAnyPublisher()
    }

    public func upload(configuration: RequestConfiguration, data: Data) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { promise in
            do {
                session.uploadTask(with: try configuration.urlRequest(baseURL: baseURL),
                                   from: data) { data, response, error in

                    let statusCode = (response as? HTTPURLResponse)?.statusCode

                    /// 1. In case of a networking error, it fails with a networking error
                    if let error = error {
                        promise(.failure(NetworkingError.networkingError(error: error, statusCode: statusCode)))
                        return
                    }

                    /// 2. It returns with success
                    promise(.success(Void()))
                }
                .resume()

            } catch {
                promise(.failure(NetworkingError.preparingRequest))
                return
            }
        }
        .eraseToAnyPublisher()
    }
}
