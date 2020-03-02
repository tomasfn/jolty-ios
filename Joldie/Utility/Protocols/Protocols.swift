//
//  Protocols.swift
//  Jolty
//
//  Created by Tomás Fernandez Nuñez on 5/28/18.
//  Copyright © 2018 Tomás Fernandez Nuñez. All rights reserved.
//

import UIKit

@objc public protocol Reusable {
    static var identifier: String! { get }
    @objc optional static var nib: UINib! { get }
}

public protocol CellHeight {
    static var cellHeight: CGFloat { get }
}

public protocol PopUpPresentable: class {
    func popUp(animated: Bool) -> Self
    func remove(animated: Bool)
}

public protocol JSONInstanciable {
    init(JSON: [String : AnyObject])
}

public protocol ArrayInstanciable {
    associatedtype InstanceType
    static func instancesFromJSONArray(jsonArray: [[String : AnyObject]]) -> [InstanceType]?
}

public protocol StandaloneCopiable {
    associatedtype InstanceType
    func standaloneCopy() -> InstanceType!
}
