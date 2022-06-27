//
//  Handlers.swift
//  Herowser
//
//  Created by Egemen Ayhan on 27.06.2022.
//

import Foundation

public typealias Handler<T> = ((T) -> Void)
public typealias DoubleHandler<T, U> = ((T, U) -> Void)

public typealias VoidHandler = () -> Void
public typealias BoolHandler = Handler<Bool>
public typealias StringHandler = Handler<String>
public typealias IntHandler = Handler<Int>
