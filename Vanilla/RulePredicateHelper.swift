//
//  RulePredicateHelper.swift
//  Vanilla
//
//  Created by Marc Santos on 2017-10-11.
//  Copyright © 2017 Flybits Inc. All rights reserved.
//

import Foundation
import FlybitsContextSDK

enum RulePredicateOperator: Int {
    case equalTo
    case notEqualTo
    case lessThan
    case lessThanOrEqualTo
    case greaterThan
    case greaterThanOrEqualTo

    var string: String {
        switch self {
        case .notEqualTo: return "Not equal to"
        case .lessThan: return "Less than"
        case .lessThanOrEqualTo: return "Less than or equal to"
        case .equalTo: return "Equal to"
        case .greaterThan: return "Greater than"
        case .greaterThanOrEqualTo: return "Greater than or equal to"
        }
    }
}

enum RulePredicateValueType: Int {
    case integer
    case string
    case boolean

    var numberOfOperators: Int {
        switch self {
        case .integer: return 6
        case .string: return 2
        case .boolean: return 2
        }
    }

    var title: String {
        switch self {
        case .integer: return "Integer"
        case .string: return "String"
        case .boolean: return "Boolean"
        }
    }

    static let count = 3
}

protocol RulePredicatable {}

extension Int: RulePredicatable {}
extension String: RulePredicatable {}
extension Bool: RulePredicatable {}

struct RulePredicateFactory {
    var type: RulePredicateValueType
    var predicateOperators: [RulePredicateOperator] {
        switch type {
        case .boolean, .string: return [.notEqualTo, .equalTo]
        case .integer: return [.notEqualTo, .equalTo, .lessThan, .lessThanOrEqualTo, .greaterThan, .greaterThanOrEqualTo]
        }
    }
    var selectedOperator: RulePredicateOperator?

    func makeRulePredicate(pluginId: String, value: RulePredicatable) -> RulePredicate? {
        guard let selectedOperator = self.selectedOperator, self.predicateOperators.contains(selectedOperator) else { return nil }

        if let intValue = value as? Int {
            switch selectedOperator {
            case .equalTo: return RulePredicate.equals(plugin: pluginId, value: intValue)
            case .notEqualTo: return RulePredicate.notEquals(plugin: pluginId, value: intValue)
            case .lessThan: return RulePredicate.lessThan(plugin: pluginId, value: intValue)
            case .lessThanOrEqualTo: return RulePredicate.lessThanOrEqual(plugin: pluginId, value: intValue)
            case .greaterThan: return RulePredicate.greaterThan(plugin: pluginId, value: intValue)
            case .greaterThanOrEqualTo: return RulePredicate.greaterThanOrEqual(plugin: pluginId, value: intValue)
            }
        } else if let stringValue = value as? String {
            switch selectedOperator {
            case .equalTo: return RulePredicate.equals(plugin: pluginId, value: stringValue)
            case .notEqualTo: return RulePredicate.notEquals(plugin: pluginId, value: stringValue)
            default: break
            }
        } else if let boolValue = value as? Bool {
            switch selectedOperator {
            case .equalTo: return RulePredicate.equals(plugin: pluginId, value: boolValue)
            case .notEqualTo: return RulePredicate.notEquals(plugin: pluginId, value: boolValue)
            default: break
            }
        }

        return nil
    }
}
