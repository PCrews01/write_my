//
//  PocketTech.swift
//  write my essay
//
//  Created by Paul Crews on 1/5/23.
//

import SwiftUI

struct PocketTech: View {
    @State var issue:String = ""
    @State var resolution: String = ""
    @State var loading:Bool = false
    @State var resolution_list:Array<String> = []
    @State var steps_list: Dictionary<String,Array<String>> = [:]
    @State var show_steps:Array<Int> = []
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5){
            Text("Pocket Tech").font(.largeTitle).fontWeight(.black)
            Text("Pocket tech: The go-to app for tech help in the office")
            Text("Say goodbye to tech stress with Pocket tech")
            if resolution_list.count > 1{
                ZStack{
                    Color("Main")
                    if !loading{
                        VStack{
                            Text("Issue: \(issue)")
                            Text("Here are some fixes you can try.").font(.title3).fontWeight(.semibold).padding().shadow(radius: 3.0)
                        }
                    } else {
                        Text("Fetching Resolutions").fontWeight(.bold).font(.title).padding()
                    }
                }.frame(height: 100, alignment: .leading).cornerRadius(10)
                ScrollView{
                ForEach(resolution_list, id: \.self){ res in
                    let id = resolution_list.firstIndex(of: res)!
                    ZStack{
                        Color("Light")
                        if !loading{
                            LazyVStack(alignment: .leading, spacing: 5){
                                Spacer()
                                Text("\(res)").padding().foregroundColor(Color("Dark"))
                                if show_steps.contains(id + 1){
                                    HStack{
                                        Spacer()
                                        Text("Steps").fontWeight(.semibold)
                                        Spacer()
                                    }
                                    let these_steps =  steps_list["\(id + 1)"]
                                    if (these_steps != nil) {
                                        ZStack{
                                            Color("Danger")
                                            VStack(spacing: 8){
                                                ForEach(these_steps!, id: \.self){ stp in
                                                    Text(stp.replacingOccurrences(of: "step-", with: "")).frame(alignment: .leading).cornerRadius(8)
                                                }
                                            }.padding(.horizontal, 5)
                                        }
                                    }
                                }
                                Spacer()
                                HStack{
                                    Spacer()
                                    Button {
                                        if show_steps.contains( (id + 1) ) {
                                            show_steps.removeAll { id_of_steps in
                                                id_of_steps == id + 1
                                            }
                                        } else {
                                            if steps_list.keys.contains("\(id + 1)"){
                                                show_steps.append(id + 1)
                                                
                                            } else {
                                                getAssistance(category: "steps", id: id + 1)
                                                withAnimation(.easeInOut(duration: 0.8)) {
                                                    show_steps.append(id + 1)
                                                }
                                            }
                                        }
                                    } label: {
                                        Text(show_steps.contains(id + 1) ? "Hide Steps" : "How to do this?")
                                            .foregroundColor(show_steps.contains(id + 1) ? Color("Danger") : Color("Main"))
                                    }.padding()
                                    Spacer()
                                }
                            }.frame(minHeight: 200, alignment: .leading)
                        } else {
                            Text("Fetching Resolutions").fontWeight(.bold).font(.title)
                        }
                    }.cornerRadius(8).padding(.horizontal, 3.0)
                    }
                }
            } else {
            Form{
                TextField("What can I assist you with today", text: $issue)
                Button {
                    loading = true
                    getAssistance(category: "resolution", id: nil)
                } label: {
                    Text("Get assistance")
                }
            }}
        }
    }
    func expandSteps(step: Int){
        
    }
    
    func getAssistance(category: String, id: Int?) {
       loading = true
        let prompt = id != nil ? "can you show the steps it takes to complete \(resolution_list[id! - 1]). Summarized for someone using this for the first time or a 70 year old who doesn't use computers regularly. Instead of numbers can you use \"step hyphen number\"" : "can you show me 10 possible solutions for \(issue). Broken down for an elderly person with no technical skills. Instead of numbers can you use roman numeral to number the list of items"
        
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
                
                
                if let dt = json_output!.data(using: .unicode){
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
                            .replacingOccurrences(of: "\\U2018", with: "'")
                            .replacingOccurrences(of: "\\U2019", with: "'")
                            .replacingOccurrences(of: "\\U201c", with: " '")
                            .replacingOccurrences(of: "\\U201d", with: "' ")
                            .replacingOccurrences(of: "\\U2013", with: "-")
                            .replacingOccurrences(of: "\\U00a0", with: "")
                            .replacingOccurrences(of: " .", with: ".")
                            .replacingOccurrences(of: " ,", with: ",")
                            .replacingOccurrences(of: " ;", with: ";")
                            .replacingOccurrences(of: " !", with: "!")
                            .replacingOccurrences(of: " :", with: ":")
                            .dropFirst()
                            .dropLast()
                        )
                        var split_cap = stripped_caption.replacingOccurrences(of: "  \\n", with: "\n")
                        
                        for i in 0...10{
                            split_cap = split_cap.replacingOccurrences(of: "resolution-\(i)", with: "\n\(i) ")
                        }
                        if category == "resolution"{
                            resolution_list = Array(split_cap.components(separatedBy: "\n"))
                            resolution_list = resolution_list.filter({ el in
                                return el.count > 5
                            })
                            
                            print("Split \(resolution_list)")
                            print("Caption: \(split_cap)")
                        } else if category == "steps"{
                           var tmp_steps = Array(split_cap.components(separatedBy: "\n"))
                            tmp_steps = tmp_steps.filter({ el in
                                return el.count > 5
                            })
                            steps_list["\(id!)"] = tmp_steps
                        }
                    } catch {
                        print("there's been an error \(error)")
                    }
                }
                
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
       if resolution_list.count > 1{
            loading = false
        }
    }
}

struct PocketTech_Previews: PreviewProvider {
    static var previews: some View {
        PocketTech()
    }
}
