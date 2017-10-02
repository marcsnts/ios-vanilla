//
//  RestaurauntContentData.swift
//  Vanilla
//
//  Created by Marc Santos on 2017-10-02.
//  Copyright © 2017 Alex. All rights reserved.
//

import Foundation
import FlybitsKernelSDK

class RestaurauntContentData: ContentData {
    var name: String
    var openingDate: Date
    var numEmployees: Int
    var location: LocationContentData

    required init?(responseData: Any) throws {
        guard let representation = responseData as? [String: Any] else { throw ContentError.missingRepresentationDictionary }
        guard let name = representation[Key.name.rawValue] as? String else { throw ContentError.missingProperty(Key.name.rawValue) }
        guard let openingDate = representation[Key.openingDate.rawValue] as? String else { throw ContentError.missingProperty(Key.openingDate.rawValue) }
        guard let numEmployees = representation[Key.location.rawValue] as? Int else { throw ContentError.missingProperty(Key.numberOfEmployees.rawValue) }
        guard let location = representation[Key.location.rawValue] else { throw ContentError.missingProperty(Key.location.rawValue) }

        self.name = name
        self.openingDate = openingDate.toDate()!
        self.numEmployees = numEmployees
        try! self.location = LocationContentData(responseData: location)!

        try! super.init(responseData: responseData)
    }
}

extension RestaurauntContentData {
    enum Key: String {
        case name
        case openingDate
        case numberOfEmployees = "numEmployees"
        case location
    }
}
