//
//  hzzzP8App.swift
//  hzzzP8
//
//  Created by Zheng Hwang on 2023/4/22.
//

import SwiftUI

@main
struct hzzzP8App: App
{
    let persistenceController = PersistenceController.shared
    
    @State var isShowSheet : Bool = false

    var body: some Scene {
        WindowGroup {
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            
//            MainView()
//            TestThreeMeterView()
            SendEmojiView()
//            HzzzButton(label: "hzzz", function: {print("clicked")})
//            VStack
//            {
//                Button("显示连接")
//                {
//                    isShowSheet.toggle()
//                }
//                ARContentView()
//            }
//            .sheet(isPresented: $isShowSheet)
//            {
//                VStack
//                {
//                    ConnectView()
//                    Spacer()
//                    HostView()
//                }
//                .onDisappear
//                {
//                    print("ERROR: sheet deleted")
//                }
//            }
        }
    }
}
