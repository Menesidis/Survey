//
//  HTTPClient.swift
//  Survey
//
//  Created by Menesidis on 12/8/20.
//  Copyright © 2020 Survey. All rights reserved.
//

import Foundation
import Moya
import RxSwift

struct HTTPClient {
    enum HTTPClientError: Error {
        case parsingError(String, String)
    }
    
    let provider: MoyaProvider<MultiTarget>
    
    init(provider: MoyaProvider<MultiTarget> = MoyaProvider<MultiTarget>(plugins:[
        ResponseModifierPlugin(),
        NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration.init(formatter: NetworkLoggerPlugin.Configuration.Formatter.init(),logOptions: .verbose))
    ]))
    {
        self.provider = provider
    }
    
    func requestSingle<ER: EntityResponse, E: EntityErrorResponse>(target: TargetType, responseType: ER.Type, errorType: E.Type, keyPath: String? = nil) -> Observable<ER> {
        return provider.rx
            .request(MultiTarget.target(target), callbackQueue: DispatchQueue.global(qos: .background))
            .filter(statusCodes: 200...404) //TODO: Check this!
            .flatMap({ (response) -> Single<ER> in
                if let responseType = try? response.map(ER.self, atKeyPath: keyPath) {
                    return Single.just(responseType)
                } else if let errorType = try? response.map(E.self) {
                    return Single.error(errorType.error)
                } else {
                    throw HTTPClientError.parsingError("\(responseType)", "\(errorType)")
                }
            })
            .asObservable()
    }
    
    func requestCollection<ER: EntityResponse, E: EntityErrorResponse>(target: TargetType, responseType: [ER].Type, errorType: E.Type, keyPath: String? = nil) -> Observable<[ER]> {
        return provider.rx
            .request(MultiTarget.target(target), callbackQueue: DispatchQueue.global(qos: .background))
            .filter(statusCodes: 200...404) //TODO: Check this!
            .flatMap({ (response) -> Single<[ER]> in
                if let responseType = try? response.map([ER].self, atKeyPath: keyPath) {
                    return Single.just(responseType)
                } else if let errorType = try? response.map(E.self) {
                    return Single.error(errorType.error)
                } else {
                    throw HTTPClientError.parsingError("\(responseType)", "\(errorType)")
                }
            })
            .asObservable()
    }
}
