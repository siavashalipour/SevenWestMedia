//
//  Common.swift
//  SevenWestMedia
//
//  Created by siavash abbasalipour on 30/6/17.
//  Copyright © 2017 Siavash. All rights reserved.
//

import Foundation
import UIKit

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
struct APIPath {
    static let base: String = "https://s3-ap-southeast-2.amazonaws.com/swm-ftp-s3/ios"
}
struct MainStoryboardSegue {
    static let showDetail: String = "showDetail"
}
struct TableViewCellIdentifier {
    static let programCell: String = "ProgramTableViewCell"
    static let channelCell: String = "channelCell"
}

extension Date {
    static func transformDateFormat(_ dateString: String?) -> Date? {
        let theDate = DateTimeFormats.formatter.date(from: dateString ?? "")
        return theDate
    }
}

extension UIViewController {
    /// present an AlertViewController modally on current ViewController with one Action button
    ///
    /// - Parameters:
    ///   - error: `Error` object
    ///   - actionTitle: action button title
    ///   - actionType: action button type
    ///   - action: action button action function
    func showOneButtonAlertViewWith(error: Error, actionTitle: String, actionType: UIAlertActionStyle = .default, action: ((UIAlertAction) -> Void)? = nil ) {
        let atitle: String = "Error"
        let message: String = "Something went wrong :( - \(error.localizedDescription)"
        let alertViewController = UIAlertController.init(title: atitle, message: message, preferredStyle: .alert)
        let actionButton = UIAlertAction.init(title: actionTitle, style: actionType, handler: action)
        alertViewController.addAction(actionButton)
        present(alertViewController, animated: true, completion: nil)
    }
}
