//
//  UIImage+Identifiable.swift
//  CollectionsApp
//
//  Created by Dominguez, Harley on 4/22/26.
//
import UIKit

extension UIImage: @retroactive Identifiable {
    public var id: ObjectIdentifier { ObjectIdentifier(self) }
}
