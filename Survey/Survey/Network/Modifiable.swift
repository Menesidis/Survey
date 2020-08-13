//
//  Modifiable.swift
//  Survey
//
//  Created by Menesidis on 13/8/20.
//  Copyright © 2020 Survey. All rights reserved.
//

import Foundation
import Moya

protocol Modifiable {
    func convertInputValue(input: String, statusCode: Int) -> String?
}

/*
This is needed in order to allow Plugins to work with MultiTargets
Read more here: https://github.com/Moya/Moya/issues/1720 (even if the Auth plugin was fixed in Moya 14)
*/

extension MultiTarget: Modifiable {
    func convertInputValue(input: String, statusCode: Int) -> String? {
        if let target = self.target as? Modifiable {
            return target.convertInputValue(input: input, statusCode: statusCode)
        }
        return nil
    }
}
