//
//  UIViewController + AlertController.swift
//  Pace
//
//  Created by lee on 1/21/16.
//  Copyright © 2016 OALeeapp. All rights reserved.
//

import UIKit

typealias textFieldConfigurationClosure = (UITextField) -> Void

extension UIViewController {

    func alertController(title : String?, message : String?, actions: [UIAlertAction], textFieldConfigures: [textFieldConfigurationClosure]) -> UIAlertController {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)

        for action in actions {
            alertController.addAction(action)
        }

        for configureClosure in textFieldConfigures {
            alertController.addTextFieldWithConfigurationHandler(configureClosure)
        }

        return alertController

    }

    func actionSheetController(title : String?, message : String?, actions: [UIAlertAction]) -> UIAlertController {

        let actionSheetController = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)

        for action in actions {
            actionSheetController.addAction(action)
        }

        return actionSheetController
    }
}
