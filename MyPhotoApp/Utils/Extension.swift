//
//  Extension.swift
//  MyPhotoApp
//
//  Created by 김수빈 on 2022/02/05.
//

import UIKit

extension UIViewController {
    // 기본 알림창
    func presentAlert(title: String, message: String? = nil,
                      isDoneTitle: String = "확인",
                      isCancelActionIncluded: Bool = false,
                      isCancelTitle: String = "취소",
                      preferredStyle style: UIAlertController.Style = .alert,
                      handler: ((UIAlertAction) -> Void)? = nil) {
        DispatchQueue.main.async {
            // 확인 버튼(필수)
            let alert = UIAlertController(title: title, message: message, preferredStyle: style)
            let actionDone = UIAlertAction(title: isDoneTitle, style: .default, handler: handler)
            alert.addAction(actionDone)
            
            // 취소 버튼(필수 X)
            if isCancelActionIncluded {
                        let actionCancel = UIAlertAction(title: isCancelTitle, style: .cancel, handler: nil)
                        alert.addAction(actionCancel)
            }
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}
