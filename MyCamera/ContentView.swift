//
//  ContentView.swift
//  MyCamera
//
//  Created by furuta on 2024/11/22.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @State var captureImage: UIImage? = nil
    @State var isShowSheet = false
    @State var photoPickerSelectedImage: PhotosPickerItem? = nil
    
    var body: some View {
        VStack {
            Spacer()
            if let captureImage {
                Image(uiImage: captureImage)
                    .resizable()
                    .scaledToFit()
            }
            Spacer()
            Button {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    print("カメラは利用できます")
                    isShowSheet.toggle()
                } else {
                    print("カメラは利用できません")
                }
            } label: {
                Text("カメラを起動する")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .multilineTextAlignment(.center)
                    .background(.blue)
                    .foregroundStyle(.white)
            }
            .padding()
            .sheet(isPresented: $isShowSheet) {
                ImagePickerView(isShowSheet: $isShowSheet, captureImage: $captureImage)
            }
            
            PhotosPicker(selection: $photoPickerSelectedImage, matching: .images, preferredItemEncoding: .automatic, photoLibrary: .shared()) {
                Text("フォトライブラリーから選択する")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(.blue)
                    .foregroundStyle(.white)
                    .padding()
            }
            .onChange(of: photoPickerSelectedImage, initial: true, { oldValue, newValue in
                if let newValue {
                    Task {
                        if let data = try? await newValue.loadTransferable(type: Data.self) {
                            captureImage = UIImage(data: data)
                        }
                    }
                }
            })
            
            if let captureImage {
                let shareImage = Image(uiImage: captureImage)
                ShareLink(item: shareImage, subject: nil, message: nil, preview: SharePreview("Photo", image: shareImage)) {
                    Text("SNSに投稿する")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(.blue)
                        .foregroundStyle(.white)
                        .padding()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
