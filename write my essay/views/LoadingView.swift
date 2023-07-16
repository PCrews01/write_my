//
//  LoadingView.swift
//  write my essay
//
//  Created by Paul Crews on 1/3/23.
//

import SwiftUI

struct LoadingView: View {
    @State var title: String
    @State var essay:String
    @State var topic:String
    @State var grade:String
    @State var essay_length:Double
    @State var essay_measurement:String
    @State var spell_check:Bool
    @State var grammar_check:Bool
    @State var essay_outline:Bool
    @State var prompt:String
    @State var started_generating_essay:Bool
    @State var error = ""
    @State var loading = false
    @State var drawing_width:Bool
    @State var max_amount:Int
    var body: some View {
        if essay.isEmpty {
            VStack{
                Text("Writing your essay on \(topic)").font(.largeTitle).fontWeight(.black)
                Spinner()
                    }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0){
                    generatePrompt()
                }
            }
        } else {
            
            EssayView(title: title, essay: essay)
        }
    }

    func startPrompt(){
        prompt = "Can you write a \(Int($essay_length.wrappedValue)) \($essay_measurement.wrappedValue) essay on \($topic.wrappedValue). Written for \($grade.wrappedValue)-grade."
        fetchRequest(queries: prompt)
    }
    func generatePrompt(){
        print("Starting")
        var ready = false
       if title.count > 2{
           if topic.count > 3{
               if topic.count > 3{
                   if grade.count > 3{
                       if essay_length != 0{
                           if essay_measurement.count > 3{
                               started_generating_essay = true
                               ready = true
                               if spell_check{
                                   if grammar_check{
                                       if essay_outline{
                                       }
                                   }
                               }
                           }else {
                               loading = false
                               error = "There's been and error. Check the essay measurement field."
                           }
                       }else {
                           loading = false
                           error = "There's been and error. Check the essay length field."
                       }
                   }else {
                       loading = false
                       error = "There's been and error. Check the grade field."
                   }
               }else {
                   loading = false
                   error = "There's been and error. Check the topic field."
               }
           }else {
               loading = false
               error = "There's been and error. Check the topic field."
           }
       } else {
           loading = false
           error = "There's been and error. Check the title field."
       }
        if ready{
            startPrompt()
        }
   }
    
    func fetchRequest(queries: String){
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
                        essay = String(st!
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
                    } catch {
                        print("there's been an error \(error)")
                    }
                }
                
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
        if essay != ""{
            loading = false
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(
            title: "",
            essay: "",
            topic: "",
            grade: "",
            essay_length: 0,
            essay_measurement: "",
            spell_check: false,
            grammar_check: false,
            essay_outline: false,
            prompt: "",
            started_generating_essay: false,
            error:"",
            loading:false,
            drawing_width:false,
            max_amount:10)
    }
}
