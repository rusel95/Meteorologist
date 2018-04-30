//
//  SettingsModel.swift
//  Meteorologist
//
//  Created by Ruslan on 4/27/18.
//  Copyright © 2018 Ruslan Popesku. All rights reserved.
//

import Foundation
import EventsTree

protocol SettingsModelInput {
    
    var numberOfSettingsSectionDatas: Int { get }
    func settingsSectionData(at index: Int) -> SettingsModel.DisplayableSettingsSectionData?
    
    func didSelectSection(at index: Int)
    
}

enum SettingsEvent: Event {
    case profileSelected, privacyPolicySelected, logoutSelected
}

protocol SettingsModelOutput: class, ModelOutput {}

class SettingsModel: EventNode {
    
    enum SettingDataType: Int {
        
        case profile = 0, privacyPolicy, logOut
        
        var title: String {
            switch self {
            case .profile:
                return tr(key: .settignsGoToProfileTitle)
                
            case .privacyPolicy:
                return tr(key: .settignsPrivacyPolicyTitle)
                
            case .logOut:
                return tr(key: .settignsLogoutTitle)
                
            }
        }
        
        static func all() -> [SettingDataType] {
            return [.profile, .privacyPolicy, .logOut]
        }
        
    }
    
    struct DisplayableSettingsSectionData {
        let title: String
    }
    
    weak var output: SettingsModelOutput!
    
    fileprivate lazy var displayableSectionsData: [DisplayableSettingsSectionData] = {
        return SettingDataType.all().map { DisplayableSettingsSectionData(title: $0.title) }
    }()
    
}

extension SettingsModel: SettingsModelInput, SettingsViewControllerOutput {
    
    var numberOfSettingsSectionDatas: Int {
        return displayableSectionsData.count
    }
    
    func settingsSectionData(at index: Int) -> SettingsModel.DisplayableSettingsSectionData? {
        if index < displayableSectionsData.count {
            return displayableSectionsData[index]
        }
        
        return nil
    }
    
    func didSelectSection(at index: Int) {
        guard let settingDataType = SettingDataType(rawValue: index) else {
            fatalError("invalid index value: \(index)")
        }
        
        let event: SettingsEvent
        switch settingDataType {
        case .profile:
            event = .profileSelected
            
        case .privacyPolicy:
            event = .privacyPolicySelected
            
        case .logOut:
            event = .logoutSelected
            
        }
        
        raise(event: event)
    }
    
}
