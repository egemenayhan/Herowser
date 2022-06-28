//
//  Instantiatable.swift
//  Herowser
//
//  Created by Egemen Ayhan on 27.06.2022.
//

import UIKit

protocol Instantiatable {
    static func instantiate() -> Self
}

public protocol NibLoadable: AnyObject {
    /// The nib file to use to load a new instance of the View designed in a XIB
    static var nib: UINib { get }
}

extension NibLoadable where Self: UIView {

    public static var defaultNibName: String {
        return String(describing: self)
    }

    /// By default, use the nib which have the same name as the name of class
    static var nib: UINib {

        return UINib(nibName: String(describing: self), bundle: nil)
    }

    /// Returns a UIView object instantiated from nib
    ///
    /// - Returns: A `NibLoadable`, `UIView` instance
    static func instanceFromNib() -> Self {

        guard let view = nib.instantiate(withOwner: nil, options: nil).first as? Self else {
            fatalError("The nib \(nib) expected its root view to be of type \(self)")
        }

        return view
    }

}

extension Instantiatable where Self: UIViewController {

    static func instantiate() -> Self {
        let storyboard: UIStoryboard = UIStoryboard(name: "\(self)", bundle: bundle)
        return load(type: self, from: storyboard, identifier: "\(self)")
    }

    // MARK: - Private

    private static var bundle: Bundle {
        return Bundle(for: self)
    }

    private static func load<T>(type: T.Type, from storyboard: UIStoryboard, identifier: String) -> T {
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }

}
