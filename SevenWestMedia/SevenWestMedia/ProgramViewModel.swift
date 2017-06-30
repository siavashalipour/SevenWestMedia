//
//  ProgramViewModel.swift
//  SevenWestMedia
//
//  Created by siavash abbasalipour on 30/6/17.
//  Copyright © 2017 Siavash. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxSwiftUtilities

struct ProgramViewModel {
    
    let apiRequest: RequestClient
    private let bag: DisposeBag = DisposeBag()
    
    init(with apiRequest: RequestClient) {
        self.apiRequest = apiRequest
    }
    
    func getPrograms() -> Observable<[ProgramModel]>  {
        let apiObserver = NetworkService.shared.makeNetworkCallWith(requestClient: apiRequest)
        return Observable.create { observer in
            let _ = apiObserver.subscribe({ (item) in
                switch item.event {
                case .next(let json):
                    switch json {
                    case .success(let jsonDic):
                        var programArray: [ProgramModel] = []
                        if let programs = jsonDic["programs"] as? Array<JSONDictionary> {
                            for program in programs {
                                let prModel = ProgramModel.init(from: program)
                                programArray.append(prModel)
                            }
                            // sort them
                            observer.onNext(self.sort(programs: programArray))
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
    private func sort(programs: [ProgramModel]) -> [ProgramModel] {
        return programs.sorted { (a, b) -> Bool in
            a.startTime < b.startTime
        }
    }
    
}

struct ProgramModel {
    let id: Int
    let title: String
    let imageURL: String
    let startTime: Date
    let endTime: Date
    
    init(from json: JSONDictionary) {
        self.id = json[JSONKeys.Program.id] as? Int ?? 0
        self.title = json[JSONKeys.Program.title] as? String ?? ""
        self.imageURL = json[JSONKeys.Program.imageUrl] as? String ?? ""
        self.startTime = Misc.transformDateFormat(json[JSONKeys.Program.startTime]as? String) ?? Date()
        self.endTime = Misc.transformDateFormat(json[JSONKeys.Program.endTime] as? String) ?? Date()
    }
}


