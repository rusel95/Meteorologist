//
//  Cities.swift
//  Meteorologist
//
//  Created by Ruslan Popesku on 3/31/18.
//  Copyright © 2018 Ruslan Popesku. All rights reserved.
//

enum City {
    case Dnipro
    case Kiev
    case Odessa
    case Lviv
    case London
    case NewYork
    case Paris
    case Rio
    case Kanberra
    case Pekin
    case Sidney
    case Dubai
    
    var name: String {
        switch self {
        case .Dnipro: return "Dnipro"
        case .Kiev: return "Kiev"
        case .Odessa: return "Odessa"
        case .Lviv: return "Lviv"
        case .London: return "London"
        case .NewYork: return "NewYork"
        case .Paris: return "Paris"
        case .Rio: return "Rio"
        case .Kanberra: return "Kanberra"
        case .Pekin: return "Pekin"
        case .Sidney: return "Sidney"
        case .Dubai: return "Dubai"
        }
    }
    
    var coords: String {
        switch self {
        case .Dnipro: return "48.478803,35.022301"
        case .Kiev: return "50.458562,30.532666"
        case .Odessa: return "46.461687,30.754052"
        case .Lviv: return "49.839754,24.023220"
        case .London: return "51.506340,0.098901"
        case .NewYork: return "40.772213,73.973106"
        case .Paris: return "48.854462,2.337863"
        case .Rio: return "-22.970795,-43.531159"
        case .Kanberra: return "-35.282215,149.128384"
        case .Pekin: return "39.921697,116.364470"
        case .Sidney: return "-33.886697,151.157166"
        case .Dubai: return "25.170514,55.236330"
        }
    }
}
