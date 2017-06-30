//
//  ChannelsViewModel.swift
//  SevenWestMedia
//
//  Created by siavash abbasalipour on 30/6/17.
//  Copyright © 2017 Siavash. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

struct ChannelsViewModel {
    
    // MARK:- Properties
    let apiRequest: RequestClient
    private let bag: DisposeBag = DisposeBag()
    
    // MARK:- Initialise
    init(with apiRequest: RequestClient) {
        self.apiRequest = apiRequest
    }
    
    /// fetched channels
    ///
    /// - Returns: return an Observer of the channels
    func getChannels() -> Observable<[ChannelModel]>  {
        let apiObserver = NetworkService.shared.makeNetworkCallWith(requestClient: apiRequest)
        return Observable.create { observer in
            let _ = apiObserver.subscribe({ (item) in
                switch item.event {
                case .next(let json):
                    switch json {
                    case .success(let jsonDic):
                        var channelArray: [ChannelModel] = []
                        if let channels = jsonDic["channels"] as? Array<JSONDictionary> {
                            for channel in channels {
                                let chModel = ChannelModel.init(from: channel)
                                channelArray.append(chModel)
                            }
                            // sort them
                            observer.onNext(self.sort(channels: channelArray))
                        } else {
                            observer.onError(APIError.badReponse)
                        }
                    case .error(let error):
                        observer.onError(error)
                    }
                    
                case .error(let error):
                    observer.onError(error)
                default:
                    break
                }

            })
            return Disposables.create()
        }
    }
    // MARK:- Private helper
    
    /// sort channel array based on display order
    ///
    /// - Parameter programs: channel array to be sorted
    /// - Returns: sorted program array
    private func sort(channels: [ChannelModel]) -> [ChannelModel] {
        return channels.sorted { (a, b) -> Bool in
            a.displayOrder < b.displayOrder
        }
    }
}

struct ChannelModel {
    let id: Int
    let name: String
    let displayOrder: Int
    
    init(from json: JSONDictionary) {
        self.id = json[JSONKeys.Channel.id] as? Int ?? 0
        self.name = json[JSONKeys.Channel.name] as? String ?? ""
        self.displayOrder = json[JSONKeys.Channel.displayOrder] as? Int ?? 0
    }
}
