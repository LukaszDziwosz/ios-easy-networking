//
//  Copyright © 2020 Tamas Dancsi. All rights reserved.
//

import Foundation

public enum NetworkingError: Error {

    case weakSelfNil
    case wrongEndpointPath
    case preparingRequest
    case parsingFailed(data: Data, statusCode: Int?)
    case emptyData(statusCode: Int?)
    case networkingError(error: Error, statusCode: Int?)
}
