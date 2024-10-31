//
//  KeyboardResponder.swift
//  Weiboo
//
//  Created by chenxihang on 2024/8/15.
//

import SwiftUI

// 键盘监听器
class KeyboardResponder: ObservableObject {
    
    // 键盘高度
    @Published var keyboardHeight: CGFloat = 0
    
    // 键盘是否显示
    var keyboardShow: Bool {
        return keyboardHeight > 0
    }
    
    init() {
        // 键盘弹出
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_ :)), name: UIWindow.keyboardWillShowNotification, object: nil)
        // 键盘弹出
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_ :)), name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let frame = notification.userInfo?[UIWindow.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        keyboardHeight = frame.height
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        keyboardHeight = 0
    }
}
