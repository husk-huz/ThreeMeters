//
//  MainSceneListView.swift
//  hzzzP8
//
//  Created by Zheng Hwang on 2023/5/17.
//

import SwiftUI

class SceneRow : Identifiable
{
    var id = UUID()
    var name: String = ""
    
    init(name: String)
    {
        self.name = name
    }
}

var testSceneRow = getTest()

func getTest() -> [SceneRow]
{
    var testSceneRow = [SceneRow]()
    
    for i in Range(1...3)
    {
        testSceneRow.append(SceneRow(name: "hzzz".appending(String(i))))
    }
    
    return testSceneRow
}


struct MainSceneListPartView : View
{
    var body: some View
    {
        Section("可用场景")
        {
            Divider().background(.white)
            ForEach(getTest())
            {
                item in
                HStack
                {
                    Text(item.name)
                        .foregroundColor(.white)
                    Spacer()
                    Button("设置")
                    {
//                        globalUI.isShowingThreeMeterARView = true
                    }
                    .buttonStyle(HzzzDefaultButtonStyle())
                }
                .listRowBackground(Color.black)
                .frame(height: 50)
                .listRowSeparator(.visible)
                .cornerRadius(22)
                .listRowSeparatorTint(.gray)
                Divider().background(.white)
            }
            .frame(height: 30)
            Spacer()
        }
        .foregroundColor(.orange)
        .listRowBackground(Color.black)
        .listRowSeparator(.visible)
//        List(testSceneRow)
//        {
//            scene in
//            HStack
//            {
//                Text(scene.name)
//                    .foregroundColor(.white)
//                Spacer()
//                Button("进入")
//                {
//
//                }
//                .buttonStyle(HzzzDefaultButtonStyle())
//            }
//            .listRowBackground(Color.black)
//            .frame(height: 50)
//            .listRowSeparator(.visible)
//            .cornerRadius(22)
//            .listRowSeparatorTint(.gray)
//        }
    }
}


struct MainSceneListView: View
{
    @ObservedObject var globalUI = globalUIViewModel
    
    var body: some View
    {
        ZStack
        {
            Rectangle()
                .foregroundColor(.black)
                .ignoresSafeArea()
            
            
            Section("可用场景")
            {
                List(testSceneRow)
                {
                    scene in
                    HStack
                    {
                        Text(scene.name)
                            .foregroundColor(.white)
                        Spacer()
                        Button("进入")
                        {
                            withAnimation
                            {
                                globalUI.isShowingThreeMeterARView = true
                                globalUI.isIntoThreeMeterView = false
                            }
                        }
                        .buttonStyle(HzzzDefaultButtonStyle())
                    }
                    .listRowBackground(Color.black)
                    .frame(height: 50)
                    .listRowSeparator(.visible)
                    .cornerRadius(22)
                    .listRowSeparatorTint(.gray)
                }
            }
            .foregroundColor(.black)
            
            Spacer()
        }
    }
}

struct MainSceneListView_Previews: PreviewProvider {
    static var previews: some View {
        MainSceneListView()
    }
}
