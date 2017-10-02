//
//  CustomPlugin.swift
//  Vanilla
//
//  Created by Marc Santos on 2017-10-02.
//  Copyright © 2017 Flybits Inc. All rights reserved.
//

import Foundation

enum CustomPlugin {
    case wallet

    func id() -> String {
        switch self {
        case .wallet:
            return "ctx.ios-vanilla.Finance"
        }
    }
}
