//
//  Spinner.swift
//  write my essay
//
//  Created by Paul Crews on 1/3/23.
//

import Foundation
import SwiftUI


struct Spinner: View{
    let rotation_time: Double = 1.75
    let full_rotation: Angle = .degrees(360)
    static let initial_degree: Angle = .degrees(270)
    
    @State var spinner_start: CGFloat = 0.0
    @State var spinner_end_s1: CGFloat = 0.03
    @State var rotation_degrees_s1 = initial_degree
    
    @State var spinner_end_s2: CGFloat = 0.05
    @State var rotation_degrees_s2 = initial_degree
    
    @State var spinner_end_s3: CGFloat = 0.07
    @State var rotation_degrees_s3 = initial_degree
    
    @State var spinner_end_s4: CGFloat = 0.09
    @State var rotation_degrees_s4 = initial_degree
    
    var body: some View {
        ZStack{
            SpinnerCircle(
                start: spinner_start,
                end: spinner_end_s4,
                rotation: rotation_degrees_s4,
                color: Color("Danger")
            )
            SpinnerCircle(
                start: spinner_start,
                end: spinner_end_s3,
                rotation: rotation_degrees_s3,
                color: Color("Success")
            )
            SpinnerCircle(
                start: spinner_start,
                end: spinner_end_s2,
                rotation: rotation_degrees_s2,
                color: Color("Secondary")
            )
            SpinnerCircle(
                start: spinner_start,
                end: spinner_end_s1,
                rotation: rotation_degrees_s1,
                color: Color("Main")
            )
        }.frame(width: 200, height: 200)
            .onAppear(){
                Timer.scheduledTimer(withTimeInterval: rotation_time, repeats: true) { (mainTimer) in
                    
                    self.animateSpinner()
                }
            }
    }
    
    func animateSpinner(with timeInterval: Double, completion: @escaping(() -> Void)){
        Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false){
            _ in
            withAnimation(Animation.easeInOut(duration: rotation_time)){
                completion()
            }
        }
    }
    func animateSpinner(){
        animateSpinner(with: rotation_time) {
            self.spinner_end_s1 = 1.0
            self.spinner_end_s4 = 1.0
        }
        animateSpinner(with: (rotation_time * 2) - 0.025) {
            self.rotation_degrees_s1 += full_rotation
            self.spinner_end_s4 = 0.08
        }
        animateSpinner(with: (rotation_time * 2)) {
            self.spinner_end_s1 = 0.03
            self.spinner_end_s4 = 0.03
        }
        animateSpinner(with: (rotation_time * 2) + 0.05) {
            self.rotation_degrees_s2 += full_rotation
        }
        animateSpinner(with: (rotation_time * 2) + 0.075) {
            self.rotation_degrees_s3 += full_rotation
        }
        animateSpinner(with: (rotation_time * 2) + 0.1) {
            self.rotation_degrees_s4 += full_rotation
        }
    }
}
struct SpinnerCircle: View{
    var start: CGFloat
    var end: CGFloat
    var rotation: Angle
    var color: Color
    var body: some View{
        Circle()
            .trim(from: start, to: end)
            .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
            .fill(color)
            .rotationEffect(rotation)
    }
}
