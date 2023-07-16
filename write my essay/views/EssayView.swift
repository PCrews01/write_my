//
//  EssayView.swift
//  write my essay
//
//  Created by Paul Crews on 1/3/23.
//

import SwiftUI
import PDFKit

struct EssayView: View {
    @State var title:String
    @State var essay:String
    var body: some View {
        VStack{
            
            Text("\(title)").font(.largeTitle).fontWeight(.black)
            ScrollView {
                Text("\(essay)")
                
                
            }
            Spacer()
            ShareLink("Export", item: render())
        }
    }
    @MainActor
    func render() -> URL {
        let renderer = ImageRenderer(content: VStack{
            Text("\(title)").font(.largeTitle).fontWeight(.bold)
            Text("\(essay)")
            
        }.frame(width: 590.2, height: 1000.8).padding())
        let url = URL.documentsDirectory.appending(path: "\(title)_essay(wme).pdf")
        
        renderer.render{ size, context in
            var box = CGRect(x: 0, y: 0, width: 595.2, height:1056.0)
            
            guard let pdff = CGContext(url as CFURL, mediaBox: &box, nil) else {
                return
            }
            pdff.beginPDFPage(nil)
            
            context(pdff)
            
            pdff.endPDFPage()
            pdff.closePDF()
        }
        return url
    }
}

struct EssayView_Previews: PreviewProvider {
    static var previews: some View {
        EssayView(title: "Title", essay: "Essay")
    }
}
