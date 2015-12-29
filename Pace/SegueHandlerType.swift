//
//  SegueHandlerType.swift
//  Pace
//
//  Created by lee on 12/28/15.
//  Copyright © 2015 OALeeapp. All rights reserved.
//

import UIKit
import Foundation

protocol SegueHandlerType {
    typealias SegueIdentifier: RawRepresentable
}

extension SegueHandlerType where Self: UIViewController,
    SegueIdentifier.RawValue == String
{

    func performSegueWithIdentifier(segueIdentifier: SegueIdentifier,
        sender: AnyObject?) {

            performSegueWithIdentifier(segueIdentifier.rawValue, sender: sender)
    }

    func segueIdentifierForSegue(segue: UIStoryboardSegue) -> SegueIdentifier {

        guard let identifier = segue.identifier,
            segueIdentifier = SegueIdentifier(rawValue: identifier) else { fatalError("Invalid segue identifier \(segue.identifier).") }

        return segueIdentifier
    }
}