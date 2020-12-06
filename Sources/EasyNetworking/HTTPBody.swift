//
//  Copyright © 2020 Tamas Dancsi. All rights reserved.
//

import Foundation

public enum HTTPBody {

    case empty
    case params([String: Any])
    case data(Data?)

    func data() throws -> Data? {
        switch self {
        case .empty:
            return nil
        case .params(let params):
            return try JSONSerialization.data(withJSONObject: params)
        case .data(let data):
            return data
        }
    }
}
