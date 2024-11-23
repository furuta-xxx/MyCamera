//
//  ButtonTextModifier.swift
//  MyCamera
//
//  Created by furuta on 2024/11/23.
//

import SwiftUI

extension Text {
    func buttonTextModifier() -> some View {
        self
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(.blue)
            .foregroundStyle(.white)
    }
}
