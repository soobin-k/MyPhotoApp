//
//  Extension.swift
//  MyPhotoApp
//
//  Created by 김수빈 on 2022/02/05.
//

import UIKit

extension UIViewController {
    // 알림창
    func presentAlert(title: String, message: String? = nil,
                      preferredStyle style: UIAlertController.Style = .alert,
                      handler: ((UIAlertAction) -> Void)? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: style)
            let actionDone = UIAlertAction(title: "확인", style: .default, handler: handler)
            alert.addAction(actionDone)
            self.present(alert, animated: true, completion: nil)
        }
    }
}
