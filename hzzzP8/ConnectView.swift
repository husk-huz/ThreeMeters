//
//  ConnectView.swift
//  hzzzP8
//
//  Created by Zheng Hwang on 2023/4/22.
//

import SwiftUI
import Network

struct HostFound: Identifiable
{
    let name : String
    let id = UUID()
}

class Connecter: PeerConnectionDelegate, ObservableObject
{
    @Published var systemMsg: String = "(none)"
    
    @Published var msg: String = "(none)"
    
    @Published var hostname : String = "(none)"
    
    @Published var results : [NWBrowser.Result] = [NWBrowser.Result]()
    
    @Published var nameResults : [HostFound] = [HostFound]()
    
    @ObservedObject var arViewModel : ARViewModel = globalARViewModel
    
    func connectionReady()
    {
        print("connect ready")
        systemMsg = "connect ready"
        globalThreeMeterUIModel.isConnected = true
    }
    
    func connectionFailed()
    {
        print("connect failed")
        systemMsg = "connect failed"
    }
    
    func receivedMessage(content: Data?, message: NWProtocolFramer.Message)
    {
        print("recved msg")
        let move = String(data: content!, encoding: .unicode)
        print(move as Any)
//        self.msg = move ?? "(none)"
        ARPeer.getMSG(data: move!)
//        self.systemMsg = "收到新的消息"
        
//        arViewModel.arDisplayString = move ?? "(no msg)"
    }
    
    func displayAdvertiseError(_ error: NWError)
    {
        print("error")
    }
    
    init()
    {
        applicationServiceListener = PeerListener(delegate: self)
    }
    
    func getInit()
    {
        sharedBrowser = PeerBrowser(delegate: self)
        systemMsg = "start to browser for host"
    }
    
    func getConnect()
    {
        print("try to connect")
        sharedConnection = PeerConnection(endpoint: results[0].endpoint, interface: results[0].interfaces.first, passcode: "330222", delegate: self)
    }
    
    func sendMSG(str : String)
    {
        sharedConnection?.sendMove(str)
        systemMsg = "message has been sent: (\(str))"
    }
    
    static func getConnector() -> Connecter
    {
        if(globalConnecter == nil)
        {
            globalConnecter = Connecter()
        }
        
        return globalConnecter ?? Connecter()
    }
}

extension Connecter: PeerBrowserDelegate
{
    func refreshResults(results: Set<NWBrowser.Result>)
    {
        self.results = [NWBrowser.Result]()
        self.nameResults = [HostFound]()
        for result in results
        {
            if case let NWEndpoint.service(name: name, type: _, domain: _, interface: _) = result.endpoint
            {
                print("find: " + name)
                self.hostname = name
                self.results.append(result)
                self.nameResults.append(HostFound(name: name))
            }
        }
    }
    
    func displayBrowseError(_ error: NWError)
    {}
}

struct HzzzDefaultButtonStyle: ButtonStyle
{
    func makeBody(configuration: Configuration) -> some View
    {
        configuration.label
            .padding(10)
            .cornerRadius(10)
            .foregroundColor(.orange)
            .background(Color(red: 0.2, green: 0.2, blue: 0.2))
            .overlay(
                RoundedRectangle(cornerRadius: 1)
                    .stroke(lineWidth: 1)
                    .cornerRadius(10)
            )
            .cornerRadius(22)        
    }
}

struct HzzzButton: View
{
    @State private var isButtonScaled = false
    
    var label : String
    
    var function : () -> Void
    
    var body: some View
    {
        Button(label)
        {
            self.function()
            
            // 按钮被点击时，设置isButtonScaled为true
            self.isButtonScaled = true
            
            // 0.2秒后将isButtonScaled设置为false，以便按钮缩小
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.isButtonScaled = false
            }
        }
        .padding()
//        .background(Color.blue)
//        .foregroundColor(.white)
//        .clipShape(Circle())
        .scaleEffect(isButtonScaled ? 1.2 : 1.0) // 根据isButtonScaled的值来缩放按钮
        .animation(.easeInOut(duration: 0.2)) // 添加动画效果
        .gesture(TapGesture()) // 添加tap手势
        .buttonStyle(HzzzDefaultButtonStyle())
    }
}

struct ConnectTestView: View
{
    @ObservedObject var connector: Connecter = Connecter.getConnector()
    
    @State var userInput : String = ""
    
    var body: some View
    {
        ZStack
        {
            Rectangle().fill(.black)
            VStack
            {

                Spacer()
                Button("点击开始寻找host")
                {
                    connector.getInit()
                }
                .buttonStyle(HzzzDefaultButtonStyle())

                HostListView(connector: connector)
                    .cornerRadius(22)
                Button("点击连接选择的host")
                {
                    connector.getConnect()
                }
                .buttonStyle(HzzzDefaultButtonStyle())
                Spacer()
            }
            .cornerRadius(22)
        }
    }
}

struct ConnectView: View
{
    var body: some View
    {
        ZStack
        {
//            Text("Connection")
//            Spacer()
            Rectangle().fill(.black).ignoresSafeArea()
            ConnectTestView()
        }
    }
}

struct HostListView : View
{
    @ObservedObject var connector : Connecter
    
    var body: some View
    {
        List
        {
            Section("发现的hosts")
            {
//                List(connector.nameResults)
//                {
//                    res in
//                    HStack
//                    {
//                        Text(res.name)
//                        Spacer()
//                        Button("Set")
//                        {
//                            connector.hostname = res.name
//                        }
//                        .buttonStyle(HzzzDefaultButtonStyle())
//                        Divider().background(Color.white)
//                    }
//                }
                
                ForEach(connector.nameResults)
                {
                    item in
                    HStack
                    {
                        Text(item.name)
                            .foregroundColor(.white)
                        Spacer()
                        HzzzButton(label: "Set", function:
                        {
                            connector.hostname = item.name
                        })
                    }
                    .listRowBackground(Color.black)
                    .frame(height: 35)
                    .listRowSeparator(.visible)
                    .cornerRadius(22)
                    .listRowSeparatorTint(.gray)
                }
                .frame(height: 40)
            }
            .foregroundColor(.gray)
            .listRowSeparator(.visible)
            
            Section("当前的选择")
            {
                Text(connector.hostname)
                    .foregroundColor(.white)
                    .listRowBackground(Color.black)
                    .frame(height: 35)
                    .listRowSeparator(.visible)
                    .cornerRadius(22)
                    .listRowSeparatorTint(.gray)
            }
        }
        .listRowSeparator(.visible)
        .backgroundStyle(Color.black)
        .background(Color.black.ignoresSafeArea(.all))
    }
}


struct ConnectView_Previews: PreviewProvider {
    static var previews: some View
    {
        ConnectView()
//        HzzzButton(label: "hzzz", function: {print("clicked")})
    }
}
