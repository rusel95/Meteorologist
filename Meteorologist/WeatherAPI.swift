//
//  WeatherAPI.swift
//  Meteorologist
//
//  Created by Ruslan Popesku on 3/31/18.
//  Copyright © 2018 Ruslan Popesku. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import CoreLocation

class Weather: Mappable {
    var timezone: String?
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
       timezone <- map["latitude"]
    }
}

enum Cities: String {
    case Dnipro = "48.478803,35.022301"
}

class WeatherAPI {
    
    private static var baseUrl: String = "https://api.darksky.net/forecast/"
    private static var token: String = "117ad89513d5baa3467184dde78abf98/"
    
    enum Route {
        case weatherForCityWith(coords: Cities)
        
        var method: HTTPMethod {
            switch self {
            case .weatherForCityWith: return .get
            }
        }
        
        var path: String {
            switch self {
            case .weatherForCityWith(let city): return baseUrl + token + city.rawValue
            }
        }
        
        var parameters: [String: Any]? {
            return nil
        }
        
        var encoding: ParameterEncoding {
            return JSONEncoding.default
        }
    }
    
    static func getWeatherFor(city: Cities, closure: @escaping (_ handler: Weather?, _ error: String?) -> Void) {
        let request = Route.weatherForCityWith(coords: city)
        Alamofire.request(request.path, method: request.method, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            print(response)
        }
    }
    
}
