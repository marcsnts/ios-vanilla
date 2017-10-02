//
//  LocationContentData.swift
//  Vanilla
//
//  Created by Marc Santos on 2017-10-02.
//  Copyright © Flybits Inc. All rights reserved.
//

import Foundation
import FlybitsKernelSDK

class LocationContentData: ContentData {
    var city: String
    var postalCode: String
    var province: String
    var country: String
    var address: String

    required init?(responseData: Any) throws {
        guard let representation = responseData as? [String: Any] else { throw ContentError.missingRepresentationDictionary }
        guard let city = representation[Key.city.rawValue] as? String else { throw ContentError.missingProperty(Key.city.rawValue) }
        guard let postalCode = representation[Key.postalCode.rawValue] as? String else { throw ContentError.missingProperty(Key.postalCode.rawValue) }
        guard let province = representation[Key.province.rawValue] as? String else { throw ContentError.missingProperty(Key.province.rawValue) }
        guard let country = representation[Key.country.rawValue] as? String else { throw ContentError.missingProperty(Key.country.rawValue) }
        guard let address = representation[Key.address.rawValue] as? String else { throw ContentError.missingProperty(Key.address.rawValue) }

        self.city = city
        self.postalCode = postalCode
        self.province = province
        self.country = country
        self.address = address

        try! super.init(responseData: responseData)
    }
}

// MARK: - Content data property keys

extension LocationContentData {
    enum Key: String {
        case city
        case postalCode = "postal"
        case province
        case country
        case address
    }
}
