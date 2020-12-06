//
//  Copyright © 2020 Tamas Dancsi. All rights reserved.
//

import Foundation

struct Todo: Codable, Identifiable {

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id
        case title
        case completed
    }

    let userID: Int
    let id: Int
    let title: String
    var completed: Bool
}
