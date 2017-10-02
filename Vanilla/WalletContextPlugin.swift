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
    var pluginID: String = CustomPlugin.wallet.id()
    var refreshTime: Int32 = 15
    var timeUnit: TimeUnit = .seconds

    // Plugin Attributes
    var hasCreditCard: Bool?
    var money: Double?

    init(hasCreditCard: Bool?, money: Double?) {
        self.hasCreditCard = hasCreditCard
        self.money = money
        super.init()
    }

    func toDictionary() -> [String : Any] {
        var dictionary: [String: Any] = [
            "dataTypeID": pluginID,
            "timestamp": NSNumber(value: Int64(Date().timeIntervalSince1970))
        ]
        var valueDictionary = [String: Any]()
        if let hasCreditCard = self.hasCreditCard {
            valueDictionary["creditCard"] = hasCreditCard
        }
        if let money = self.money {
            valueDictionary["money"] = money
        }
        dictionary["value"] = valueDictionary

        return dictionary
    }

    func refreshData(completion: @escaping (Any?, NSError?) -> Void) {
        let customData = toDictionary()
        completion(customData, nil)
    }
}
