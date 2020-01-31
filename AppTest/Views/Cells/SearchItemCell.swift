//
//  SearchItemCell.swift
//  AppTest
//
//  Created by macvillanda on 29/01/2020.
//  Copyright © 2020 macvillanda. All rights reserved.
//

import UIKit
import Kingfisher

final class SearchItemCell: UITableViewCell, CellDownloadCancellable {

    fileprivate var imageTask: DownloadTask?
    
    fileprivate struct LayoutConstraints {
        static let margin = UIOffset(horizontal: 20, vertical: 10)
        static let elementSpace: CGFloat = 10
        static let imageSize = CGSize(width: 60, height: 60)
    }

    let lblTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .black
        view.font = UIFont.boldSystemFont(ofSize: 18)
        view.numberOfLines = 1
        return view
    }()
    
    let lblSubtitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .black
        view.font = UIFont.systemFont(ofSize: 14)
        view.numberOfLines = 1
        return view
    }()
    
    let lblAccessory: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .black
        view.font = UIFont.boldSystemFont(ofSize: 16)
        view.numberOfLines = 1
        return view
    }()
    
    let downloadableImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setUp() {
        accessoryType = .disclosureIndicator
        contentView.addSubview(lblTitle)
        contentView.addSubview(lblSubtitle)
        contentView.addSubview(lblAccessory)
        contentView.addSubview(downloadableImage)
        let botConst = downloadableImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                                 constant: -LayoutConstraints.margin.vertical)
        botConst.priority = UILayoutPriority(rawValue: 800)
        let trailConst = lblAccessory.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                                constant: -LayoutConstraints.margin.horizontal)
        trailConst.priority = UILayoutPriority(rawValue: 800)
        lblAccessory.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 999), for: .horizontal)
        lblAccessory.setContentHuggingPriority(UILayoutPriority(rawValue: 999), for: .horizontal)
        NSLayoutConstraint.activate([
            downloadableImage.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                   constant: LayoutConstraints.margin.vertical),
            downloadableImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                       constant: LayoutConstraints.margin.horizontal),
            botConst,
            downloadableImage.widthAnchor.constraint(equalToConstant: LayoutConstraints.imageSize.width),
            downloadableImage.heightAnchor.constraint(equalToConstant: LayoutConstraints.imageSize.height),
            
            lblTitle.leadingAnchor.constraint(equalTo: downloadableImage.trailingAnchor, constant: LayoutConstraints.elementSpace),
            lblTitle.bottomAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            lblSubtitle.topAnchor.constraint(equalTo: lblTitle.bottomAnchor),
            lblSubtitle.leadingAnchor.constraint(equalTo: lblTitle.leadingAnchor),
            
            trailConst,
            lblAccessory.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            lblAccessory.leadingAnchor.constraint(equalTo: lblTitle.trailingAnchor,
                                                  constant: LayoutConstraints.elementSpace)
        ])
    }
    
    func setImage(url: String) {
        downloadableImage.kf.cancelDownloadTask()
        imageTask = downloadableImage.loadImageFrom(url: url)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageTask?.cancel()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
