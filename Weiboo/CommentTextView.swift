//
//  CommentTextView.swift
//  Weiboo
//
//  Created by chenxihang on 2024/8/15.
//  文本输入框

import SwiftUI

// 封装UIKit的 UITextView 给 SwiftUI使用
struct CommentTextView: UIViewRepresentable {
    
    @Binding var text: String
    
    // 首次出现，进入编辑态
    let beginEdittingOnAppear: Bool
    
    // 构建协调器
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // 构建textView
    func makeUIView(context: Context) -> some UIView {
        let textView = UITextView()
        textView.backgroundColor = .systemGray6
        textView.font = .systemFont(ofSize: 18)
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        textView.delegate = context.coordinator
        textView.text = text
        return textView
    }
    
    // 更新UI
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
        // 满足条件，进入编辑态
        if beginEdittingOnAppear,
           !context.coordinator.didBecomeFirstResponder,
//           uiView.window != nil,
           !uiView.isFirstResponder {
            uiView.becomeFirstResponder()
            context.coordinator.didBecomeFirstResponder = true
        }
           
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        let parent: CommentTextView
        
        // 是否已经成为第一响应者
        var didBecomeFirstResponder: Bool = false
        
        init(_ parent: CommentTextView) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
    }
}

#Preview {
    CommentTextView(text: .constant(""), beginEdittingOnAppear: true)
}
