//
//  GifController.swift
//  
//
//  Created by Deeb Zaarab on 2021-01-02.
//

import SwiftUI
import GiphyUISDK
import GiphyCoreSDK

struct GIFController: UIViewControllerRepresentable {
    
    func makeCoordinator() -> Coordinator {
        return GIFController.Coordinator(parent: self)
    }
    
    @Binding var url : String
    @Binding var present : Bool
    func makeUIViewController(context: Context) -> GiphyViewController {
        Giphy.configure(apiKey: "8ss10A0M02zWiiaFZuLhKCYDCu9BnWcG")
        let controller = GiphyViewController()
        controller.mediaTypeConfig = [.emoji,.gifs,.stickers]
        controller.delegate = context.coordinator
        // for fullscreen
        GiphyViewController.trayHeightMultiplier = 1.05
        controller.theme = GPHTheme(type: .darkBlur)
        return controller
        
    }
    
    func updateUIViewController(_ uiViewController: GiphyViewController, context: Context) {
        
    }
    
    class Coordinator: NSObject, GiphyDelegate {
        var parent: GIFController
        init(parent: GIFController) {
            self.parent = parent
        }
        
        func didDismiss(controller: GiphyViewController?) {
            
        }
        
        func didSelectMedia(giphyViewController: GiphyViewController, media: GPHMedia) {
            let url = media.url(rendition: .fixedWidth, fileType: .gif)
            parent.url = url ?? ""
            parent.present.toggle()
        }
    }
}
