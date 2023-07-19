//
//  ContentView.swift
//  PinchApp
//
//  Created by Nonato Sousa on 18/07/23.
//

import SwiftUI

struct ContentView: View {
    //MARK: - PROPERTIES
    @State var isAnimating = false
    @State var imageScale: CGFloat = 1
    
    //MARK: - FUNCTION
    
    //MARK: - CONTENT
    var body: some View {
        
        NavigationView{
            ZStack{
                
                //MARK: - PAGE IMAGE
                Image("magazine-front-cover")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding()
                    .shadow(color: .black, radius: 10, x: 2, y: 2)
                    .opacity(isAnimating ? 1 : 0)
                    .scaleEffect(imageScale)
                    .onTapGesture(count: 2, perform: {
                        withAnimation(.spring()) {
                            
                            if imageScale == 1{
                                imageScale = 5
                            }
                            else {
                                imageScale = 1
                            }
                        }
                    })
                
            }
            .navigationTitle("Pinch & Zoom")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                withAnimation(.linear(duration: 1)){
                    isAnimating = true
                }
            }
            
        }//: NAVIGATION
        .navigationViewStyle(.columns)
    }
}

//MARK: - PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
