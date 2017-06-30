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
import RxSwiftUtilities

struct ChannelsViewModel {
    
    let apiRequest: RequestClient
    private let bag: DisposeBag = DisposeBag()
    
    init(with apiRequest: RequestClient) {
        self.apiRequest = apiRequest
    }
    
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
