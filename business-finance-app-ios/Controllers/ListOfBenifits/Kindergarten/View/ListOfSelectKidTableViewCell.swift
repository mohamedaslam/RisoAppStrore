//
//  ListOfSelectKidTableViewCell.swift
//  business-finance-app-ios
//
//  Created by Mohammed Aslam on 2022/12/1.
//  Copyright © 2022 Viable Labs. All rights reserved.
//

import UIKit

class ListOfSelectKidTableViewCell: UITableViewCell{
    var currentIndex: IndexPath?
    
    var childNameLab: UILabel = UILabel()
    var kindergartenNameLab: UILabel = UILabel()
    var inactiveStatusLab: UILabel = UILabel()
    var bgView: UIView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = .white
        
        configView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configView() {
        
        let bgView: UIView = UIView()
        bgView.backgroundColor = .white
        bgView.layer.cornerRadius = 2 * AutoSizeScaleX
        bgView.layer.shadowColor = UIColor.black.cgColor
        bgView.layer.shadowOffset = CGSize.zero
        bgView.layer.shadowOpacity = 0.12
        bgView.layer.shadowRadius = 3
        self.contentView.addSubview(bgView)
        self.bgView = bgView
        bgView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView)
            make.height.equalTo(80 * AutoSizeScaleX)
            make.left.equalTo(self.contentView).offset(20 * AutoSizeScaleX)
            make.right.equalTo(self.contentView).offset(-20 * AutoSizeScaleX)
        }
                     
        let inactiveStatusLab: UILabel = UILabel()
        inactiveStatusLab.textAlignment = .left
        inactiveStatusLab.text = "Inaktiv"
        inactiveStatusLab.lineBreakMode = .byWordWrapping
        inactiveStatusLab.font = UIFont.appFont(ofSize: 14 * AutoSizeScaleX, weight: .regular)
        inactiveStatusLab.textColor = .lightGray
        bgView.addSubview(inactiveStatusLab)
        inactiveStatusLab.snp.makeConstraints { (make) in
            make.right.equalTo(bgView).offset(-10 * AutoSizeScaleX)
            make.width.equalTo(54 * AutoSizeScaleX)
            make.centerY.equalTo(bgView)
            make.height.equalTo(40 * AutoSizeScaleX)
        }
        self.inactiveStatusLab = inactiveStatusLab
        
        let childNameLab: UILabel = UILabel()
        childNameLab.textAlignment = .left
        childNameLab.text = ""
        childNameLab.lineBreakMode = .byWordWrapping
        childNameLab.numberOfLines = 0
        childNameLab.font = UIFont.appFont(ofSize: 17, weight: .bold)
        childNameLab.textColor = UIColor(hexString: "#2B395C")
        bgView.addSubview(childNameLab)
        childNameLab.snp.makeConstraints { (make) in
            make.left.equalTo(bgView).offset(16 * AutoSizeScaleX)
            make.right.equalTo(inactiveStatusLab.snp_left).offset(-4 * AutoSizeScaleX)
            make.top.equalTo(bgView).offset(4 * AutoSizeScaleX)
            make.height.equalTo(40 * AutoSizeScaleX)

        }
        self.childNameLab = childNameLab
        
        let kindergartenNameLab: UILabel = UILabel()
        kindergartenNameLab.setContentHuggingPriority(.required, for: .horizontal)
        kindergartenNameLab.setContentCompressionResistancePriority(.required, for: .horizontal)
        kindergartenNameLab.textColor = .lightGray
        kindergartenNameLab.textAlignment = .left
        kindergartenNameLab.lineBreakMode = .byWordWrapping
        kindergartenNameLab.numberOfLines = 0
        kindergartenNameLab.text = ""
        kindergartenNameLab.font = UIFont.appFont(ofSize: 12 * AutoSizeScaleX, weight: .regular)
        bgView.addSubview(kindergartenNameLab)
        kindergartenNameLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(childNameLab)
            make.top.equalTo(childNameLab.snp_bottomMargin).offset(4 * AutoSizeScaleX)
            make.height.equalTo(40 * AutoSizeScaleX)
        }
        self.kindergartenNameLab = kindergartenNameLab
                
    }
    

}
