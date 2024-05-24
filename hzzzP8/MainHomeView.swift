//
//  MainHomeView.swift
//  hzzzP8
//
//  Created by Zheng Hwang on 2023/5/17.
//

import SwiftUI

struct MainHomeView: View {
    var body: some View
    {
        VStack
        {
            Rectangle().backgroundStyle(.black).frame(height: 10)
            MainSceneListView()
                .cornerRadius(22)
        }
    }
}

struct MainHomeView_Previews: PreviewProvider {
    static var previews: some View {
        MainHomeView()
    }
}
