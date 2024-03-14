//
//  CardCell.swift
//  MTGCardAppSmallTask
//
//  Created by pavan yadav on 14/03/24.
//

import UIKit

class CardCell: UICollectionViewCell {
    let viewContriner = UIView()
    let topLabel = UILabel()
    let cardImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        applyConstraints()
    }
    private func addViews(){
        addSubview(viewContriner)
        
        topLabel.textColor = .black
        topLabel.font = UIFont.systemFont(ofSize: 10)
        viewContriner.addSubview(topLabel)
        
        cardImage.sizeToFit()
        viewContriner.addSubview(cardImage)
    }

    private func applyConstraints() {
        viewContriner.translatesAutoresizingMaskIntoConstraints = false
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        cardImage.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // view container constraints
            viewContriner.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            viewContriner.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            viewContriner.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            viewContriner.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            // top label  constraints
            topLabel.topAnchor.constraint(equalTo: viewContriner.topAnchor, constant:2),
            topLabel.centerXAnchor.constraint(equalTo: viewContriner.centerXAnchor),
            topLabel.heightAnchor.constraint(equalToConstant: 10),
            // card image  constraints
            cardImage.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant:5),
            cardImage.leadingAnchor.constraint(equalTo: viewContriner.leadingAnchor),
            cardImage.trailingAnchor.constraint(equalTo: viewContriner.trailingAnchor),
            cardImage.bottomAnchor.constraint(equalTo: viewContriner.bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
