
import SwiftUI
import PDFKit



struct MyResult: Codable{
    let key: String
}
struct ContentView: View {
    var grade_levels = [
        "Seventh",
        "Eighth",
        "Ninth",
        "Tenth",
        "Eleventh",
        "Twelth",
        "College Freshman",
        "College Sophmore",
        "College Junior",
        "College Senior"
    ]
    @State var title: String = ""
    @State var essay:String = ""
    @State var topic:String = ""
    @State var grade:String = ""
    @State var essay_length:Double = 0
    @State var essay_measurement:String = "page"
    @State var spell_check:Bool = true
    @State var grammar_check:Bool = true
    @State var essay_outline:Bool = false
    @State var prompt:String = ""
    @State var started_generating_essay:Bool = false
    @State var error = ""
    @State var loading = false
    @State var drawing_width = false
    @State var max_amount = 10
    
    @State private var showing_exporter = false
    
    var body: some View {
//        HomeView()
        PocketTech()
//        VStack {
//            Image("Logo")
//                .imageScale(.large)
//                .foregroundColor(.accentColor)
//            if error != "" {
//                HStack{
//                    Text("Error: \(error)").foregroundColor(.red)
//                }.foregroundColor(Color.red)
//            }
//            Spacer()
//            if !loading{
//                if prompt == ""{
//                    VStack{
//                    Form{
//                        Section(String("Essay details")) {
//                            TextField(String("Title"), text: $title).keyboardType(.alphabet)
//                            TextField(String("Topic"), text: $topic)
//                            Picker("Grade Level", selection: $grade){
//                                Text("Select").tag("")
//                                ForEach(grade_levels, id:\.self){grade in
//                                    Text(grade).tag("\(grade)")
//                                }
//                            }
//                            Picker("Essay measurement", selection: $essay_measurement){
//                                Text("Select").tag("")
//                                Text("Pages").tag("page")
//                                Text("Paragraphs").tag("paragraph")
//                                Text("Words").tag("word")
//                            }.onChange(of: essay_measurement) { new_val in
//                                setMaxAmount()
//                            }
//                            if essay_measurement != ""{
//                                HStack{
//                                    essay_length < 1.0 ?
//                                    Text("How many \(essay_measurement)s") :
//                                    Text("\(Int(essay_length)) \(essay_measurement)s")
//                                    Slider(value: $essay_length, in: 0...Double(max_amount), step: essay_measurement == "page" || essay_measurement == "paragraph" ? 1 : 5)
//                                }
//                            }
//
//                            Toggle(isOn: $spell_check) {
//                                Text("Spell check")
//                            }
//                            Toggle(isOn: $grammar_check) {
//                                Text("Grammar check")
//                            }
//                        }
//
//                    }.onAppear {
//                        setMaxAmount()
//                    }
//                    Spacer()
//                    Button {
//                        loading = true
//                    } label: {
//                        Text(prompt == "" ? "Write my essay" : loading ? "Writing essay" : "Go back")
//                    }
//                }}
//
//            } else {
//                LoadingView(
//                    title: title,
//                    essay: essay,
//                    topic: topic,
//                    grade: grade,
//                    essay_length: essay_length,
//                    essay_measurement: essay_measurement,
//                    spell_check: spell_check,
//                    grammar_check: grammar_check,
//                    essay_outline: essay_outline,
//                    prompt: prompt,
//                    started_generating_essay: started_generating_essay,
//                    drawing_width: drawing_width,
//                    max_amount: max_amount)
//            }
//        }
    }
    func delayReturn() async{
        try? await Task.sleep(for: .seconds(3))
    }
    func setMaxAmount(){
        max_amount = essay_measurement == "paragraph" ? 10 : essay_measurement == "word" ? 1000 : essay_measurement == "page" ? 25 : essay_measurement == ""  ? 10 : 0
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            title: "",
            essay: "",
            topic: "",
            grade: "",
            essay_length: 0,
            essay_measurement: "",
            spell_check: false,
            grammar_check: false,
            essay_outline: false,
            prompt: "")
    }
}
