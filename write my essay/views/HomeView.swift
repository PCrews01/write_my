//
//  HomeView.swift
//  write my essay
//
//  Created by Paul Crews on 1/3/23.
//

import SwiftUI
import PhotosUI

struct HomeView: View {
    @State private var selected_item: PhotosPickerItem? = nil
    @State private var selected_image_data: Data? = nil
    
    @State var post_title:String = ""
    @State var post_type: String = ""
    @State var post_topic: String = ""
    @State var post_hashtags:Double = 9.0
    @State var loading = false
    @State var my_post = Post(post_image: Image("Logo"), post_topic: "", post_caption: "")
    @State var post_caption = ""
    @State var temp_img: UIImage = UIImage()
    
    var body: some View {
        ScrollView{
            VStack {
            Text("Instagram Post Writer")
            if post_caption == "" {
                ZStack{
                    Color("Success")
                    VStack{
                        HStack{
                            Image(systemName: "lightbulb.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                            Text("Tips").fontWeight(.bold).font(.title)
                        }.padding()
                        VStack(alignment: .leading){
                            Text("Character limits:").fontWeight(.semibold).padding(.horizontal)
                            Text("Instgram hs a caption limit of 2,200 characters; and a limit of 30 hastags in a post.").font(.caption).padding(.horizontal)
                            Text("Experts say although insntagram allows the equivellant of 4 pages; you shold try to cap your post at 150 charaters - ideally 125.").font(.caption).padding(.horizontal)
                        }
                        Spacer()
                    }
                }.frame(maxWidth: 300, maxHeight: 250).cornerRadius(10.0)
                VStack{
                    Form{
            PhotosPicker(
                selection: $selected_item,
                matching: .images,
                photoLibrary: .shared()){
                    HStack{
                        Image(systemName: "photo")
                        Text("Select a photo")
                    }.frame(alignment: .center)
                }.onChange(of: selected_item){ new_item in
                    Task {
                        if let data = try? await new_item?.loadTransferable(type: Data.self){
                            selected_image_data = data
                            temp_img = UIImage(data: data)!
                            my_post.post_image = Image(uiImage: UIImage(data: data)!)
                        }
                    }
                }
            if let selected_image_data, let ui_image = UIImage(data: selected_image_data){
                Image(uiImage: ui_image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 400, maxHeight: 400)
            }
                Section{
                    TextField("Topic/Description", text: $post_topic)
                    Picker("Post Type", selection: $post_type) {
                        Text("Select").tag("")
                        Text("Boost Engagement").tag("boost engagement")
                        Text("Business Promotion").tag("promote company")
                        Text("Education").tag("educate")
                        Text("Entertainment").tag("entertain")
                        Text("Event Promotion").tag("promote an event")
                        Text("Grow Followers").tag("help grow followers")
                        Text("News").tag("break news")
                        Text("Media Promotion").tag("promote media")
                        Text("Sales").tag("boost sales")
                    }
                    HStack{
                        Text("\(Int(post_hashtags)) hashtags")
                        Slider(value: $post_hashtags, in: 0...20, step: 3)
                    }
                }
            }
                    Spacer()
                    Button {
                        generatePost()
                    } label: {
                        Text("Generate Post")
                    }.foregroundColor(Color("Success"))

                    
                }
            } else {
                PostView(my_post: my_post)
            }
        }}
    }
   func generatePost() {
       let prompt =  "can you write a 150 word exciting instagram post about \(post_topic) to help \(post_type); with \(Int(post_hashtags)) hashtags"
       print("PROMPT: \(prompt)")
        let url = URL(string: "https://api.openai.com/v1/completions")
        let bearer = "Bearer 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"
        let query: [String:Any] = [
            "model": "text-davinci-003",
            "prompt": prompt,
            "temperature": 0.1,
            "max_tokens": 3000,
            "n": 1,
            "frequency_penalty": 2.0
            ]
//        let query_data = query.map{"\($0)=\($1)"}.joined(separator: "&").data(using: .utf8)!
        let semaphore = DispatchSemaphore(value: 0)
        
        let tt = try? JSONSerialization.data(withJSONObject: query)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(bearer, forHTTPHeaderField: "Authorization")
        request.httpBody = tt
        
        let task = URLSession.shared.dataTask(with: request){
            data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            if type(of: data) == Data.self {
                let json_data = try? JSONSerialization.jsonObject(with: data)
                let json_else = try? JSONSerialization.data(withJSONObject: json_data!, options: [.prettyPrinted])
                let json_output = String(data:json_else!, encoding: String.Encoding.utf8)
                
                
                if let dt = json_output!.data(using: .utf8){
                    do {
                        let oput = try JSONSerialization.jsonObject(with: dt, options: .mutableContainers) as? [String:AnyObject]
                        
                        let res = oput!["choices"]!.value(forKey: "text").flatMap { para in
                            return para
                        }
                        let res_out = String("\(res!)")
                        let utf = res_out.data(using: .unicode)
                        let st = String(data: utf!, encoding: .unicode)
                        let stripped_caption = String(st!
                            .replacingOccurrences(of: "\"\\n ", with: "\n")
                            .replacingOccurrences(of: "\\n", with: "\n")
                            .replacingOccurrences(of: "(\n", with: "")
                            .replacingOccurrences(of: "\n)", with: "")
                            .replacingOccurrences(of: "\\\"", with: "\"")
                            .replacingOccurrences(of: "\"\n", with: "")
                            .replacingOccurrences(of: "\\t", with: "")
                            .replacingOccurrences(of: "\\U2019", with: "'")
                            .replacingOccurrences(of: "\\U201c", with: " '")
                            .replacingOccurrences(of: "\\U201d", with: "' ")
                            .replacingOccurrences(of: "\\U2013", with: "-")
                            .replacingOccurrences(of: " .", with: ".")
                            .replacingOccurrences(of: " ,", with: ",")
                            .replacingOccurrences(of: " ;", with: ";")
                            .replacingOccurrences(of: " !", with: "!")
                            .replacingOccurrences(of: " :", with: ":")
                            .dropFirst()
                            .dropLast()
                        )
                        my_post.post_caption = "my_ig_handle: \(stripped_caption)"
                        post_caption = my_post.post_caption
                        print("Caption: \(my_post.post_caption)")
                    } catch {
                        print("there's been an error \(error)")
                    }
                }
                
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
       if my_post.post_caption != ""{
            loading = false
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
