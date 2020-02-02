//
//  CommunityDrawing.swift
//  Cecilia
//
//  Created by Peter Kazakov on 02.02.2020.
//  Copyright © 2020 Peter Kazakov. All rights reserved.
//

import Foundation

//"id": 6,
//"user": null,
//"source": {
//    "id": 1,
//    "image_url": "http://84.201.136.15:81/sources/1.jpg"
//},
//"similarity_score": 0,
//"image_url": "http://84.201.136.15:81/drawings/6.jpg"

struct CommunityDrawing: Decodable {
    var id: Int
    var similarityScore: Int
    var imageUrl: String
    var sourceImageUrl: String
    var sourceId: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case similarityScore
        case imageUrl
        case source
    }
    
    enum NestedContainerKeys: String, CodingKey {
        case sourceImageUrl
        case sourceId
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        self.similarityScore = try container.decodeIfPresent(Int.self, forKey: .similarityScore) ?? 0
        self.imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl) ?? ""
        
        let nestedContainer = try container.nestedContainer(keyedBy: NestedContainerKeys.self, forKey: .source)
        self.sourceImageUrl = try nestedContainer.decodeIfPresent(String.self, forKey: .sourceImageUrl) ?? ""
        self.sourceId = try nestedContainer.decodeIfPresent(Int.self, forKey: .sourceId) ?? 0
    }
}
