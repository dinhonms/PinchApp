//
//  InfoPanelView.swift
//  PinchApp
//
//  Created by Raimundo N M Sousa on 23/07/23.
//

import SwiftUI

struct InfoPanelView: View {
    
    @Binding var scale: CGFloat
    @Binding var offset: CGSize
    
    @State private var isInfoPanelVisible = false
    
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
                Text(String(format: "%.2f", scale))
                Spacer()
                Image(systemName: "arrow.left.and.right")
                Text(String(format: "%.2f", offset.width))
                Spacer()
                Image(systemName: "arrow.up.and.down")
                Text(String(format: "%.2f", offset.height))
                Spacer()
            }
            .font(.footnote)
            .padding(8)
            .background(.ultraThinMaterial)
            .cornerRadius(8)
            .frame(maxWidth: 300)
            .opacity(isInfoPanelVisible ? 1 : 0)
            
            Spacer()
        }
    }
}

struct InfoPanelView_Previews: PreviewProvider {
    static var previews: some View {
        InfoPanelView(scale: .constant(0.5), offset: .constant(.zero))
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
