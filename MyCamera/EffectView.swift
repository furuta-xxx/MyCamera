//
//  EffectView.swift
//  MyCamera
//
//  Created by furuta on 2024/11/23.
//

import SwiftUI

struct EffectView: View {
    @Binding var isShowSheet: Bool
    let captureImage: UIImage
    @State var showImage: UIImage?
    let filterArray = [
        "CIPhotoEffectMono",
        "CIPhotoEffectChrome",
        "CIPhotoEffectFade",
        "CIPhotoEffectInstant",
        "CIPhotoEffectNoir",
        "CIPhotoEffectProcess",
        "CIPhotoEffectTonal",
        "CIPhotoEffectTransfer",
        "CISepiaTone"
    ]
    @State var filterSelectNumber = 0
    @State var filterName = ""
    
    var body: some View {
        VStack {
            Spacer()
            
            if let showImage {
                ZStack(alignment: .bottom) {
                    Image(uiImage: showImage)
                        .resizable()
                        .scaledToFit()
                    if filterName.count > 0 {
                        Text(filterName)
                            .padding(5)
                            .background(.black)
                            .foregroundStyle(.white)
                            .padding(5)
                    }
                }
            }
            
            Spacer()
            
            Button {
                filterName = filterArray[filterSelectNumber]
                filterSelectNumber += 1
                if filterSelectNumber == filterArray.count {
                    filterSelectNumber = 0
                }
                let rotate = captureImage.imageOrientation
                let inputImage = CIImage(image: captureImage)
                
                guard let effectFilter = CIFilter(name: filterName) else {
                    return
                }
                effectFilter.setDefaults()
                effectFilter.setValue(inputImage, forKey: kCIInputImageKey)
                guard let outputImage = effectFilter.outputImage else {
                    return
                }
                let ciContext = CIContext(options: nil)
                guard let cgImage = ciContext.createCGImage(outputImage, from: outputImage.extent) else {
                    return
                }
                showImage = UIImage(cgImage: cgImage, scale: 1.0, orientation: rotate)
            } label: {
                Text("エフェクト")
                    .buttonTextModifier()
                    .multilineTextAlignment(.center)
            }
            .padding()
            
            if let showImage {
                let shareImage = Image(uiImage: showImage)
                ShareLink(item: shareImage, subject: nil, message: nil, preview: SharePreview("Photo", image: shareImage)) {
                    Text("シェア")
                        .buttonTextModifier()
                }
                .padding()
            }
            
            Button {
                isShowSheet.toggle()
            } label: {
                Text("閉じる")
                    .buttonTextModifier()
                    .multilineTextAlignment(.center)
            }
            .padding()
        }
        .background(.white)
        .onAppear {
            showImage = captureImage
        }
    }
}

#Preview {
    EffectView(isShowSheet: .constant(true), captureImage: UIImage(named: "preview_use")!)
}
