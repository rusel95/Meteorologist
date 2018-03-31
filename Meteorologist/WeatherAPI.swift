//
//  WeatherAPI.swift
//  Meteorologist
//
//  Created by Ruslan Popesku on 3/31/18.
//  Copyright © 2018 Ruslan Popesku. All rights reserved.
//

import Alamofire
import ObjectMapper

//class SerchedFriend: User {
//
//    var friendship: String?
//
//    override func mapping(map: Map) {
//        super.mapping(map: map)
//        friendship <- map["friendship"]
//    }
//}

class WeatherAPI {
    
    private static var baseUrl: String {
        get {
            if SavedData.getTestServer() {
                return "https://test-api.sence.lanservice.net"
            } else {
                return "https://api.sence.planexta.com"
            }
        }
    }
    
    enum Route {
        case friends
        case friendsRequestsInbox
        case friendsRequestsSent
        case requestToFriend(ID: String)
        case acceptFriend(ID: String)
        case rejectFriend(ID: String)
        case searchSingleUser(name: String)
        case getMeasureBy(userID: String, date: Date)
        
        var method: HTTPMethod {
            switch self {
            case .friends, .friendsRequestsInbox, .friendsRequestsSent,
                 .searchSingleUser, .getMeasureBy: return .get
            case .requestToFriend: return .post
            case .acceptFriend: return .put
            case .rejectFriend: return .delete
            }
        }
        
        var path: String {
            switch self {
            case .friends: return baseUrl + "/api/friends"
            case .friendsRequestsInbox: return baseUrl + "/api/friendRequests?type=inbox"
            case .friendsRequestsSent: return baseUrl + "/api/friendRequests?type=sent"
            case .requestToFriend(let ID): return baseUrl + "/api/friends/\(ID)"
            case .acceptFriend(let ID): return baseUrl + "/api/friends/\(ID)"
            case .rejectFriend(let ID): return baseUrl + "/api/friends/\(ID)"
            case .searchSingleUser(let name): return baseUrl + "/api/users/find?searchTerm=\(name)"
            case .getMeasureBy(let ID, let date):
                let dateFormatter = DateFormatter(withFormat: "yyyy-MM-dd", locale: "ua_UA")
                return baseUrl + "/api/measure?date=\(dateFormatter.string(from: date))&user=\(ID)"
            }
        }
        
        var parameters: [String: Any]? {
            return nil
        }
        
        var encoding: ParameterEncoding {
            return JSONEncoding.default
        }
        
        var header: HTTPHeaders? {
            if let token = AppDelegate.shared.usersManager.getUser()?.token {
                return ["X-API-TOKEN": token]
            } else {
                return nil
            }
        }
    }
    
    static func getFriends(closure: @escaping (_ handler: [User], _ error: String?) -> Void) {
        let request = Route.friends
        Alamofire.request(request.path, method: request.method, parameters: request.parameters, encoding: request.encoding, headers: request.header).responseJSON { response in
            
            switch response.result {
            case .success(let json):
                print(#function, json)
                if let friends = Mapper<User>().mapArray(JSONObject: (json as AnyObject).value(forKey: "friends")) {
                    closure(friends, nil)
                } else if let errorInfo = ((json as AnyObject).value(forKey: Keys.error.rawValue) as AnyObject).value(forKey: Keys.info.rawValue) as? Int, let error = ErrorInfo(rawValue: errorInfo) {
                    closure( [], error.message )
                } else {
                    closure( [], ErrorInfo.unknownError.message )
                }
                
            case .failure(let error):
                print(#function, error.localizedDescription)
                closure([], error.localizedDescription)
            }
        }
    }
    
    static func getFriendsRequestsInbox(closure: @escaping (_ handler: [User], _ error: String?) -> Void) {
        let request = Route.friendsRequestsInbox
        
        Alamofire.request(request.path, method: request.method, parameters: request.parameters, encoding: request.encoding, headers: request.header).responseJSON { response in
            
            switch response.result {
            case .success(let json):
                print(#function, json)
                if let friends = Mapper<User>().mapArray(JSONObject: (json as AnyObject).value(forKey: "friendRequests")) {
                    closure(friends, nil)
                } else if let errorInfo = ((json as AnyObject).value(forKey: Keys.error.rawValue) as AnyObject).value(forKey: Keys.info.rawValue) as? Int, let error = ErrorInfo(rawValue: errorInfo) {
                    closure( [], error.message )
                } else {
                    closure( [], ErrorInfo.unknownError.message )
                }
                
            case .failure(let error):
                print(#function, error.localizedDescription)
                closure([], error.localizedDescription)
            }
        }
    }
    
    static func getFriendsRequestsSent(closure: @escaping (_ handler: [User], _ error: String?) -> Void) {
        let request = Route.friendsRequestsSent
        
        Alamofire.request(request.path, method: request.method, parameters: request.parameters, encoding: request.encoding, headers: request.header).responseJSON { response in
            
            switch response.result {
            case .success(let json):
                print(#function, json)
                if let friends = Mapper<User>().mapArray(JSONObject: (json as AnyObject).value(forKey: "friendRequests")) {
                    closure(friends, nil)
                } else if let errorInfo = ((json as AnyObject).value(forKey: Keys.error.rawValue) as AnyObject).value(forKey: Keys.info.rawValue) as? Int, let error = ErrorInfo(rawValue: errorInfo) {
                    closure( [], error.message )
                } else {
                    closure( [], ErrorInfo.unknownError.message )
                }
                
            case .failure(let error):
                print(#function, error.localizedDescription)
                closure([], error.localizedDescription)
            }
        }
    }
    
    static func sendRequestToFriend(by ID: String, closure: @escaping (_ error: String?) -> Void) {
        let request = Route.requestToFriend(ID: ID)
        
        Alamofire.request(request.path, method: request.method, parameters: request.parameters, encoding: request.encoding, headers: request.header).responseJSON { response in
            
            switch response.result {
            case .success(let json):
                print(#function, json)
                if let errorInfo = ((json as AnyObject).value(forKey: Keys.error.rawValue) as AnyObject).value(forKey: Keys.info.rawValue) as? Int, let error = ErrorInfo(rawValue: errorInfo) {
                    closure( error.message )
                } else {
                    closure( nil )
                }
            case .failure(let error):
                print(#function, error.localizedDescription)
                closure("Internal server error")
            }
        }
    }
    
    static func acceptFriend(by ID: String, closure: @escaping (_ error: String?) -> Void) {
        let request = Route.acceptFriend(ID: ID)
        
        Alamofire.request(request.path, method: request.method, parameters: request.parameters, encoding: request.encoding, headers: request.header).responseJSON { response in
            
            switch response.result {
            case .success(let json):
                print(#function, json)
                if let errorInfo = ((json as AnyObject).value(forKey: Keys.error.rawValue) as AnyObject).value(forKey: Keys.info.rawValue) as? Int, let error = ErrorInfo(rawValue: errorInfo) {
                    closure( error.message )
                } else {
                    closure( nil )
                }
            case .failure(let error):
                closure(error.localizedDescription)
            }
        }
    }
    
    static func rejectFriend(by ID: String, closure: @escaping (_ error: String?) -> Void) {
        let request = Route.rejectFriend(ID: ID)
        
        Alamofire.request(request.path, method: request.method, parameters: request.parameters, encoding: request.encoding, headers: request.header).responseJSON { response in
            
            switch response.result {
            case .success(let json):
                print(#function, json)
                if let errorInfo = ((json as AnyObject).value(forKey: Keys.error.rawValue) as AnyObject).value(forKey: Keys.info.rawValue) as? Int, let error = ErrorInfo(rawValue: errorInfo) {
                    closure( error.message )
                } else {
                    closure( nil )
                }
            case .failure(let error):
                print(#function, error.localizedDescription)
                closure("Internal server error")
            }
        }
    }
    
    static func searchSingleUser(by name: String, closure: @escaping (_ friend: SerchedFriend?, _ error: String?) -> Void) {
        let request = Route.searchSingleUser(name: name)
        
        Alamofire.request(request.path, method: request.method, parameters: request.parameters, encoding: request.encoding, headers: request.header).responseJSON { response in
            
            switch response.result {
            case .success(let json):
                print(#function, json)
                if let friend = Mapper<SerchedFriend>().map(JSONObject: (json as AnyObject).value(forKey: Keys.user.rawValue)) {
                    closure(friend, nil)
                } else if let errorInfo = ((json as AnyObject).value(forKey: Keys.error.rawValue) as AnyObject).value(forKey: Keys.info.rawValue) as? Int, let error = ErrorInfo(rawValue: errorInfo) {
                    closure( nil, error.message )
                } else {
                    closure( nil, ErrorInfo.unknownError.message )
                }
            case .failure(let error):
                print(#function, error.localizedDescription)
                closure(nil, error.localizedDescription)
            }
        }
    }
    
    static func getMeasureBy(userId: String, date: Date, closure: @escaping (_ error: CountedMeasure?) -> Void) {
        let request = Route.getMeasureBy(userID: userId, date: date)
        
        Alamofire.request(request.path, method: request.method, parameters: request.parameters, encoding: request.encoding, headers: request.header).responseJSON { response in
            
            switch response.result {
            case .success(let json):
                print(#function, json)
                let countedMeasure = Mapper<CountedMeasure>().map(JSONObject: json)
                closure(countedMeasure)
            case .failure(let error):
                print(#function, error.localizedDescription)
                closure(nil)
            }
        }
    }
}
