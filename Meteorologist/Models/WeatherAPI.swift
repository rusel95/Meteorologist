//
//  WeatherAPI.swift
//  Meteorologist
//
//  Created by Ruslan Popesku on 3/31/18.
//  Copyright © 2018 Ruslan Popesku. All rights reserved.
//

import Alamofire
import ObjectMapper

class WeatherAPI {
    
    private static var baseUrl: String = "https://api.darksky.net/forecast/"
    private static var token: String = "117ad89513d5baa3467184dde78abf98/"
    
    enum Route {
        case weatherForCityWith(coords: City)
        
        var method: HTTPMethod {
            switch self {
            case .weatherForCityWith: return .get
            }
        }
        
        var path: String {
            switch self {
            case .weatherForCityWith(let city): return baseUrl + token + city.coords
            }
        }
        
        var parameters: [String: Any]? {
            return nil
        }
        
        var encoding: ParameterEncoding {
            return JSONEncoding.default
        }
    }
    
    static func getWeatherFor(city: City, closure: @escaping (_ handler: Weather?, _ error: String?) -> Void) {
        let request = Route.weatherForCityWith(coords: city)
        Alamofire.request(request.path, method: request.method, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            switch response.result {
            case .success(let json):
                if let weather = Mapper<Weather>().map(JSON: json as! [String : Any]) {
                    closure(weather, nil)
                } else {
                    closure( nil, "Can`t parse json to Weather" )
                }
                
            case .failure(let error):
                print(#function, error.localizedDescription)
                closure(nil, error.localizedDescription)
            }
        }
    }
    
}
