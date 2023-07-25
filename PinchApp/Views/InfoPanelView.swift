//
//  InfoPanelView.swift
//  PinchApp
//
//  Created by Raimundo N M Sousa on 23/07/23.
//

import SwiftUI

struct InfoPanelView: View {
    
    @State var scale: CGFloat = 1.0
    @State var offset: CGSize = .zero
    @State var isInfoPanelVisible = false
    
    var body: some View {
        
        HStack{
            Image(systemName: "circle.circle")
                .symbolRenderingMode(.hierarchical)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
                .onLongPressGesture(minimumDuration: 1) {
                    withAnimation(.easeOut){
                        isInfoPanelVisible.toggle()
                    }
                }
            Spacer()
            
            HStack(spacing: 2){
                Image(systemName: "arrow.up.left.and.arrow.down.right")
                Text("\(scale)")
                Spacer()
                Image(systemName: "arrow.left.and.right")
                Text("\(offset.width)")
                Spacer()
                Image(systemName: "arrow.up.and.down")
                Text("\(offset.height)")
                Spacer()
            }
            .font(.footnote)
            .padding(8)
            .background(.ultraThinMaterial)
            .cornerRadius(8)
            .frame(maxWidth: 420)
            .opacity(isInfoPanelVisible ? 1 : 0)
            
            Spacer()
        }
    }
}

struct InfoPanelView_Previews: PreviewProvider {
    static var previews: some View {
        InfoPanelView(scale: 1, offset: .zero)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
