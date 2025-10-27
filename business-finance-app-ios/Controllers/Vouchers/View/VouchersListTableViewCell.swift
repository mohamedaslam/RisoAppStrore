//
//  VouchersListTableViewCell.swift
//  business-finance-app-ios
//
//  Created by Mohammed Aslam on 2023/1/14.
//  Copyright © 2023 Viable Labs. All rights reserved.
//

import UIKit

class VouchersListTableViewCell: UITableViewCell{
    var currentIndex: IndexPath?
    
    var reminderNameLab: UILabel = UILabel()
    var reminderDay: UILabel = UILabel()
    var vouchersTitleLab: UILabel = UILabel()
    var vouchersSubTitleLab: UILabel = UILabel()
    var reminderSubTitleLab : UILabel = UILabel()
    var bgView: UIView = UIView()
    var iconContainerView: UIView = UIView()
    var iconImageView: UIImageView = UIImageView()
    var deleteBtn : UIButton = UIButton()
    var orderedLab: UILabel = UILabel()
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
        bgView.layer.shadowOpacity = 0.3
        bgView.layer.shadowRadius = 6
        self.contentView.addSubview(bgView)
        self.bgView = bgView
        bgView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView)
            make.height.equalTo(94 * AutoSizeScaleX)
            make.left.equalTo(self.contentView).offset(20 * AutoSizeScaleX)
            make.right.equalTo(self.contentView).offset(-20 * AutoSizeScaleX)
        }
        //

        
        let iconContainerView: UIView = UIView()
        iconContainerView.backgroundColor = .white
        self.bgView.addSubview(iconContainerView)
        self.iconContainerView = iconContainerView
        iconContainerView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.bgView)
            make.height.equalTo(40 * AutoSizeScaleX)
            make.width.equalTo(80 * AutoSizeScaleX)
            make.left.equalTo(self.bgView).offset(14 * AutoSizeScaleX)
        }
        
        let iconImageView: UIImageView = UIImageView()
        iconImageView.contentMode = .scaleAspectFit
        self.iconContainerView.addSubview(iconImageView)
        self.iconImageView = iconImageView
        iconImageView.snp.makeConstraints { (make) in
            make.centerY.centerX.equalTo(iconContainerView)
            make.height.equalTo(40 * AutoSizeScaleX)
            make.width.equalTo(74 * AutoSizeScaleX)
        }
        
        let separateLineImg: UIImageView = UIImageView()
        separateLineImg.image = UIImage.init(named: "listdots")
        separateLineImg.contentMode = .scaleAspectFit
        bgView.addSubview(separateLineImg)
        separateLineImg.snp.makeConstraints { (make) in
            make.left.equalTo(iconContainerView.snp_right).offset(10 * AutoSizeScaleX)
            make.centerY.equalTo(bgView)
            make.height.equalTo(90 * AutoSizeScaleX)
            make.width.equalTo(6 * AutoSizeScaleX)
        }
        
        let vouchersTitleLab: UILabel = UILabel()
        vouchersTitleLab.setContentHuggingPriority(.required, for: .horizontal)
        vouchersTitleLab.setContentCompressionResistancePriority(.required, for: .horizontal)
        vouchersTitleLab.textColor = UIColor(hexString: "#2B395C")
        vouchersTitleLab.textAlignment = .left
        vouchersTitleLab.text = ""
        vouchersTitleLab.font = UIFont.appFont(ofSize: 20, weight: .regular)
        bgView.addSubview(vouchersTitleLab)
        vouchersTitleLab.snp.makeConstraints { (make) in
            make.left.equalTo(separateLineImg.snp_right).offset(10 * AutoSizeScaleX)
            make.height.equalTo(26 * AutoSizeScaleX)
            make.bottom.equalTo(bgView.snp_centerY).offset(4 * AutoSizeScaleX)
            make.width.equalTo(200 * AutoSizeScaleX)
        }
        self.vouchersTitleLab = vouchersTitleLab
        
        let vouchersSubTitleLab: UILabel = UILabel()
        vouchersSubTitleLab.setContentHuggingPriority(.required, for: .horizontal)
        vouchersSubTitleLab.setContentCompressionResistancePriority(.required, for: .horizontal)
        vouchersSubTitleLab.textColor = UIColor.lightGray
        vouchersSubTitleLab.textAlignment = .left
        vouchersSubTitleLab.text = "Online"
        vouchersSubTitleLab.font = UIFont.appFont(ofSize: 14, weight: .regular)
        bgView.addSubview(vouchersSubTitleLab)
        vouchersSubTitleLab.snp.makeConstraints { (make) in
            make.left.equalTo(vouchersTitleLab)
            make.height.equalTo(24 * AutoSizeScaleX)
            make.width.equalTo(200 * AutoSizeScaleX)
            make.top.equalTo(vouchersTitleLab.snp_bottom).offset(2 * AutoSizeScaleX)
        }
        self.vouchersSubTitleLab = vouchersSubTitleLab
        
        let orderedLab: UILabel = UILabel()
        orderedLab.setContentHuggingPriority(.required, for: .horizontal)
        orderedLab.setContentCompressionResistancePriority(.required, for: .horizontal)
        orderedLab.textColor = UIColor(hexString: "#3868F6")
        orderedLab.textAlignment = .right
        orderedLab.text = ""
        orderedLab.isHidden = true
        orderedLab.font = UIFont.appFont(ofSize: 14, weight: .regular)
        bgView.addSubview(orderedLab)
        self.orderedLab = orderedLab
        orderedLab.snp.makeConstraints { (make) in
            make.right.equalTo(bgView).offset(-12 * AutoSizeScaleX)
            make.height.equalTo(24 * AutoSizeScaleX)
            make.width.equalTo(200 * AutoSizeScaleX)
            make.top.equalTo(bgView).offset(6 * AutoSizeScaleX)
        }
        self.vouchersSubTitleLab = vouchersSubTitleLab
        
        let deleteBtn: UIButton = UIButton(type: .custom)
        deleteBtn.layer.cornerRadius = 21 * AutoSizeScaleX
        deleteBtn.backgroundColor = UIColor(hexString: "#3868F6")
        deleteBtn.setImage(UIImage(named: "deleteV"), for: .normal)
        deleteBtn.isHidden = true
        bgView.addSubview(deleteBtn)
        self.deleteBtn = deleteBtn
        deleteBtn.snp.makeConstraints { (make) in
            make.right.equalTo(bgView).offset(-10 * AutoSizeScaleX)
            make.centerY.equalTo(bgView)
            make.height.width.equalTo(42 * AutoSizeScaleX)
        }
    }
}
