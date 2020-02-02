//
//  RandomSource.swift
//  Cecilia
//
//  Created by Peter Kazakov on 02.02.2020.
//  Copyright © 2020 Peter Kazakov. All rights reserved.
//

import Foundation

struct RandomSource: Decodable {
    var id: Int
    var imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case imageUrl
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        self.imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl) ?? ""
    }
}
