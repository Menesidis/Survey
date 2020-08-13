//
//  ResponseModifierPlugin.swift
//  Survey
//
//  Created by Menesidis on 13/8/20.
//  Copyright © 2020 Survey. All rights reserved.
//

import Foundation
import Moya

final class ResponseModifierPlugin: PluginType {
    /// Called to modify a result before completion.
    func process(_ result: Result<Moya.Response, MoyaError>, target: TargetType) -> Result<Moya.Response, MoyaError> {

        switch result {
            
        case .success(let response):
            
            guard let target = target as? Modifiable else {return result}
            let inputValue = String(decoding: response.data, as: UTF8.self)
            let outputValue = target.convertInputValue(input: inputValue, statusCode: response.statusCode)
            guard let data = outputValue?.data(using: .utf8) else { return result}

            let modifiedResponse = Response(statusCode: response.statusCode,
                                            data: data,
                                            request: response.request,
                                            response: response.response)
            return .success(modifiedResponse)
        default:
            return result
        }
    }
}
