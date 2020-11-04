//
//  TagPickerView.swift
//  UIUC Student Planner
//
//  Created by Jeffery Wang on 10/25/20.
//

import SwiftUI
import CoreData

struct TagView: View {
    
    public let addable: Bool
    public var cells: Array<String> = []
    public var selectedTags: Array<String> = []
    public var tagFont = UIFont.systemFont(ofSize: 13)
    public var tagPadding: CGFloat = 10.0
    //[2, 1, 3] means 3 rows to display; first row has 2 elements, second row has 1 element, and third row has 3 elements.
    private var cellCountInRow = Array<Int>()
    private var context = PersistenceController.shared.container.viewContext
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Tag.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Tag.name, ascending: true)])
    var tags: FetchedResults<Tag>
    
    init(addable: Bool = false, selectedTags: Array<String> = []){
        self.addable = addable
        
        //basic init for TagView
        self.selectedTags = selectedTags
        for tag in self.tags{
            if let name = tag.name{
                self.cells.append(name)
            }
        }
        self.cells.insert("TAG:", at: 0)  //the TAG: text at the beginning of the view
        if self.addable{
            self.cells.append("+")  //the plus sign for adding a tag
        }
        self.countElementInRow(width: UIScreen.main.bounds.width - 145)  //temporary solution. Padding only works if view is in a form.
    }
    
    var body: some View{
        ScrollView(.vertical){
            VStack(alignment: .leading, spacing: 0){
                ForEach(0..<self.cellCountInRow.count){rowIndex in
                    HStack{
                        ForEach(0..<self.cellCountInRow[rowIndex]){ itemIndex in
                            self.tagViewCell(for: (rowIndex, itemIndex))
                        }.padding(EdgeInsets.init(top: 3, leading: 0, bottom: 3, trailing: 0))  //padding between cells
                    }
                }
            }
        }
    }
    
    private func tagViewCell(for indexPath: (Int, Int)) -> some View{
        if indexPath == (0, 0){
            let tv = Text("TAG:")
                .font(.system(size: 12, weight: .bold, design: .default))
                .fixedSize()
                .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))  //cell padding
                .foregroundColor(.black)
            return AnyView(tv)
        }
        if self.getTagIndex(from: indexPath) == self.cells.count - 1 && self.addable{
            let tv = Button("+"){
                self.saveNewTag(name: "test")
            }
                .font(.system(size: 14, weight: .heavy, design: .default))
                .fixedSize()
                .padding(EdgeInsets(top: 4, leading: self.tagPadding, bottom: 4, trailing: self.tagPadding))  //cell padding
                .foregroundColor(.black)
                .background(Color(UIColor.systemGroupedBackground).clipShape(RoundedRectangle(cornerRadius: 15)))
            return AnyView(tv)
        }
        let tv = Text(self.cells[self.getTagIndex(from: indexPath)])
            .font(.system(size: 13))
            .fixedSize()
            .padding(EdgeInsets(top: 4, leading: self.tagPadding, bottom: 4, trailing: self.tagPadding))  //cell padding
            .foregroundColor(.black)
            .background(Color(UIColor.systemGroupedBackground).clipShape(RoundedRectangle(cornerRadius: 15)))
        return AnyView(tv)
    }
    
    
    private func getTagIndex(from indexPath: (Int, Int)) -> Int{
        var ret = 0
        for i in 0..<indexPath.0{
            ret += self.cellCountInRow[i]
        }
        return ret + indexPath.1
    }
    
    private mutating func countElementInRow(width totalWidth: CGFloat){
        var tagsWidth = Array<CGFloat>()
        for cell in self.cells{
            let w = cell.width(withFont: self.tagFont) + self.tagPadding
            tagsWidth.append(w)
        }
        tagsWidth[tagsWidth.count - 1] += self.tagPadding
        var currentWidth: CGFloat = -self.tagPadding //first element, which is TAG:, doesn't have padding on leading
        var currentCount = 0
        var i = 0
        while(i <= tagsWidth.count){
            if(i == tagsWidth.count && currentCount > 0){
                self.cellCountInRow.append(currentCount)
                break
            }
            if currentWidth + tagsWidth[i] < totalWidth{
                currentWidth += tagsWidth[i]
                currentCount += 1
                i += 1
            }else{
                self.cellCountInRow.append(currentCount)
                currentWidth = 0.0
                currentCount = 0
            }
        }
    }
    
    private func saveNewTag(name: String){
        let newTag = Tag(context: viewContext)
        newTag.name = name
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}


struct TagView_Previews: PreviewProvider {
    static var previews: some View{
        //TagView(addable: true, selectedTags: [])
        TagView(addable: true, selectedTags: []).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
