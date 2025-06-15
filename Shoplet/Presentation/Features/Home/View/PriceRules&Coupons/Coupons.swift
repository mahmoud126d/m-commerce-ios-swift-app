//
//  Coupons.swift
//  Shoplet
//
//  Created by Macos on 09/06/2025.
//

import SwiftUI

struct Coupons: View {
    var PriceRuleId : Int
    @StateObject var viewModel = CouponViewModel()
    var backgroundColor: Color = .blue
    var body: some View {
        ScrollView(showsIndicators: false){
            ForEach(viewModel.coupons, id: \.id){
                item in
                CouponCard(coupon: item.code)
                    .onTapGesture {
                        UIPasteboard.general.string = item.code
                        UserDefaultManager.shared.priceRuleId = viewModel.priceRuleId
                    }
            }
                
        }
       .onAppear {
            viewModel.getCoupons(id: PriceRuleId)
        }
    }
}

struct CouponCard: View {
    let coupon: String

    var body: some View {
        ZStack {
            CardShape()
                .fill(Color.primaryColor.opacity(0.4))
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                .padding()
                .frame(height: 120)

            HStack(spacing: 16) {
                Image(.sale2)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .padding(.leading, 8)

                VStack{
                    Text(coupon)
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("Click to copy")
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                }

                Spacer()
            }
            .padding(.vertical)
        }
        .frame(height: 150)
        .padding(.horizontal)
    }
}



struct CardShape: Shape {
    var cornerRadius: CGFloat = 24
        var notchRadius: CGFloat = 18

        func path(in rect: CGRect) -> Path {
            let centerY = rect.midY
            let notchCenterX = rect.maxX - 1

            var path = Path()

            path.move(to: CGPoint(x: cornerRadius, y: 0))

            path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: 0))
            path.addArc(
                center: CGPoint(x: rect.maxX - cornerRadius, y: cornerRadius),
                radius: cornerRadius,
                startAngle: .degrees(-90),
                endAngle: .degrees(0),
                clockwise: false
            )
            path.addLine(to: CGPoint(x: rect.maxX, y: centerY - notchRadius))
            path.addArc(
                center: CGPoint(x: notchCenterX, y: centerY),
                radius: notchRadius,
                startAngle: .degrees(-90),
                endAngle: .degrees(90),
                clockwise: true)
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerRadius))
            path.addArc(
                center: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY - cornerRadius),
                radius: cornerRadius,
                startAngle: .degrees(0),
                endAngle: .degrees(90),
                clockwise: false)
            path.addLine(to: CGPoint(x: cornerRadius, y: rect.maxY))
                    
                    path.addArc(
                        center: CGPoint(x: cornerRadius, y: rect.maxY - cornerRadius),
                        radius: cornerRadius,
                        startAngle: .degrees(90),
                        endAngle: .degrees(180),
                        clockwise: false)
                path.addLine(to: CGPoint(x: 0, y: cornerRadius))
                path.addArc(
                        center: CGPoint(x: cornerRadius, y: cornerRadius),
                        radius: cornerRadius,
                        startAngle: .degrees(180),
                        endAngle: .degrees(270),
                        clockwise: false)
            return path
        }
    }


#Preview {
    Coupons(PriceRuleId : 1001)
}
