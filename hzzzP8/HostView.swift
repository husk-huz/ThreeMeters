//
//  HostView.swift
//  hzzzP9
//
//  Created by Zheng Hwang on 2023/4/23.
//

import Foundation
import SwiftUI
import Network


class HostControl : ObservableObject, PeerConnectionDelegate
{
    @ObservedObject var obARViewModel = globalARViewModel
    
    func connectionReady()
    {
        print("connect ready")
        globalThreeMeterUIModel.isConnected = true
    }
    
    func connectionFailed()
    {
        print("connect failed")
    }
    
    func receivedMessage(content: Data?, message: NWProtocolFramer.Message)
    {
        print("recved msg")
        let move = String(data: content!, encoding: .unicode)
        print(move as Any)
        ARPeer.getMSG(data: move!)
        
//        obARViewModel.arDisplayString = move ?? "no msg";
    }
    
    func displayAdvertiseError(_ error: NWError)
    {
        print("error")
    }
    
    @Published var msg : String = "(none)"
    
    func getStarted(hostName : String)
    {
        bonjourListener = PeerListener(name: hostName, passcode: "330222", delegate: self)
    }
    
    func sendMSG(str : String)
    {
        sharedConnection?.sendMove(str)
    }
    
    static func getHostControl() -> HostControl
    {
        if(globalHostControl == nil)
        {
            globalHostControl = HostControl()
        }
        
        return globalHostControl ?? HostControl()
    }
}

struct CenterTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .multilineTextAlignment(.center)
    }
}

struct HostView : View
{
    @ObservedObject var hostcontrol : HostControl = HostControl.getHostControl()
    
    @State var hostname : String = ""
    
    @State var userInput : String = ""
    
    @State var isShowStart = true
    
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
                TextField("设置host的名称", text: $hostname)
                    .frame(height: 80)
                    .foregroundColor(.black)
                    .background(Color(red: 0.9, green: 0.9, blue: 0.9))
                    .cornerRadius(22)
                .textFieldStyle(CenterTextFieldStyle())
                Spacer()
                HzzzButton(label: "start", function:
                            {
                    hostcontrol.getStarted(hostName: hostname)
                    isShowStart.toggle()
                })
                .disabled(!isShowStart)
                .opacity(isShowStart ? 1 : 0)

                Spacer()
            }
        }
    }
}

struct HostView_Previews: PreviewProvider {
    static var previews: some View
    {
        HostView()
    }
}
