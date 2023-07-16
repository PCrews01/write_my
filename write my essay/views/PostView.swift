//
//  PostView.swift
//  write my essay
//
//  Created by Paul Crews on 1/4/23.
//

import SwiftUI

struct PostView: View {
    @State var my_post: Post
    var body: some View {
        GeometryReader{
            geo in
            VStack{
                if my_post.post_caption.count > 10 {
                    my_post.post_image.resizable().scaledToFit().frame(width: geo.size.width - 20, height: geo.size.height / 3, alignment: .center).aspectRatio(contentMode: .fill)
                    ScrollView{
                    ZStack{
                        Color("Dark")
                        Text(my_post.post_caption.replacingOccurrences(of: "\\U00a0", with: "")).padding()
                    }
                }
            }
                Spacer()
                Button {
                    print("Done")
                } label: {
                    HStack{
                        Spacer()
                        Image(systemName: "square.and.arrow.up").resizable().scaledToFit().frame(width: 20, height: 20)
                        Text("Publish Post")
                        Spacer()
                    }
                }

            }
        }
    }
}
