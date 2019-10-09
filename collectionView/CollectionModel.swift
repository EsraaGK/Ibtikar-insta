//
//  collectionModel.swift
//  Ibtikar
//
//  Created by EsraaGK on 9/11/19.
//  Copyright © 2019 Esraa Mohamed. All rights reserved.
//

import Foundation
import  Moya
import ObjectMapper

class CollectionModel: ActorCollectionModelProtocol{
    
    func getStringUrlAtIndex(index: Int) -> String {
        return profiles[index]
    }
    
    func getProfileArrayCount() -> Int {
        return profiles.count
    }
    
    
    var  profiles = Array<String>()
    var NavActorObj: Actor
    
    init(ActorObj:Actor){
        NavActorObj = ActorObj
    }
    
    func loadHeaderImage(completion:@escaping (Data?)->Void){
        let stringURL = NavActorObj.profile_path!
        if stringURL != "noPath" {
            let url = URL(string: stringURL)!
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request, completionHandler: { adata, response, error in
                if let data = adata{
                    print("this is data \(data)")
                    completion(data)
                }else{
                    completion(nil)
                }
                
            })
            task.resume()
            
        }else{// nopath
            completion(nil)
        }
    }
    
    
    func getResponse (completionHandler:@escaping ()->Void){
        
        let  provider = MoyaProvider<PERSON>(plugins:[NetworkLoggerPlugin()])
        provider.request(.personGO(id: NavActorObj.id!)) { result in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let str = String(decoding: data, as: UTF8.self)
                let temp = Mapper<Picture>().map(JSONString: str)
                
                self.profiles = temp!.profiles!.map{ (Path) -> String in
                    return Path.file_path!
                }
                completionHandler()
                print(self.profiles[1])
            case .failure(let error):
                print("moya failed\(error)")
            }
        }
        
    }
    
    func getActorNameAt()->String {
        return NavActorObj.name!
    }
    
    func getActorPopularityAt() -> Double {
        return NavActorObj.popularity!
    }
    
    func getActorProfilePath()->String {
        return NavActorObj.profile_path!
    }
    
    
}

//--------------------------------------------
public enum PERSON{
    case personGO (id: Int)
}
extension PERSON: TargetType{
    //1
    public var baseURL: URL {
        return URL(string: "https://api.themoviedb.org/3/person")!
    }
    
    // 2
    public var path: String {
        
        switch self {
        case .personGO(let ID):
            return "/\(ID)/images"
            //+ "?api_key=" + getAPIValue() // id = 2888
        }
    }
    //https://api.themoviedb.org/3/person/2888/images?api_key=3955a9144c79cb1fca10185c95080107
    
    // 3
    public var method: Moya.Method {
        return .get
    }
    
    // 4
    public var sampleData: Data {
        //is used in unit test
        return Data()
    }
    
    // 5
    public var task: Task {
        return .requestParameters(parameters: ["api_key" : "3955a9144c79cb1fca10185c95080107"], encoding: URLEncoding.default)
    }
    
    // 6
    public var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
    
    // 7
    public var validationType: ValidationType {
        return .successCodes
    }
}

