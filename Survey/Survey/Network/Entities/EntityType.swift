//
//  EntityType.swift
//  Survey
//
//  Created by Menesidis on 12/8/20.
//  Copyright © 2020 Survey. All rights reserved.
//

import Foundation

/**
 Used to encapsulate parameters for a call
 */
public protocol EntityRequest {
    var parameters: [String: Any] { get }
}

/**
 Used for deserializing JSON, as well as for transforming this entity to a domain object
 */
public protocol EntityResponse: Decodable {
    associatedtype BM: BusinessModel
    var businessModel: BM { get }
}

/**
 Used for deserializing JSON error messages
 It provides an `error` variable for converting JSON to a Swift Error
 */
public protocol EntityErrorResponse: Decodable {
    var error: Error { get }
}
