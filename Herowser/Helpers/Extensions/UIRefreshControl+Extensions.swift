//
//  UIRefreshControl+Extensions.swift
//  Herowser
//
//  Created by Egemen Ayhan on 28.06.2022.
//

import UIKit

extension UIRefreshControl {

    func programaticallyBeginRefreshing(in tableView: UITableView) {
        beginRefreshing()
        let offsetPoint = CGPoint.init(x: 0, y: -frame.size.height)
        tableView.setContentOffset(offsetPoint, animated: true)
    }

}
