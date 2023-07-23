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
    @State var imageOffset: CGSize = CGSize()
    
    func resetImageState(){
        return withAnimation(.spring()){
            imageScale = 1
            imageOffset = .zero
        }
    }
    
    //MARK: - FUNCTION
    
    //MARK: - CONTENT
    var body: some View {
        
        NavigationView{
            ZStack{
                Color.clear
                
                //MARK: - PAGE IMAGE
                Image("magazine-front-cover")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding()
                    .shadow(color: .black, radius: 10, x: 2, y: 2)
                    .opacity(isAnimating ? 1 : 0)
                    .scaleEffect(imageScale)
                    .offset(imageOffset)
                    .onTapGesture(count: 2, perform: {
                        withAnimation(.spring()) {
                            
                            if imageScale == 1{
                                imageScale = 5
                            }
                            else {
                                resetImageState()
                            }
                        }
                    })
                
                //MARK: - DRAG GESTURE
                    .gesture(
                        DragGesture()
                            .onChanged{ value in
                                withAnimation(.linear(duration: 1)){
                                    imageOffset = value.translation
                                }
                            }
                        
                            .onEnded{_ in
                                if imageScale <= 1{
                                    resetImageState()
                                }
                            }
                    )
                
            }
            .navigationTitle("Pinch & Zoom")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                withAnimation(.linear(duration: 1)){
                    isAnimating = true
                }
            }
            //MARK: - INFO PANEL
             .overlay(
                InfoPanelView(scale: imageScale, offset: imageOffset)
                    .padding(.horizontal)
                    .padding(.top, 30)
                , alignment: .top
            )
            
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
