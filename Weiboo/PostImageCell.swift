//
//  PostImageCell.swift
//  Weiboo
//
//  Created by chenxihang on 2024/8/14.
//

import SwiftUI
import SDWebImageSwiftUI

// 间距
private let kSpace: CGFloat = 6

// 图片cell
struct PostImageCell: View {
    let images: [String]
    let width: CGFloat
    
    var body: some View {
        Group {
            if images.count == 1 {
                loadImage(name: images[0])
                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height: width * 0.75)
                    .clipped()
            } else if images.count == 2 {
                PostImageCellRow(images: images, width: width)
            } else if images.count == 3 {
                PostImageCellRow(images: images, width: width)
            } else if images.count == 4 {
                VStack(spacing: kSpace, content: {
                    PostImageCellRow(images: Array(images[0...1]), width: width)
                    PostImageCellRow(images: Array(images[2...3]), width: width)
                })
            } else if images.count == 5 {
                VStack(spacing: kSpace, content: {
                    PostImageCellRow(images: Array(images[0...1]), width: width)
                    PostImageCellRow(images: Array(images[2...4]), width: width)
                })
            } else if images.count == 6 {
                VStack(spacing: 6, content: {
                    PostImageCellRow(images: Array(images[0...2]), width: width)
                    PostImageCellRow(images: Array(images[3...5]), width: width)
                })
            }
        }
    }
}

// 每一行图片cell
struct PostImageCellRow: View {
    let images: [String]
    let width: CGFloat
    
    var body: some View {
        HStack(spacing: kSpace, content: {
            let temWidth = (self.width - kSpace * CGFloat(self.images.count - 1)) / CGFloat(self.images.count)
            ForEach(images, id: \.self) { image in
                loadImage(name: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: temWidth, height:temWidth)
                    .clipped()
            }
        })
    }
}

#Preview {
    let images = UserData.testData.recommendPostList.list[0].images
    let width = UIScreen.main.bounds.width
    return Group {
        PostImageCell(images: Array(images[0...0]), width: width)
//        PostImageCell(images: Array(images[0...1]), width: width)
//        PostImageCell(images: Array(images[0...2]), width: width)
//        PostImageCell(images: Array(images[0...3]), width: width)
//        PostImageCell(images: Array(images[0...4]), width: width)
//        PostImageCell(images: Array(images[0...5]), width: width)
    }
//    .previewLayout(.fixed(width: width, height: 300))
}
