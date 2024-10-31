//
//  HScrollViewController.swift
//  Weiboo
//
//  Created by chenxihang on 2024/8/15.
//  微博首页横滑UIScrollView容器

import SwiftUI

// 将UIKit的UIScrollView 封装成 swiftUI 控件
struct HScrollViewController<Content: View>: UIViewControllerRepresentable {
    let pageWidth: CGFloat
    let contentSize: CGSize
    let content: Content
    @Binding var leftPercent: CGFloat // 双向绑定的属性
    
    // 初始化
    init(pageWidth: CGFloat, contentSize: CGSize, leftPercent: Binding<CGFloat>, @ViewBuilder content: () -> Content) {
        self.pageWidth = pageWidth
        self.contentSize = contentSize
        self.content = content()
        self._leftPercent = leftPercent
    }
    
    // 构建协调器
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    // 自定义View
    func makeUIViewController(context: Context) -> UIViewController {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = context.coordinator
        context.coordinator.scrollView = scrollView
        
        let vc = UIViewController()
        vc.view.addSubview(scrollView)
        
        let host = UIHostingController(rootView: content)
        vc.addChild(host)
        scrollView.addSubview(host.view)
        host.didMove(toParent: vc)
        context.coordinator.host = host
        
        return vc
    }
    
    // 更新UI
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        let scrollView = context.coordinator.scrollView!
        scrollView.frame = CGRect(x: 0, y: 0, width: pageWidth, height: contentSize.height)
        scrollView.contentSize = contentSize
        scrollView.setContentOffset(CGPoint(x: leftPercent * (contentSize.width - pageWidth), y: 0), animated: true)
        context.coordinator.host.view.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: contentSize)
    }
    
    // 协调器
    class Coordinator: NSObject, UIScrollViewDelegate {
        let parent: HScrollViewController
        var scrollView: UIScrollView!
        var host: UIHostingController<Content>!
        
        init(parent: HScrollViewController) {
            self.parent = parent
        }
        
        // MARK - UIScrollViewDelegate
        // 滑动结束时
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            withAnimation {
                parent.leftPercent = scrollView.contentOffset.x < parent.pageWidth * 0.5 ? 0 : 1
            }
        }
    }
}
