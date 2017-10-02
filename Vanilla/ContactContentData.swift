//
//  ContactContentData.swift
//  Vanilla
//
//  Created by Marc Santos on 2017-10-02.
//  Copyright © 2017 Alex. All rights reserved.
//

import Foundation
import FlybitsKernelSDK

class ContactContentData: ContentData {
    var firstName: String
    var lastName: String
    var dob: Date?
    var company: String?
    var profilePicture: URL?
    var email: String
    var phoneNumber: Int

    required init?(responseData: Any) throws {
        guard let representation = responseData as? [String: Any] else { throw ContentError.missingRepresentationDictionary }
        guard let firstName = representation[Key.firstName.rawValue] as? String else { throw ContentError.missingProperty(Key.firstName.rawValue) }
        guard let lastName = representation[Key.lastName.rawValue] as? String else { throw ContentError.missingProperty(Key.lastName.rawValue) }
        guard let email = representation[Key.email.rawValue] as? String else { throw ContentError.missingProperty(Key.email.rawValue) }
        guard let phoneNumber = representation[Key.phoneNumber.rawValue] as? Int else { throw ContentError.missingProperty(Key.phoneNumber.rawValue) }

        self.firstName = firstName
        self.lastName = lastName
        self.dob = (representation["dob"] as? String)?.toDate()
        self.company = representation["company"] as? String
        if let profilePictureURL = representation["profilePicture"] as? String {
            self.profilePicture = URL(string: profilePictureURL)
        }
        self.email = email
        self.phoneNumber = phoneNumber

        try! super.init(responseData: responseData)
    }
}

// MARK: - Content data property keys

extension ContactContentData {
    enum Key: String {
        case firstName
        case lastName
        case dob
        case company
        case profilePicture
        case email
        case phoneNumber
    }
}
