//
//  TextOnlyContent.swift
//  Vanilla
//
//  Created by Alex on 7/12/17.
//  Copyright © 2017 Alex. All rights reserved.
//

import FlybitsKernelSDK

enum ContentError: Error {
    case missingRepresentationDictionary
    case missingLocalizationsDictionary
    case missingProperty(String)
    case dataMismatch(String)
    case deserializationError(String)
}

struct Constant {
    static let textTitle = "txtTitle"
    static let textDescription = "txtDescription"
    static let imageURL = "img"
    static let localizations = "localizations"
}

class TextOnlyContent: ContentData {
    let textTitle: LocalizedObject<String>
    let textDescription: LocalizedObject<String>
    
    required init?(responseData: Any) throws {
        guard let representation = responseData as? [String: Any] else {
            throw ContentError.missingRepresentationDictionary
        }
        guard let localizations = representation[Constant.localizations] as? [String: [String: Any]] else {
            throw ContentError.missingLocalizationsDictionary
        }
        self.textTitle = LocalizedObject<String>(key: Constant.textTitle, localizations: localizations)
        self.textDescription = LocalizedObject<String>(key: Constant.textDescription, localizations: localizations)
        try! super.init(responseData: responseData)
    }
}

class ImageOnlyContent: ContentData {
    let imageURL: URL
    
    required init?(responseData: Any) throws {
        guard let representation = responseData as? [String: Any] else {
            throw ContentError.missingRepresentationDictionary
        }
        guard let url = URL(string: representation[Constant.imageURL] as! String) else {
            throw ContentError.dataMismatch("String to URL")
        }
        self.imageURL = url
        try! super.init(responseData: responseData)
    }
}

class MixedContent: ContentData {
    let textTitle: LocalizedObject<String>
    let textDescription: LocalizedObject<String>
    let imageURL: URL
    
    required init?(responseData: Any) throws {
        guard let representation = responseData as? [String: Any] else {
            throw ContentError.missingRepresentationDictionary
        }
        guard let localizations = representation[Constant.localizations] as? [String: [String: Any]] else {
            throw ContentError.missingLocalizationsDictionary
        }
        self.textTitle = LocalizedObject<String>(key: Constant.textTitle, localizations: localizations)
        self.textDescription = LocalizedObject<String>(key: Constant.textDescription, localizations: localizations)
        
        guard let url = URL(string: representation[Constant.imageURL] as! String) else {
            throw ContentError.dataMismatch("String to URL")
        }
        self.imageURL = url
        try! super.init(responseData: responseData)
    }
}

enum Template: String {
    case contact,
    menuItem,
    restaurant

    init?(fromId: String) {
        if let matchingTemplate = Template.all.filter({$0.id() == fromId}).first {
            self = matchingTemplate
        } else {
            return nil
        }
    }

    func id() -> String {
        switch self {
        case .contact:
            return "E2306E5F-CED3-4927-8A64-58CD0E7E212E"
        case .menuItem:
            return "C97B0E8A-AFD5-424C-B69E-F646EA125229"
        case .restaurant:
            return "37968887-EF03-456C-9EF6-33C7F18B1FEC"
        }
    }

    func title() -> String {
        switch self {
        case .contact:
            return "Contact"
        case .menuItem:
            return "Menu Item"
        case .restaurant:
            return "Restaurant"
        }
    }

    func numberOfProperties() -> Int {
        switch self {
        case .contact:
            return 7
        case .menuItem:
            return 5
        case .restaurant:
            return 8
        }
    }

    static let all: [Template] = [.contact, .menuItem, .restaurant]
}
