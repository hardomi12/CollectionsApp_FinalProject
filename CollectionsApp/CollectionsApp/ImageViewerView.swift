//
//  ImageViewerView.swift
//  CollectionsApp
//
//  Created by Dominguez, Harley on 4/22/26.
//


import SwiftUI

struct ImageViewerView: View {
    var uiImage: UIImage
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black
                .ignoresSafeArea()

            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(.white, .black.opacity(0.6))
                    .padding(20)
            }
        }
    }
}