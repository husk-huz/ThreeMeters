//
//  MainConfigView.swift
//  hzzzP8
//
//  Created by Zheng Hwang on 2023/5/17.
//

import SwiftUI

struct ConfigListView : View
{
    var body: some View
    {
        List
        {
            Section("账户首选项")
            {
                HStack
                {
                    Text("")
                        .foregroundColor(.white)
                    Spacer()
                    Button("设置")
                    {
                    }
                    .foregroundColor(.orange)
                }
                .listRowBackground(Color.black)
            }
            .frame(height: 40)
            
            Section("语言")
            {
                HStack
                {
                    Text("")
                        .foregroundColor(.white)
                    Spacer()
                    Button("设置")
                    {
                    }
                    .foregroundColor(.orange)
                }
                .listRowBackground(Color.black)
            }
            .frame(height: 40)
            
            Section("可用场景")
            {
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
                        }
                        .buttonStyle(HzzzDefaultButtonStyle())
                    }
                    .listRowBackground(Color.black)
                    .frame(height: 35)
                    .listRowSeparator(.visible)
                    .cornerRadius(22)
                    .listRowSeparatorTint(.gray)
                }
                .frame(height: 40)
            }
            .listRowBackground(Color.black)
            .listRowSeparator(.visible)
        }
        .listRowSeparator(.visible)
        .backgroundStyle(Color.black)
        .background(Color.black.ignoresSafeArea(.all))
        .cornerRadius(22)
    }
}

struct MainConfigView: View {
    var body: some View
    {
        VStack
        {
            Rectangle().backgroundStyle(.black).frame(height: 10)
            ConfigListView()
//            Rectangle().backgroundStyle(.black)
        }
    }
}

struct MainConfigView_Previews: PreviewProvider {
    static var previews: some View {
        MainConfigView()
    }
}
