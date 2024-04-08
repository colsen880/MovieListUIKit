//
//  MovieInfoTableViewCell.swift
//  Movie List
//
//  Created by Chad Olsen on 9/25/23.
//  Copyright © 2023 colsen. All rights reserved.
//

import UIKit

class MovieInfoTableViewCell: UITableViewCell {
    let title = UILabel()
    let poster = UIImageView()
    let subtitle = UILabel()
    let movieDescription = UILabel()
    let button = UIButton()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let horizontalStack = UIStackView(frame: .zero)
        horizontalStack.axis = .horizontal
        horizontalStack.spacing = 10
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontalStack)
        
        horizontalStack.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        horizontalStack.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        horizontalStack.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        horizontalStack.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        poster.backgroundColor = .purple
        
        poster.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
        poster.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
        horizontalStack.addArrangedSubview(poster)
        
        let verticalStack = UIStackView(frame: .zero)
        verticalStack.axis = .vertical
        verticalStack.alignment = .leading
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        horizontalStack.addArrangedSubview(verticalStack)

        verticalStack.addArrangedSubview(title)
        
        subtitle.font = UIFont.systemFont(ofSize: 8)
        verticalStack.addArrangedSubview(subtitle)
        
        movieDescription.font = UIFont.systemFont(ofSize: 11)
        movieDescription.numberOfLines = 3
        verticalStack.addArrangedSubview(movieDescription)
        
        horizontalStack.addArrangedSubview(button)
        button.backgroundColor = .systemGray6
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.setImage(UIImage(systemName: "star.fill"), for: .selected)
        button.isSelected = false
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
