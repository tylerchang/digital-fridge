//  Created by Simay Cural on 1/24/24.
//
//  This class provides a SwiftUI interface for capturing document scans using ScanData, and it handles the completion of the scanning process through a closure-based approach.

import Foundation
import VisionKit
import SwiftUI

struct ScannerView: UIViewControllerRepresentable {
    private let completionHandler: ([String]?) -> Void
     
    init(completion: @escaping ([String]?) -> Void) {
        self.completionHandler = completion
    }
     
    typealias UIViewControllerType = VNDocumentCameraViewController
     
    func makeUIViewController(context: UIViewControllerRepresentableContext<ScannerView>) -> VNDocumentCameraViewController {
        let viewController = VNDocumentCameraViewController()
        viewController.delegate = context.coordinator
        return viewController
    }
     
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: UIViewControllerRepresentableContext<ScannerView>) {}
     
    func makeCoordinator() -> Coordinator {
        return Coordinator(completion: completionHandler)
    }
     
    final class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        private let completionHandler: ([String]?) -> Void
         
        init(completion: @escaping ([String]?) -> Void) {
            self.completionHandler = completion
        }
         
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            print("Document camera view controller did finish with ", scan)
            let recognizer = TextRecognizer(cameraScan: scan)
            recognizer.recognizeText(withCompletionHandler: completionHandler)
        }
         
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            completionHandler(nil)
        }
         
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            print("Document camera view controller did finish with error ", error)
            completionHandler(nil)
        }
    }
}
