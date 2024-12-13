//
//  ContentView.swift
//  SUMaraphonTask5
//
//  Created by A on 12.12.2024.
//

/* ТЗ
 На экране 4 цветных прямоугольника. Сверху перетаскиваем квадрат.

 - Цвета фона [Color.white, .pink, .yellow, .black].
 - На темных цветах квадрат белый, на светлых - черный.
 - Нельзя использовать mask. Жест не прерывается между цветами.
 */

import SwiftUI


struct ContentView: View {
    
    private let bgColors = [Color.white, .pink, .yellow, .black]
    
    var body: some View {
        
        ZStack {
            
            VStack(spacing: 0) {
                
                ForEach(bgColors.indices, id: \.self) { index in
                  
                    Rectangle()
                        .fill(bgColors[index])
               
                }
                .frame(maxHeight: .infinity)
                
            }//VStack
            
            MovingSquare()
        }//:ZStack
        .ignoresSafeArea()
        
    }
}

struct MovingSquare: View {
    
    @State private var position = CGPoint.zero // Позиция квадрата
    
    // Параметры квадрата
    private let squareWidth: CGFloat = 100
    private let squareCornerRadius: CGFloat = 10
    
    var body: some View {
        
        GeometryReader { geometry in
            
            let safeAreaTopInset = geometry.safeAreaInsets.top

            RoundedRectangle(cornerRadius: squareCornerRadius)
                .colorEffect(width: squareWidth, cornerRadius: squareCornerRadius)
                .position(position)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            position = value.location
                        }
                )
                .onAppear {
                    
                    // Начальное положение Квадрата
                    position = CGPoint(x: geometry.size.width / 2, y: squareWidth + safeAreaTopInset + 10)
               
                }
        }
    }
}

extension View {
    
    func colorEffect(width: CGFloat, cornerRadius: CGFloat) -> some View {
        self
            .foregroundColor(.white)
            .frame(width: width, height: width)
            .blendMode(.exclusion) // инверсия
            // Серия оверлеев для правильного отображения фона (белый/черный), работает только в таком порядке поверх .hue
            .overlay(RoundedRectangle(cornerRadius: cornerRadius).blendMode(.hue))
            .overlay(RoundedRectangle(cornerRadius: cornerRadius).foregroundColor(.white).blendMode(.overlay))
            .overlay(RoundedRectangle(cornerRadius: cornerRadius).foregroundColor(.black).blendMode(.overlay))
    }
    
}


#Preview {
    ContentView()
}
