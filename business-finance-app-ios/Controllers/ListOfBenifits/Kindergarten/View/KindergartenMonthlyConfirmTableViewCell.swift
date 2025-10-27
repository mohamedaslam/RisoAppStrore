//
//  KindergartenMonthlyConfirmTableViewCell.swift
//  BFA
//
//  Created by Mohammed Aslam Shaik on 2022/9/17.
//  Copyright © 2022 Viable Labs. All rights reserved.
//

import UIKit

class KindergartenMonthlyConfirmTableViewCell: UITableViewCell {
    var currentIndex: IndexPath?
    var inactiveStatusLab: UILabel = UILabel()
    var childNameLab: UILabel = UILabel()
    var kindergartenNameLab: UILabel = UILabel()
    var kindergartenAddressLab : UILabel = UILabel()
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
        self.contentView.addSubview(bgView)
        self.bgView = bgView
        bgView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView)
            make.height.equalTo(118 * AutoSizeScaleX)
            make.left.equalTo(self.contentView).offset(8 * AutoSizeScaleX)
            make.right.equalTo(self.contentView).offset(-8 * AutoSizeScaleX)
        }
             
        let inactiveStatusLab: UILabel = UILabel()
        inactiveStatusLab.textAlignment = .left
        inactiveStatusLab.text = "Inaktiv"
        inactiveStatusLab.lineBreakMode = .byWordWrapping
        inactiveStatusLab.font = UIFont.appFont(ofSize: 14 * AutoSizeScaleX, weight: .regular)
        inactiveStatusLab.textColor = .lightGray
        bgView.addSubview(inactiveStatusLab)
        inactiveStatusLab.snp.makeConstraints { (make) in
            make.right.equalTo(bgView).offset(-4 * AutoSizeScaleX)
            make.width.equalTo(54 * AutoSizeScaleX)
            make.centerY.equalTo(bgView)
            make.height.equalTo(40 * AutoSizeScaleX)
        }
        self.inactiveStatusLab = inactiveStatusLab
        
        let childNameLab: UILabel = UILabel()
        childNameLab.textAlignment = .left
        childNameLab.numberOfLines = 0
        childNameLab.lineBreakMode = .byWordWrapping
        childNameLab.text = ""
        childNameLab.font = UIFont.appFont(ofSize: 18, weight: .bold)
        childNameLab.textColor = UIColor(hexString: "#222B45")
        bgView.addSubview(childNameLab)
        childNameLab.snp.makeConstraints { (make) in
            make.left.equalTo(bgView).offset(16 * AutoSizeScaleX)
            make.right.equalTo(inactiveStatusLab.snp_leftMargin)
            make.top.equalTo(bgView).offset(8 * AutoSizeScaleX)
            make.height.equalTo(30 * AutoSizeScaleX)
        }
        self.childNameLab = childNameLab
        
        let kindergartenNameLab: UILabel = UILabel()
        kindergartenNameLab.textColor = UIColor(hexString: "#2B395C")
        kindergartenNameLab.textAlignment = .left
        kindergartenNameLab.lineBreakMode = .byWordWrapping
        kindergartenNameLab.numberOfLines = 0
        kindergartenNameLab.text = " "
        kindergartenNameLab.font = UIFont.appFont(ofSize: 14 * AutoSizeScaleX, weight: .regular)
        bgView.addSubview(kindergartenNameLab)
        kindergartenNameLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(childNameLab)
            make.top.equalTo(childNameLab.snp_bottomMargin).offset(4 * AutoSizeScaleX)
            make.height.equalTo(36 * AutoSizeScaleX)
        }
        self.kindergartenNameLab = kindergartenNameLab
        
        let kindergartenAddressLab: UILabel = UILabel()
        kindergartenAddressLab.textColor =  UIColor(hexString: "#2B395C")
        kindergartenAddressLab.textAlignment = .left
        kindergartenAddressLab.lineBreakMode = .byWordWrapping
        kindergartenAddressLab.numberOfLines = 0
        kindergartenAddressLab.text = " "
        kindergartenAddressLab.font = UIFont.appFont(ofSize: 14 * AutoSizeScaleX, weight: .regular)
        bgView.addSubview(kindergartenAddressLab)
        kindergartenAddressLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(kindergartenNameLab)
            make.top.equalTo(kindergartenNameLab.snp_bottomMargin).offset(4 * AutoSizeScaleX)
            make.height.equalTo(42 * AutoSizeScaleX)
        }
        self.kindergartenAddressLab = kindergartenAddressLab
        
        let separateLine: UILabel = UILabel()
        separateLine.backgroundColor = .lightGray
        bgView.addSubview(separateLine)
        separateLine.snp.makeConstraints { (make) in
            make.right.equalTo(bgView)
            make.left.equalTo(bgView).offset(16 * AutoSizeScaleX)
            make.bottom.equalTo(bgView).offset(-2 * AutoSizeScaleX)
            make.height.equalTo(0 * AutoSizeScaleX)
        }
    }
}
