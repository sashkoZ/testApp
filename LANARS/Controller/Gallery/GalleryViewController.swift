//
//  GaleryViewController.swift
//  LANARS
//
//  Created by sashko on 27.02.2021.
//

import UIKit

class GalleryViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet var toolBar: UIToolbar!

    @IBOutlet var forwardButton: UIBarButtonItem!
    @IBOutlet var backButton: UIBarButtonItem!

    var indexPath: IndexPath?

    var imagesArray: [UIImage] = [
        UIImage(named: "1")!,
        UIImage(named: "2")!,
        UIImage(named: "3")!,
        UIImage(named: "4")!,
        UIImage(named: "5")!,
        UIImage(named: "6")!,
        UIImage(named: "7")!,
        UIImage(named: "8")!,
        UIImage(named: "9")!,
        UIImage(named: "10")!,
        UIImage(named: "11")!,
        UIImage(named: "12")!,
        UIImage(named: "13")!,
        UIImage(named: "14")!,
        UIImage(named: "15")!,
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        indexPath = [0, 0]
        backButton.isEnabled = false
    }

    @IBAction func previousPhoto(_ sender: Any) {
        forwardButton.isEnabled = true
        if indexPath == [0,1] {
            backButton.isEnabled = false
            collectionView.scrollToItem(at: IndexPath(item: indexPath!.item - 1, section: indexPath!.section), at: .centeredHorizontally, animated: true)
        } else {
            backButton.isEnabled = true
            collectionView.scrollToItem(at: IndexPath(item: indexPath!.item - 1, section: indexPath!.section), at: .centeredHorizontally, animated: true)
        }
    }

    @IBAction func nextPhoto(_ sender: Any) {
        backButton.isEnabled = true
        if indexPath == IndexPath(item: imagesArray.count - 2, section: 0) {
            forwardButton.isEnabled = false
            collectionView.scrollToItem(at: IndexPath(item: indexPath!.item + 1, section: indexPath!.section), at: .centeredHorizontally, animated: true)
        } else {
            forwardButton.isEnabled = true
            collectionView.scrollToItem(at: IndexPath(item: indexPath!.item + 1, section: indexPath!.section), at: .centeredHorizontally, animated: true)
        }
    }
}

extension GalleryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? GalleryCollectionViewCell
        cell?.image.image = imagesArray[indexPath.row]
        cell?.sizeToFit()

        return cell!
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        indexPath = collectionView.indexPathForItem(at: visiblePoint)
        if indexPath == [0,0] {
            backButton.isEnabled = false
            forwardButton.isEnabled = true
        } else {
            backButton.isEnabled = true
        }
        if indexPath == IndexPath(item: imagesArray.count - 1, section: 0) {
            forwardButton.isEnabled = false
            backButton.isEnabled = true
        } else {
            forwardButton.isEnabled = true
        }
    }
}
