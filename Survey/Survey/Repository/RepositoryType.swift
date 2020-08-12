//
//  RepositoryType.swift
//  Survey
//
//  Created by Menesidis on 12/8/20.
//  Copyright © 2020 Survey. All rights reserved.
//

import Foundation
import RxSwift
import Moya

protocol RepositoryType {

    func requestSingle<ER: EntityResponse, ERE: EntityErrorResponse>(client: HTTPClient, target: TargetType, responseType: ER.Type, errorType: ERE.Type, keyPath: String?) -> Observable<ER.BM>

    func requestCollection<ER: EntityResponse, ERE: EntityErrorResponse>(client: HTTPClient, target: TargetType, responseType: [ER].Type, errorType: ERE.Type, keyPath: String?) -> Observable<[ER.BM]>
}

extension RepositoryType {

    func requestSingle<ER, ERE>(client: HTTPClient,
                                target: TargetType,
                                responseType: ER.Type,
                                errorType: ERE.Type,
                                keyPath: String? = nil) -> Observable<ER.BM> where ER: EntityResponse, ERE: EntityErrorResponse {
        return client
            .requestSingle(target: target, responseType: responseType, errorType: errorType, keyPath: keyPath)
            .asObservable()
            .map { return $0.businessModel }
    }

    func requestCollection<ER, ERE>(client: HTTPClient,
                                    target: TargetType,
                                    responseType: [ER].Type,
                                    errorType: ERE.Type,
                                    keyPath: String? = nil) -> Observable<[ER.BM]> where ER: EntityResponse, ERE: EntityErrorResponse {
        return client
            .requestCollection(target: target, responseType: responseType, errorType: errorType, keyPath: keyPath)
            .asObservable()
            .map { return $0.map { $0.businessModel } }
    }
}
