

import SwiftUI



struct ARScanContentView: View
{
    @State private var userInput: String = ""
    
    @ObservedObject var obARViewModel = globalARViewModel
    
    var body: some View
    {
        ZStack
        {
            ARView(isUpdate: globalARViewModel.isEdited).edgesIgnoringSafeArea(.all)
            VStack
            {
                Spacer()
                HzzzButton(label: "AI辅助", function: {av.OCRShoot()})
            }
        }
    }
}


struct ARContentView: View
{
    @State private var userInput: String = ""
    
    @ObservedObject var obARViewModel = globalARViewModel
    
    var body: some View
    {
//        ZStack
//        {
        ARView(isUpdate: globalARViewModel.isEdited).edgesIgnoringSafeArea(.all)
//            VStack
//            {
//                Spacer()
                
//                TextField("Type here", text: $obARViewModel.arDisplayString)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
                
//                Button("Shoot Screen")
//                {
//                    av.shootScreen()
//                }
                
//                Button("tap")
//                {
//                    print("hzzz")
//                }
//            }
//        }
        
    }
}

struct ThreeMetersMainView: View
{
    var body: some View
    {
        ZStack
        {
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View
    {
//        ContentView()
        ZStack
        {
            Rectangle().fill(.black).ignoresSafeArea()
            Text("AR 视图").foregroundColor(.white)
            ThreeMetersUIView()
        }
    }
}

struct TestThreeMeterView: View
{
    var body: some View
    {
        ZStack
        {
            Rectangle().fill(.black).ignoresSafeArea()
//            Text("AR 视图").foregroundColor(.white)
            ARContentView()
            ThreeMetersUIView()
        }
    }
}
