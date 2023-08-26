/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import SafariServices
import SwiftUI

class HostingTableViewCell<Content: View>: UITableViewCell {

    private weak var controller: UIHostingController<Content>?
    @State var showSafari = false
    func host(_ view: Content, parent: UIViewController) {
        if let controller = controller {
            controller.rootView = view
            controller.view.layoutIfNeeded()
        } else {
            let swiftUICellViewController = UIHostingController(rootView: view)
            controller = swiftUICellViewController
            swiftUICellViewController.view.backgroundColor = .clear

            layoutIfNeeded()

            parent.addChild(swiftUICellViewController)
            contentView.addSubview(swiftUICellViewController.view)
            swiftUICellViewController.view.translatesAutoresizingMaskIntoConstraints = false
            contentView.addConstraint(NSLayoutConstraint(item: swiftUICellViewController.view!, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: contentView, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1.0, constant: 0.0))
            contentView.addConstraint(NSLayoutConstraint(item: swiftUICellViewController.view!, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: contentView, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1.0, constant: 0.0))
            contentView.addConstraint(NSLayoutConstraint(item: swiftUICellViewController.view!, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: contentView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 0.0))
            contentView.addConstraint(NSLayoutConstraint(item: swiftUICellViewController.view!, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: contentView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0.0))

            swiftUICellViewController.didMove(toParent: parent)
            swiftUICellViewController.view.layoutIfNeeded()
        }
    }
    func updateWithNewsItem(_ item: NewsItem) {
      textLabel?.text = item.title
        detailTextLabel?.text = item.subtitle
    }
}

final class NewsFeedTableViewWrapper: UIViewControllerRepresentable {
    
    static let refreshNewsFeedNotification = Notification.Name(rawValue: "RefreshNewsFeedNotification")
    let newsStore = NewsStore.shared
    var vc: UITableViewController?
    
    // MARK: UIViewControllerRepresentable
       typealias UIViewControllerType = UITableViewController
    
       func makeUIViewController(context: Context) -> UITableViewController {
        let tvc = UITableViewController()
        tvc.tableView.delegate = context.coordinator
        tvc.tableView.dataSource = context.coordinator
        tvc.tableView.rowHeight = UITableView.automaticDimension
        tvc.tableView.estimatedRowHeight = 75
        if let patternImage = UIImage(named: "pattern-grey") {
          let backgroundView = UIView()
          backgroundView.backgroundColor = UIColor(patternImage: patternImage)
        
        let nc = NotificationCenter.default
            nc.addObserver(self, selector: #selector(NewsFeedTableViewWrapper.receivedRefreshNewsFeedNotification(_:)), name: NewsFeedTableViewWrapper.refreshNewsFeedNotification, object: nil)
        tvc.tableView.backgroundView = backgroundView
        }
        tvc.tableView.register(HostingTableViewCell<Text>.self, forCellReuseIdentifier: "NewsItemCell")
//        tvc.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NewsItemCell")
        
   
        self.vc = tvc
           return tvc
       }

    
       func updateUIViewController(_ uiViewController: UITableViewController, context: Context) {
        uiViewController.tableView.reloadData()
        
       }
    
       func makeCoordinator() -> Coordinator {
           Coordinator(self)
       }
    
    @objc func receivedRefreshNewsFeedNotification(_ notification: Notification) {
      DispatchQueue.main.async {
        
        self.vc?.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
      }
    }

    class Coordinator: NSObject, UITableViewDataSource, UITableViewDelegate {
        // MARK: Properties and initializer
        static let refreshNewsFeedNotification = Notification.Name(rawValue: "RefreshNewsFeedNotification")
        let newsStore = NewsStore.shared
        private let parent: NewsFeedTableViewWrapper
       
        init(_ parent: NewsFeedTableViewWrapper) {
            self.parent = parent
        }
       
      
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return newsStore.items.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsItemCell") as! HostingTableViewCell<Text>
           
          if let newsCell = cell as?  HostingTableViewCell {
            newsCell.updateWithNewsItem(newsStore.items[indexPath.row])
          }
          return cell
        }
        
        func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
          let item = newsStore.items[indexPath.row]
          return false
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let item = newsStore.items[indexPath.row]
           
        }
        
    }
}

struct SafariView: UIViewControllerRepresentable {

    let url: URL

    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {

    }

}
