//
//  Copyright © 2020 Tamas Dancsi. All rights reserved.
//

import Foundation

public struct RequestConfiguration {

    let endpointPath: String
    let method: HTTPMethod
    let body: HTTPBody
    let headers: [String: String?]
    let cachePolicy: URLRequest.CachePolicy
    let timeoutInterval: TimeInterval

    public init(endpointPath: String,
                method: HTTPMethod = .get,
                body: HTTPBody = .empty,
                headers: [String: String?] = [:],
                cachePolicy: URLRequest.CachePolicy = .reloadIgnoringLocalCacheData,
                timeoutInterval: TimeInterval = 60.0) {

        self.endpointPath = endpointPath
        self.method = method
        self.body = body
        self.headers = headers
        self.cachePolicy = cachePolicy
        self.timeoutInterval = timeoutInterval
    }

    func urlRequest(baseURL: URL) throws -> URLRequest {
        guard let urlString = baseURL.appendingPathComponent(endpointPath)
                .absoluteString.removingPercentEncoding,
              let url = URL(string: urlString) else {

            throw NetworkingError.wrongEndpointPath
        }

        var request = URLRequest(url: url,
                                 cachePolicy: cachePolicy,
                                 timeoutInterval: timeoutInterval)

        /// Setting HTTP method
        request.httpMethod = method.rawValue.uppercased()

        /// Adding headers
        headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        /// Setting HTTP body
        request.httpBody = try body.data()

        return request
    }
}
