//
//  l10n.swift
//  Meteorologist
//
//  Created by Ruslan on 4/27/18.
//  Copyright © 2018 Ruslan Popesku. All rights reserved.
//

import Foundation
// swiftlint:disable file_length
// swiftlint:disable type_body_length
enum L10n {
    /// Save
    case commonButtonsSaveButtonTitle
    /// OK
    case commonButtonsOkButtonTitle
    /// Login
    case authLoginButtonTitle
    /// Settings
    case settingsTitle
    /// Go to Profile
    case settignsGoToProfileTitle
    /// Privacy Policy
    case settignsPrivacyPolicyTitle
    /// Logout
    case settignsLogoutTitle
    /// Profile
    case profileTitle
    /// Name
    case profileNameTitle
    /// Bio
    case profileBioTitle
    /// URL
    case profileBlogUrlTitle
    /// Company
    case profileCompanyTitle
    /// Location
    case profileLocationTitle
    /// Repositories
    case feedTitle
    /// Feed
    case feedTabbarTitle
    /// Error
    case alertDefaultErrorTile
    /// Success
    case alertDefaultSuccessTile
    /// Information
    case alertDefaultInfoTile
    /// %i star(s)
    case repositoryStarsCount(Int)
    /// %i forks(s)
    case repositoryForksCount(Int)
    /// Name can't be empty
    case userNameValidationError
    /// Bio can't be empty
    case userBioValidationError
    /// Blog URL should be valid URL
    case userBlogURLValidationError
}
// swiftlint:enable type_body_length

extension L10n: CustomStringConvertible {
    var description: String { return self.string }
    
    var string: String {
        switch self {
        case .commonButtonsSaveButtonTitle:
            return L10n.tr(key: "common_buttons.save_button.title")
        case .commonButtonsOkButtonTitle:
            return L10n.tr(key: "common_buttons.ok_button.title")
        case .authLoginButtonTitle:
            return L10n.tr(key: "auth.login_button.title")
        case .settingsTitle:
            return L10n.tr(key: "settings.title")
        case .settignsGoToProfileTitle:
            return L10n.tr(key: "settigns.go_to_profile.title")
        case .settignsPrivacyPolicyTitle:
            return L10n.tr(key: "settigns.privacy_policy.title")
        case .settignsLogoutTitle:
            return L10n.tr(key: "settigns.logout.title")
        case .profileTitle:
            return L10n.tr(key: "profile.title")
        case .profileNameTitle:
            return L10n.tr(key: "profile.name.title")
        case .profileBioTitle:
            return L10n.tr(key: "profile.bio.title")
        case .profileBlogUrlTitle:
            return L10n.tr(key: "profile.blog_url.title")
        case .profileCompanyTitle:
            return L10n.tr(key: "profile.company.title")
        case .profileLocationTitle:
            return L10n.tr(key: "profile.location.title")
        case .feedTitle:
            return L10n.tr(key: "feed.title")
        case .feedTabbarTitle:
            return L10n.tr(key: "feed.tabbar.title")
        case .alertDefaultErrorTile:
            return L10n.tr(key: "alert.default_error_tile")
        case .alertDefaultSuccessTile:
            return L10n.tr(key: "alert.default_success_tile")
        case .alertDefaultInfoTile:
            return L10n.tr(key: "alert.default_info_tile")
        case .repositoryStarsCount(let p0):
            return L10n.tr(key: "repository.stars_count", p0)
        case .repositoryForksCount(let p0):
            return L10n.tr(key: "repository.forks_count", p0)
        case .userNameValidationError:
            return L10n.tr(key: "user.name.validation_error")
        case .userBioValidationError:
            return L10n.tr(key: "user.bio.validation_error")
        case .userBlogURLValidationError:
            return L10n.tr(key: "user.blogURL.validation_error")
        }
    }
    
    private static func tr(key: String, _ args: CVarArg...) -> String {
        let format = NSLocalizedString(key, comment: "")
        return String(format: format, locale: Locale.current, arguments: args)
    }
}

func tr(key: L10n) -> String {
    return key.string
}
