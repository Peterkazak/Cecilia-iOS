//
//  GameSessionService.swift
//  Cecilia
//
//  Created by Peter Kazakov on 01.02.2020.
//  Copyright © 2020 Peter Kazakov. All rights reserved.
//

import Foundation
import Alamofire

class GameSessionService {
    
    static let shared = GameSessionService()

    private init() {}
    
    // MARK: Root collection
    func getRandomSource(completion: @escaping ((RandomSource) -> Void), errorHandler: @escaping (_ error: Error) -> Void) {
        let headers: HTTPHeaders = ["Accept": "application/json"]
        
        AF.request(SERVER_URL + "getRandomSource", method: .get, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success:
                let jsonData = response.data
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                do {
                    let decodedData = try decoder.decode(RandomSource.self, from: jsonData!)
                    completion(decodedData)
                } catch {
                    errorHandler(error)
                }
            case .failure(let error): errorHandler(error)
            }
        }
    }
    
    func storeDrawingBy(id: Int, image: UIImage)  {
        let headers: HTTPHeaders = ["Accept": "application/json"]
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(image.jpegData(compressionQuality: 1.0)!, withName: "image" , fileName: "file.jpeg", mimeType: "image/jpeg")
            multipartFormData.append(Data("\(id)".utf8), withName: "sourceId")
        }, to: SERVER_URL + "storeDrawing", method: .post, headers: headers).response { response in
            switch response.result {
            case .success:
                print("StoreDrawing: success!")
            case .failure(let error):
                print("StoreDrawing: \(error.localizedDescription)")
            }
        }
    }
    
    func getSourceDrawingsBy(id: Int, completion: @escaping (([CommunityDrawing]) -> Void), errorHandler: @escaping (_ error: Error) -> Void) {
        let parameters: Parameters = ["sourceId": id]
        let headers: HTTPHeaders = ["Accept": "application/json"]
        
        AF.request(SERVER_URL + "getSourceDrawings", method: .get, parameters: parameters, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success:
                let jsonData = response.data
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let decodedData = try decoder.decode([CommunityDrawing].self, from: jsonData!)
                    completion(decodedData)
                } catch {
                    errorHandler(error)
                }
            case .failure(let error): errorHandler(error)
            }
        }
    }
}
