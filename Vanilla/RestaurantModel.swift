//
//  RestaurantModel.swift
//  Vanilla
//
//  Created by Marc Santos on 2017-09-28.
//  Copyright © 2017 Alex. All rights reserved.
//

import Foundation
import FlybitsKernelSDK

class RestaurantModel: ContentData {
    var name: String
    var openingDate: Date
    var numEmployees: Int
    var location: LocationModel

    required init?(responseData: Any) throws {
        guard let representation = responseData as? [String: Any] else { throw ContentError.missingRepresentationDictionary }
        guard let name = representation[Key.name.rawValue] as? String else { throw ContentError.missingProperty(Key.name.rawValue) }
        guard let openingDate = representation[Key.openingDate.rawValue] as? String else { throw ContentError.missingProperty(Key.openingDate.rawValue) }
        guard let numEmployees = representation[Key.location.rawValue] as? Int else { throw ContentError.missingProperty(Key.numberOfEmployees.rawValue) }
        guard let location = representation[Key.location.rawValue] else { throw ContentError.missingProperty(Key.location.rawValue) }

        self.name = name
        self.openingDate = openingDate.toDate()!
        self.numEmployees = numEmployees
        try! self.location = LocationModel(responseData: location)!

        try! super.init(responseData: responseData)
    }
}

extension RestaurantModel {
    enum Key: String {
        case name,
        openingDate,
        numberOfEmployees = "numEmployees",
        location
    }
}

class LocationModel: ContentData {
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

extension LocationModel {
    enum Key: String {
        case city,
        postalCode = "postal",
        province,
        country,
        address
    }
}
