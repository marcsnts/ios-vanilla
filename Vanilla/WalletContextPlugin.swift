//
//  WalletContextPlugin.swift
//  Vanilla
//
//  Created by Marc Santos on 2017-10-02.
//  Copyright © 2017 Flybits Inc. All rights reserved.
//

import Foundation
import FlybitsContextSDK

class WalletContextPlugin: NSObject, ContextPlugin, DictionaryConvertible {
    var pluginID: String = "ctx.ios-vanilla.Finance"
    var refreshTime: Int32 = 15
    var timeUnit: TimeUnit = .seconds

    // Plugin Attributes
    var balance: Double?
    var containsPhotoId: Bool?
    var owner: String?

    init(balance: Double?, containsPhotoId: Bool?, owner: String?) {
        self.balance = balance
        self.containsPhotoId = containsPhotoId
        self.owner = owner
        super.init()
    }

    func toDictionary() -> [String : Any] {
        var valueDictionary = [String: Any]()
        if let balance = self.balance {
            valueDictionary["balance"] = balance
        }
        if let containsPhotoId = self.containsPhotoId {
            valueDictionary["containsPhotoId"] = containsPhotoId
        }
        if let owner = self.owner {
            valueDictionary["owner"] = owner
        }

        let dictionary: [String: Any] = [
            "dataTypeID": pluginID,
            "timestamp": NSNumber(value: Int64(Date().timeIntervalSince1970)),
            "value": valueDictionary
        ]

        return dictionary
    }

    func refreshData(completion: @escaping (Any?, NSError?) -> Void) {
        let customData = toDictionary()
        completion(customData, nil)
    }
}
