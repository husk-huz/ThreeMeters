
import SwiftUI
import UIKit
import SceneKit
import ARKit
import Vision
import Foundation

func createNewBubbleParentNode(_ text : String) -> SCNNode
{
    
    // TEXT BILLBOARD CONSTRAINT
    let bubbleDepth : Float = 0.01
    let billboardConstraint = SCNBillboardConstraint()
    billboardConstraint.freeAxes = SCNBillboardAxis.Y
    
    // BUBBLE-TEXT
    let bubble = SCNText(string: text, extrusionDepth: CGFloat(bubbleDepth))
    let font = UIFont(name: "Futura", size: 0.15)
//    font = font?.withTraits(traits: .traitBold)
    bubble.font = font
//    bubble.alignmentMode = kCAAlignmentCenter
    bubble.firstMaterial?.diffuse.contents = UIColor.orange
    bubble.firstMaterial?.specular.contents = UIColor.white
    bubble.firstMaterial?.isDoubleSided = true
    // bubble.flatness // setting this too low can cause crashes.
    bubble.chamferRadius = CGFloat(bubbleDepth)
    
    // BUBBLE NODE
    let (minBound, maxBound) = bubble.boundingBox
    let bubbleNode = SCNNode(geometry: bubble)
    // Centre Node - to Centre-Bottom point
    bubbleNode.pivot = SCNMatrix4MakeTranslation( (maxBound.x - minBound.x)/2, minBound.y, bubbleDepth/2)
    // Reduce default text size
    bubbleNode.scale = SCNVector3Make(0.2, 0.2, 0.2)
    
    // CENTRE POINT NODE
//    let sphere = SCNSphere(radius: 0.005)
//    sphere.firstMaterial?.diffuse.contents = UIColor.cyan
//    let sphereNode = SCNNode(geometry: sphere)
    
    // BUBBLE PARENT NODE
    let bubbleNodeParent = SCNNode()
    bubbleNodeParent.addChildNode(bubbleNode)
//    bubbleNodeParent.addChildNode(sphereNode)
    bubbleNodeParent.constraints = [billboardConstraint]
    
    return bubbleNodeParent
}

struct ARView: UIViewControllerRepresentable
{
//    var str : String
    var isUpdate : Int
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ARView>) -> ARViewController
    {
//        return ARViewController(str: "hzzz")
        av = ARViewController()
        return av;
    }
    
    func updateUIViewController(_ uiViewController: ARViewController, context: UIViewControllerRepresentableContext<ARView>)
    {
//        return ARViewController(str: str)
//        av.setStr(str: self.str)
        av.update()
    }
}

var textRaw = ""

func recognizeTextInImage(_ image: UIImage) -> String
{
    guard let cgImage = image.cgImage else { return "" }
    var res = ""
    let request = VNRecognizeTextRequest { request, error in
        guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
        let recognizedStrings = observations.compactMap { observation in
            observation.topCandidates(1).first?.string
        }
        print(recognizedStrings)
        textRaw = ""
        for str in recognizedStrings
        {
            res += "\n" + str
            textRaw += " " + str
        }
        if(res.count > 0)
        {
            res.remove(at: res.startIndex)
            textRaw.remove(at: textRaw.startIndex)
        }
    }
    request.recognitionLevel = .accurate
    request.recognitionLanguages = ["zh-Hans"]
    let handler = VNImageRequestHandler(cgImage: cgImage)
    try? handler.perform([request])
    
    return res
}


class ARViewController: UIViewController, ARSCNViewDelegate
{

    var str : String = "hzzz"
    
    var sceneView: ARSCNView! = nil
    
    func update()
    {
        let scene = ARScene.newarScene()
        
        // Present the scene
        sceneView = self.view as? ARSCNView
        sceneView.delegate = self
        sceneView.scene = scene
    }
    
    func OCRShoot()
    {
        let capturedImage = sceneView.snapshot()
        globalARViewModel.arDisplayOCRText = recognizeTextInImage(capturedImage)
        globalARViewModel.arDisplayOCRText = textRaw
        globalARViewModel.isEdited += 1
    }
    
    func setStr(str: String)
    {
        self.str = str
        let scene = ARScene.newarScene()
        
        // Present the scene
        sceneView = self.view as? ARSCNView
        sceneView.delegate = self
        sceneView.scene = scene
    }
    
    func shootAndSend()
    {
        let capturedImage = sceneView.snapshot()
        if let imageData = capturedImage.pngData()
        {
            let base64String = imageData.base64EncodedString()
            print("send image")
            ARPeer.sendData(data: base64String, type: "image")
        }
    }
    
    func shootScreen()
    {
        let hiResFormat = ARWorldTrackingConfiguration.recommendedVideoFormatFor4KResolution
        
        let capturedImage = sceneView.snapshot()
        
        
        
        // Create an SCNNode with a plane geometry and the captured image as its texture
//        let imageGeometry = SCNPlane(width: 2.160/2, height: 3.840/2)
//        print(capturedImage.size.width)
        let imageGeometry = SCNPlane(width: capturedImage.size.width/828*2.160/2,
                                     height: capturedImage.size.height/828*2.160/2)
        let imageMaterial = SCNMaterial()
        imageMaterial.diffuse.contents = capturedImage
        imageGeometry.materials = [imageMaterial]
        let capturedImageNode = SCNNode(geometry: imageGeometry)

        // Position the image node in front of the camera
//        if let camera = sceneView.pointOfView
        
//        {
        capturedImageNode.position = SCNVector3(x: 1, y: 1, z: -3)
        sceneView.scene.rootNode.addChildNode(capturedImageNode)
        
//        capturedImageNode.eulerAngles = camera.eulerAngles
        
//            camera.addChildNode(capturedImageNode)
//        }
    }
    
    
    override func loadView()
    {
        super.loadView()
        view = ARSCNView()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let scene = ARScene.newarScene()
        
        // Present the scene
        sceneView = self.view as? ARSCNView
        sceneView.delegate = self
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
}

func charToString(c : Character) -> String
{
    var unistring = String(c.unicodeScalars.first!.value, radix: 16)
    while(unistring.count < 4)
    {
        unistring = "0" + unistring
    }
    
    return unistring
}


class ARScene: SCNScene
{
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func newarScene() -> SCNScene
    {
//        print("U\(charToString(c: self.c)).scn")
//        let scene = SCNScene(named: "SCNmodel/U\(charToString(c: self.c)).scn")!
//        let scene = SCNScene()
        let scene = SCNScene()
//        let scene = SCNScene(named: "EmojiSCN/maple_leaf.scn")
//        let secScene = SCNScene(named: "EmojiSCN/axe.scn")
//        let thrScene = SCNScene(named: "EmojiSCN/bat.scn")
        
//        let node2 = secScene?.rootNode.childNodes.first
//        let node3 = thrScene?.rootNode.childNodes.first
        
//        let node = scene?.rootNode.childNodes.first
//        node?.position = SCNVector3(0, 0, -11)
//        node2?.position = SCNVector3(0, 1, -11)
//        node3?.position = SCNVector3(0, 2, -11)
//        scene?.rootNode.position = SCNVector3(0, 0, -5)
        
        // OCR
        let scnNode = createNewBubbleParentNode(globalARViewModel.arDisplayOCRText)
        scnNode.position = SCNVector3(x: 0, y: 0, z: -3)
        scene.rootNode.addChildNode(scnNode)
        
        // AI res
        
        // msg text
        let msgNode = createNewBubbleParentNode(globalARViewModel.arDisplayString)
        msgNode.position = SCNVector3(x: 0, y: 0, z: -3)
        scene.rootNode.addChildNode(msgNode)
        
        // Emoji
        let emojiNode = SCNScene(named: "EmojiSCN/\(globalARViewModel.arDisplayEmoji).scn")?.rootNode.childNodes.first
        emojiNode?.position = SCNVector3(0, 0, -3)
        scene.rootNode.addChildNode(emojiNode!)
        
        // Image
        if(globalARViewModel.arDisplayImage != nil)
        {
            var capturedImage = globalARViewModel.arDisplayImage
            let imageGeometry = SCNPlane(width: capturedImage!.size.width/828*2.160/2,
                                         height: capturedImage!.size.height/828*2.160/2)
            let imageMaterial = SCNMaterial()
            imageMaterial.diffuse.contents = capturedImage
            imageGeometry.materials = [imageMaterial]
            let capturedImageNode = SCNNode(geometry: imageGeometry)
            capturedImageNode.position = SCNVector3(x: 1, y: 1, z: -3)
            scene.rootNode.addChildNode(capturedImageNode)
        }
        
//        scene?.rootNode.addChildNode(node2 ?? scnNode)
//        scene?.rootNode.addChildNode(node3 ?? scnNode)
        
        
//        var character: Character = "我"
//        var unicodeValue = charToString(c: character)
//        print("The Unicode value of \(character) is \(unicodeValue)")
//        character = "J"
//        unicodeValue = charToString(c: character)
//        print("The Unicode value of \(character) is \(unicodeValue)")
        return scene
    }
}
