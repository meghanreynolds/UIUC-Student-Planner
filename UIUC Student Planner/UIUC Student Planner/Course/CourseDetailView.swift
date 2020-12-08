//
//  CourseDetailView.swift
//  UIUC Student Planner
//
//  Created by Meghan Reynolds on 11/14/20.
//
import SwiftUI
import UIKit

struct CourseDetailView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    var assignmentRequest: FetchRequest<Assignment>
    var assignments: FetchedResults<Assignment> { assignmentRequest.wrappedValue }
    
    @State public var selectedTabIndex: Int = 0
    @State public var courseColorIndex: Int = 0
    @State var course: Course
    
    var courseColor: Color{
        get{
            return Color.Material.palette[self.courseColorIndex]
        }
    }
    
    private var tabs = ["assignments", "settings"]
    private let backgroundColor: Color = Color.white
    
    public init(course: Course){
        self._course = State.init(initialValue: course)
        self.assignmentRequest = FetchRequest(
            entity: Assignment.entity(),
            sortDescriptors: [],
            predicate: NSPredicate(format: "course == %@", course),
            animation: .default
        )
    }
    
    public var body: some View{
        VStack{
            TextField("", text: .constant(self.course.name ?? ""))
                .font(Font(UIFont.systemFont(ofSize: 36, weight: .bold)))
                .foregroundColor(self.backgroundColor)
                .lineLimit(1)
                .padding([.leading, .trailing], 10)
                .padding(.top, 80)
                .padding(.bottom, 40)
                .multilineTextAlignment(.leading)
                .disabled(true)
            ZStack{
                GeometryReader { geometry in
                    RoundedRectangle(cornerRadius: 10.0)
                        .fill(self.backgroundColor)
                        .frame(width: self.tabWidth(from: geometry.size.width), height: 48, alignment: .leading)
                        .offset(x: self.xoff(from: geometry.size.width), y: -14)
                        .animation(.easeInOut)
                        .fixedSize(horizontal: false, vertical: true)
                }.fixedSize(horizontal: false, vertical: true)
                HStack(spacing: 0) {
                    ForEach(self.tabs.indices, id:\.self){ i in
                        Button(action: {
                            self.selectedTabIndex = i
                        }){
                            HStack {
                                Spacer()
                                if i == 0{
                                    Text(self.tabs[i] + " (\(self.assignments.count))")
                                        .font(Font(UIFont.systemFont(ofSize: 16, weight: .bold)))
                                }else{
                                    Text(self.tabs[i]).font(Font(UIFont.systemFont(ofSize: 16, weight: .bold)))
                                }
                                Spacer()
                            }
                        }
                        .padding(.vertical, 10)
                        .accentColor(i == self.selectedTabIndex ? self.courseColor : self.backgroundColor)
                        .background(Color.clear)
                    }
                }
            }
            if self.selectedTabIndex == 0{
                //Course Assignment Tab
                ScrollView{
                    LazyVStack{
                        ForEach(self.assignments.indices) { i in
                            NavigationLink(destination:AssignmentView(assignment: self.assignments[i])) {
                                AssignmentCardView(self.assignments[i], self.$courseColorIndex)
                                    .padding([.top, .bottom], 5.0)
                                    .padding([.leading, .trailing], 10.0)
                            }
                        }
                    }.padding(.top, 10.0)
                }
                .background(Color.white)
                .padding(.top, -10)
            }else{
                //Settings Tab
                CourseSettingView(course: self.$course, parentColorIndex: self.$courseColorIndex)
                    .background(Color.white)
                    .padding(.top, -10)
            }
        }
        .background(self.courseColor)
        .onAppear(){
            self.courseColorIndex = Int(self.course.colorIndex)
        }
        .navigationBarTitleDisplayMode(.large)
        .edgesIgnoringSafeArea(.top)
        Spacer()
    }
    
    
    private func tabWidth(from w: CGFloat) -> CGFloat{
        return w / CGFloat(self.tabs.count) - 10
    }
    
    private func xoff(from w: CGFloat) -> CGFloat {
        let o: CGFloat = 7.0 * (CGFloat(self.selectedTabIndex + 1))
        return self.tabWidth(from: w) * CGFloat(self.selectedTabIndex) + o
    }
    
}
