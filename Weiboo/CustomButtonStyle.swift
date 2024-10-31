//
//  CustomButtonStyle.swift
//  Weiboo
//
//  Created by chenxihang on 2024/8/17.
//
import SwiftUI

// 自定义按钮样式，用原来的样式
struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}
