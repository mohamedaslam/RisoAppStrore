//
//  HomeProductListCollectionViewCell.swift
//  business-finance-app-ios
//
//  Created by Mohammed Aslam Shaik on 2022/11/14.
//  Copyright © 2022 Viable Labs. All rights reserved.
//

import UIKit

class HomeProductListCollectionViewCell: UICollectionViewCell {
    public var nameLab: UILabel = UILabel()
    public var bgView: UIView = UIView()
    public var totalAmountLab: UILabel = UILabel()

    let spaceBtnCell = 4 * AutoSizeScaleX
    
    override init(frame: CGRect) {
        super.init(frame: frame)        
        configView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configView() {
        let bgView: UIView = UIView()
        bgView.layer.cornerRadius = 6 * AutoSizeScaleX
        bgView.layer.borderWidth = 1 * AutoSizeScaleX
        bgView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.addSubview(bgView)
        self.bgView = bgView
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(spaceBtnCell * AutoSizeScaleX)
            make.bottom.equalTo(-spaceBtnCell * AutoSizeScaleX)
            make.left.equalTo(self.contentView).offset(spaceBtnCell * AutoSizeScaleX)
            make.right.equalTo(self.contentView).offset(-spaceBtnCell * AutoSizeScaleX)
        }
        
        let nameLab: UILabel = UILabel()
        nameLab.textColor = .white
        nameLab.textAlignment = .center
        nameLab.font = UIFont.appFont(ofSize: 14, weight: .regular)
        bgView.addSubview(nameLab)
        nameLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(bgView)
            make.top.equalTo(bgView).offset(4 * AutoSizeScaleX)
            make.height.equalTo(18 * AutoSizeScaleX)
        }
        self.nameLab = nameLab
        
        let totalAmountLab: UILabel = UILabel()
        totalAmountLab.textColor = .white
        totalAmountLab.textAlignment = .center
        totalAmountLab.font = UIFont.appFont(ofSize: 12, weight: .regular)
        bgView.addSubview(totalAmountLab)
        totalAmountLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(bgView)
            make.top.equalTo(nameLab.snp_bottom).offset(2 * AutoSizeScaleX)
            make.height.equalTo(16 * AutoSizeScaleX)
        }
        self.totalAmountLab = totalAmountLab
        
    }
}
