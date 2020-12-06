//
//  Copyright © 2020 Tamas Dancsi. All rights reserved.
//

import Foundation
import Combine

public protocol API {

    /// Data tasks send and receive data using NSData objects. Data tasks are intended for short, often interactive requests to a server.
    func request<T: Decodable>(configuration: RequestConfiguration) -> AnyPublisher<T, Error>
    func request(configuration: RequestConfiguration) -> AnyPublisher<Void, Error>
    func requestData(configuration: RequestConfiguration) -> AnyPublisher<Data, Error>

    /// Upload tasks are similar to data tasks, but they also send data (often in the form of a file), and support background uploads while the app isn’t running.
    func upload(configuration: RequestConfiguration, data: Data) -> AnyPublisher<Void, Error>
}
