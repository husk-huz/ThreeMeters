//
//  ThreeMeterUIView.swift
//  hzzzP8
//
//  Created by Zheng Hwang on 2023/5/18.
//

import SwiftUI

struct TextView : View
{
    @State var msg = ""
    
    var body: some View
    {
        ZStack
        {
            Rectangle()
                .foregroundColor(.black)
                .ignoresSafeArea()
            VStack
            {
                Spacer()
                TextField("要发送的信息", text: $msg)
                    .frame(height: 80)
                    .foregroundColor(.black)
                    .background(Color(red: 0.9, green: 0.9, blue: 0.9))
                    .cornerRadius(22)
                .textFieldStyle(CenterTextFieldStyle())
                Spacer()
                HzzzButton(label: "发送", function:
                {
                    ARPeer.sendData(data: msg, type: "msg")
                    globalThreeMeterUIModel.showSendText.toggle()
                })

                Spacer()
            }
        }
    }
}

class ThreeMeterUIModel : ObservableObject
{
    @Published var showConnection = false
    
    @Published var showHost = false
    
    @Published var showSendText = false
    
    @Published var showSendEmoji = false
    
    @Published var isConnected = false
}


struct ThreeMetersUIView : View
{
    @ObservedObject var threeMeterUIModel = globalThreeMeterUIModel
    
    var body: some View
    {
        VStack
        {
            HStack
            {
                HzzzButton(label: nameDict["quit"]!, function: {withAnimation
                    {
                        globalUIViewModel.isShowingThreeMeterARView = false
                        globalUIViewModel.isIntoThreeMeterView = true
                    }})
//                Button(nameDict["quit"]!)
//                {
//                    withAnimation
//                    {
//                        globalUIViewModel.isShowingThreeMeterARView = false
//                        globalUIViewModel.isIntoThreeMeterView = true
//                    }
//                }
//                .buttonStyle(HzzzDefaultButtonStyle())
                Spacer()
            }
            
            Spacer()
            
            if(threeMeterUIModel.isConnected)
            {
                HStack
                {
//                    HzzzButton(label: nameDict["join"]!, function:
//                    {
//                        threeMeterUIModel.showConnection.toggle()
//                    })
//                    .sheet(isPresented: $threeMeterUIModel.showConnection)
//                    {
//                        ConnectView()
//                    }
                    
                    Button(nameDict["join"]!)
                    {
                        threeMeterUIModel.showConnection.toggle()
                    }
                    .buttonStyle(HzzzDefaultButtonStyle())
                    .sheet(isPresented: $threeMeterUIModel.showConnection)
                    {
                        ConnectView()
                    }
                    
                    Spacer()
                    
                    Button(nameDict["host"]!)
                    {
                        threeMeterUIModel.showHost.toggle()
                    }
                    .buttonStyle(HzzzDefaultButtonStyle())
                    .sheet(isPresented: $threeMeterUIModel.showHost)
                    {
                        HostView()
                    }
                }
            }
            else
            {
                HStack
                {
                    VStack
                    {
//                        Button(nameDict["sendmsg"]!)
//                        {
//                            threeMeterUIModel.showSendText.toggle()
//                        }
//                        .buttonStyle(HzzzDefaultButtonStyle())
//                        .sheet(isPresented: $threeMeterUIModel.showSendText)
//                        {
//                            TextView()
//                        }
                        HzzzButton(label: nameDict["sendmsg"]!, function:
                        {
                            threeMeterUIModel.showSendText.toggle()
                        })
                        .sheet(isPresented: $threeMeterUIModel.showSendText)
                        {
                            TextView()
                        }
                        
                        Spacer().frame(height: 0)
                        
                        HzzzButton(label: nameDict["sendemoji"]!, function:
                        {
                            threeMeterUIModel.showSendEmoji.toggle()
                        })
                        .sheet(isPresented: $threeMeterUIModel.showSendEmoji)
                        {
                            SendEmojiView()
                        }
                        
//                        Button(nameDict["sendemoji"]!)
//                        {
//                            threeMeterUIModel.showSendEmoji.toggle()
//                        }
//                        .buttonStyle(HzzzDefaultButtonStyle())
//                        .sheet(isPresented: $threeMeterUIModel.showSendEmoji)
//                        {
//                            SendEmojiView()
//                        }
                    }
                    
                    Spacer()
                    
                    VStack
                    {
                        HzzzButton(label: nameDict["sendscene"]!, function:
                        {
                            av.shootAndSend()
                        })
                        
                        Spacer().frame(height: 0)
    //                    Button("发送场景")
    //                    {
    //                        av.shootAndSend()
    //                    }
    //                    .buttonStyle(HzzzDefaultButtonStyle())
                        
                        HzzzButton(label: nameDict["AI_assistance"]!)
                        {
                            
                        }
    //                    Button("  AI辅助  ")
    //                    {
    //
    //                    }
    //                    .buttonStyle(HzzzDefaultButtonStyle())
                    }
                }
            }
        }
    }
}



struct ThreeMeterUIView_Previews: PreviewProvider {
    static var previews: some View {
//        ThreeMetersUIView()
        ThreeMetersUIView()
    }
}
