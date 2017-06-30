//
//  Common.swift
//  SevenWestMedia
//
//  Created by siavash abbasalipour on 30/6/17.
//  Copyright © 2017 Siavash. All rights reserved.
//

import Foundation

typealias JSONDictionary = [String: Any]


struct DateTimeFormats {
    static let apiDateTimeFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    static var formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = DateTimeFormats.apiDateTimeFormat
        return dateFormatter
    }()
}

struct JSONKeys {
    struct Program {
        static let id: String = "id"
        static let title: String = "title"
        static let imageUrl: String = "imageUrl"
        static let startTime: String = "start_time"
        static let endTime: String = "end_time"
    }
    struct Channel {
        static let id: String = "channelId"
        static let name: String = "name"
        static let displayOrder: String = "displayOrder"
    }
}
struct MainStoryboardSegue {
    static let showDetail: String = "showDetail"
}
struct TableViewCellIdentifier {
    static let programCell: String = "ProgramTableViewCell"
    static let channelCell: String = "channelCell"
}
struct Misc {
    static func transformDateFormat(_ dateString: String?) -> Date? {
        let theDate = DateTimeFormats.formatter.date(from: dateString ?? "")
        return theDate
    }
}
