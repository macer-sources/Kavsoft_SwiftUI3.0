//
//  CalendarWeekView.swift
//  TaskMangement
//
//  Created by work on 7/2/23.
//

import SwiftUI

struct CalendarWeekView: View {
    @EnvironmentObject var viewModel:TaskViewModel
    @Namespace var animation
    
    var body: some View {
        HStack(spacing: 10) {
            
            ForEach(viewModel.currentWeek, id: \.self) { day in
                VStack(spacing: 10) {
                    Text(viewModel.extractDate(date: day, format: "dd"))
                        .font(.system(size: 15))
                        .fontWeight(.semibold)
                    
                    Text(viewModel.extractDate(date: day, format: "EEE"))
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                    Circle()
                        .fill(.white)
                        .frame(width: 8, height: 8)
                        .opacity(viewModel.isToday(date: day) ? 1 : 0)
                }
                .foregroundStyle(viewModel.isToday(date: day) ? .primary : .tertiary)
                .foregroundColor(viewModel.isToday(date: day) ? .white : .black)
                
                // MARK: Capsule Shape
                .frame(width: 45, height: 90)
                .background(
                    ZStack{
                        // MARK: method geometry effect
                        if viewModel.isToday(date: day) {
                            Capsule()
                                .fill(.black)
                                .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                        }
                        
                        
                        
                    }
                )
                .contentShape(Capsule())
                .onTapGesture {
                    // Updating Current Day
                    withAnimation {
                        viewModel.currentDay = day
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}
