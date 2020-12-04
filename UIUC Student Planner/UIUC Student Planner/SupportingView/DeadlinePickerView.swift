//
//  DeadlineView.swift
//  UIUC Student Planner
//
//  Created by Jeffery Wang on 10/20/20.
//

import SwiftUI


struct DeadlinePickerView: View{
    
    @Binding var selectedDate: Date
    
    @State var showSelectDateDetail = false
    @State var showSelectTimeDetail = false
    
    var body: some View{
        Section(){
            HStack{
                Image.init(systemName: "calendar")
                    .font(.system(size: 18))
                    .foregroundColor(.white).padding(5)
                    .background(RoundedRectangle(cornerRadius: 7)
                        .aspectRatio(1, contentMode: .fill)
                        .foregroundColor(.red))
                Text("Date")
                    .padding(.leading, 5)
                    .font(.system(size: 18))
                Spacer()
                Text("\(self.selectedDate.toString(dateStyle: .medium, timeStyle: .none))")
                    .padding(.vertical, 10)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                self.showSelectDateDetail.toggle()
                self.showSelectTimeDetail = false
            }
            if self.showSelectDateDetail{
                DatePicker.init(selection: self.$selectedDate, displayedComponents: .date){
                    
                }
                .datePickerStyle(GraphicalDatePickerStyle.init())
            }
            
            HStack{
                Image.init(systemName: "clock.fill")
                    .font(.system(size: 18))
                    .foregroundColor(.white).padding(5)
                    .background(RoundedRectangle(cornerRadius: 7)
                        .aspectRatio(1, contentMode: .fill)
                        .foregroundColor(.blue))
                Text("Time")
                    .padding(.leading, 5)
                    .font(.system(size: 18))
                Spacer()
                Text("\(self.selectedDate.toString(dateStyle: .none, timeStyle: .short))")
                .padding(.vertical, 10)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                self.showSelectDateDetail = false
                self.showSelectTimeDetail.toggle()
            }
            if self.showSelectTimeDetail{
                DatePicker.init(selection: self.$selectedDate, displayedComponents: .hourAndMinute){
                    
                }
                .datePickerStyle(GraphicalDatePickerStyle.init())
            }
        }
    }
}
