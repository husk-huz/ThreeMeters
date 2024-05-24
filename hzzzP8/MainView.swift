//
//  MainView.swift
//  hzzzP8
//
//  Created by Zheng Hwang on 2023/5/17.
//

import SwiftUI


struct MainView: View
{
    @ObservedObject var globalUI = globalUIViewModel
    
    init()
    {
        //修改标签栏背景色
        UITabBar.appearance().backgroundColor = UIColor(Color.black)
        //修改未选择的项的颜色
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color.gray)
    }
    
    var body: some View
    {
        ZStack
        {
            Rectangle().backgroundStyle(Color.black)
            
            if(!globalUI.isShowingThreeMeterARView ||
               globalUI.isIntoThreeMeterView)
            {
                TabView
                {
                    ZStack
                    {
                        Rectangle().background(Color.black)
                        MainHomeView()
                    }
                    .tabItem {
                        Image(systemName: "house")
                        Text("")
                            .foregroundColor(.white)
                    }
                    .backgroundStyle(Color.white)
                    ZStack
                    {
                        Rectangle().background(Color.black)
                        MainScanView()
                    }
                    .tabItem {
                        Image(systemName: "plus.viewfinder")
                        Text("")
                    }
                    ZStack
                    {
                        Rectangle().background(Color.black)
                        MainConfigView()
                    }
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                        Text("")
                    }
                }
                .accentColor(.orange)
                .transition(.move(edge: .trailing)) // 移入动画效果
                .animation(.easeInOut(duration: 1.0))
            }
                
            if(globalUI.isShowingThreeMeterARView)
            {
                TestThreeMeterView()
                    .transition(.move(edge: .leading)) // 移入动画效果
                    .animation(.easeInOut(duration: 1.0))
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
