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
    
    var maxScale: CGFloat = 5
    var minScale: CGFloat = 1
    
    func resetImageState(){
        return withAnimation(.spring()){
            imageScale = minScale
            imageOffset = .zero
        }
    }
    
    func scaleUp(){
        return withAnimation(.spring()){
            if imageScale < maxScale{
                imageScale += 1
            }
            
            if imageScale > maxScale{
                imageScale = maxScale
            }
        }
    }
    
    func scaleDown(){
        return withAnimation(.spring()){
            if imageScale > minScale{
                imageScale -= 1
            }
            
            if imageScale < minScale{
                imageScale = minScale
            }
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
                            
                            if imageScale == minScale{
                                imageScale = maxScale
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
            //MARK: - CONTROLS
             .overlay (
                 Group{
                     HStack{
                         Button {
                             scaleDown()
                         } label: {
                             ControlImageView(iconName: "minus.magnifyingglass")
                         }
                         
                         Button {
                             resetImageState()
                         } label: {
                             ControlImageView(iconName: "arrow.up.left.and.down.right.magnifyingglass")
                         }
                         
                         Button {
                             scaleUp()
                         } label: {
                             ControlImageView(iconName: "plus.magnifyingglass")
                         }
                     }
                     .padding(15)
                     .cornerRadius(12)
                     .opacity(isAnimating ? 1 : 0)
                     .backgroundStyle(.ultraThinMaterial)
                 }
                 .padding(.bottom, 30)
                 ,alignment: .bottom
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
