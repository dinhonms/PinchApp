//
//  ContentView.swift
//  PinchApp
//
//  Created by Nonato Sousa on 18/07/23.
//

import SwiftUI
import UIKit

struct ContentView: View {
    //MARK: - PROPERTIES
    @State var isAnimating = false
    @State var imageScale: CGFloat = 1
    @State var imageOffset: CGSize = CGSize()
    @State var lastOffset: CGSize = CGSize()
    @State private var isImageChooserOpen = false
    @State private var chosenMagazine = "magazine-front-cover"
    @State private var frontMagazine = "magazine-front-cover"
    @State private var backMagazine = "magazine-back-cover"
    
    var maxScale: CGFloat = 5
    var minScale: CGFloat = 1
    
    func resetImageState(){
        return withAnimation(.spring()){
            setScale(newScale: minScale)
            imageOffset = .zero
            lastOffset = imageOffset
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
    
    func setScale(newScale: CGFloat){
        imageScale = newScale
    }
    
    func setChosenMagazine(chosenMagazine: String){
        self.chosenMagazine = chosenMagazine
    }
    
    func createThumbnail() async -> UIImage{
        let image = UIImage(contentsOfFile: frontMagazine)
        
        let thumbnail = image?.preparingThumbnail(of: CGSize(width: 256, height: 256)) ?? UIImage()
        
        return thumbnail
    }
    
    //MARK: - FUNCTION
    
    //MARK: - CONTENT
    var body: some View {
        
        NavigationView{
            ZStack{
                Color.clear
                
                //MARK: - PAGE IMAGE
                Image(chosenMagazine)
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
                                setScale(newScale: maxScale)
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
                                    imageOffset = CGSize(width: value.translation.width + lastOffset.width, height: value.translation.height + lastOffset.height)
                                }
                            }
                        
                            .onEnded{_ in
                                if imageScale <= 1{
                                    resetImageState()
                                }
                                
                                lastOffset = imageOffset
                            }
                    )
                //MARK: - Magnification gesture
                    .gesture(
                        MagnificationGesture()
                            .onChanged{ value in
                                withAnimation(.linear(duration: 1)){
                                    if imageScale >= 1 && imageScale <= 5 {
                                        setScale(newScale: value)
                                    } else if imageScale > 5 {
                                        setScale(newScale: 5)
                                    }
                                }
                            }
                            .onEnded{_ in
                                if imageScale > 5 {
                                    setScale(newScale: 5)
                                } else if imageScale <= 1 {
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
                InfoPanelView(scale: $imageScale, offset: $imageOffset)
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
                    .padding(.horizontal, 22.0)
                    .padding(.vertical, 8.0)
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .opacity(isAnimating ? 1 : 0)
                }
                    .padding(.bottom, 30)
                ,alignment: .bottom
            )
            //MARK: - CHOOSE MAGAZINE
            .overlay(
                HStack(spacing: 10.0) {
                    Image(systemName: isImageChooserOpen ? "chevron.compact.right" : "chevron.compact.left")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.secondary)
                        .frame(height: 50)
                        .onTapGesture(perform:  {
                            withAnimation(.easeOut){
                                isImageChooserOpen.toggle()
                            }
                        })
                    
                    Image("thumb-magazine-front-cover")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                        .opacity(isImageChooserOpen ? 1 : 0)
                        .animation(.easeOut(duration: 0.5), value: isImageChooserOpen)
                        .onTapGesture(perform: {
                            withAnimation(.easeOut){
                                setChosenMagazine(chosenMagazine: frontMagazine)
                            }
                        })
                    
                    Image("thumb-magazine-back-cover")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                        .opacity(isImageChooserOpen ? 1 : 0)
                        .animation(.easeOut(duration: 0.5), value: isImageChooserOpen)
                        .onTapGesture(perform: {
                            withAnimation(.easeOut){
                                setChosenMagazine(chosenMagazine: backMagazine)
                            }
                        })
                    
                    Spacer()
                }
                    .padding(.all, 10.0)
                    .frame(width: UIScreen.main.bounds.width / 2.2, height: 100)
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .opacity(isAnimating ? 1 : 0)
                    .padding(.top, UIScreen.main.bounds.height / 12)
                    .offset(x: isImageChooserOpen ? 20 : UIScreen.main.bounds.width - 269)
                
                
                ,alignment: .topTrailing
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
