//
//  PostVipBadge.swift
//  Weiboo
//
//  Created by chenxihang on 2024/8/13.
//

import SwiftUI

struct PostVipBadge: View {
    
    let vip: Bool
    
    var body: some View {
        Group {
            if vip {
                Text("V")
                    .bold()
                    .font(.system(size: 12))
                    .frame(width: 15, height:15)
                    .foregroundColor(.yellow)
                    .background(.red)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    .overlay {
                        RoundedRectangle(cornerRadius: 7.5)
                            .stroke(.white, lineWidth: 1)
                    }
            }
        }
    }
}

#Preview {
    PostVipBadge(vip: true)
}
