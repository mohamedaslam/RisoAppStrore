//
//  BenifitsTableViewCell.swift
//  BFA
//
//  Created by Mohammed Aslam Shaik on 2022/8/9.
//  Copyright © 2022 Viable Labs. All rights reserved.
//

import UIKit

class BenifitsTableViewCell: UITableViewCell {
        var currentIndex: IndexPath?
        
        var reminderNameLab: UILabel = UILabel()
        var reminderDay: UILabel = UILabel()
        var benifitsTitleLab: UILabel = UILabel()
        var reminderSubTitleLab : UILabel = UILabel()
        var bgView: UIView = UIView()
        var iconContainerView: UIView = UIView()
        var iconImageView: UIImageView = UIImageView()

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
                make.height.equalTo(72 * AutoSizeScaleX)
                make.left.equalTo(self.contentView).offset(20 * AutoSizeScaleX)
                make.right.equalTo(self.contentView).offset(-20 * AutoSizeScaleX)
            }
            //

            
            let iconContainerView: UIView = UIView()
            iconContainerView.backgroundColor = .white
            iconContainerView.layer.cornerRadius = 25 * AutoSizeScaleX
            iconContainerView.layer.shadowColor = UIColor.black.cgColor
            iconContainerView.layer.shadowOffset = CGSize.zero
            iconContainerView.layer.shadowOpacity = 0.12
            iconContainerView.layer.shadowRadius = 3
            self.bgView.addSubview(iconContainerView)
            self.iconContainerView = iconContainerView
            iconContainerView.snp.makeConstraints { (make) in
                make.centerY.equalTo(self.bgView)
                make.height.width.equalTo(50 * AutoSizeScaleX)
                make.left.equalTo(self.bgView).offset(14 * AutoSizeScaleX)
            }
            
            let iconImageView: UIImageView = UIImageView()
            iconImageView.contentMode = .scaleAspectFit
            self.iconContainerView.addSubview(iconImageView)
            self.iconImageView = iconImageView
            iconImageView.snp.makeConstraints { (make) in
                make.centerY.centerX.equalTo(iconContainerView)
                make.height.width.equalTo(26 * AutoSizeScaleX)
            }
            
            let benifitsTitleLab: UILabel = UILabel()
            benifitsTitleLab.setContentHuggingPriority(.required, for: .horizontal)
            benifitsTitleLab.setContentCompressionResistancePriority(.required, for: .horizontal)
            benifitsTitleLab.textColor = UIColor(hexString: "#2B395C")
            benifitsTitleLab.textAlignment = .left
            benifitsTitleLab.text = "KINDERGARTEN"
            benifitsTitleLab.font = UIFont.appFont(ofSize: 17, weight: .regular)
            bgView.addSubview(benifitsTitleLab)
            benifitsTitleLab.snp.makeConstraints { (make) in
                make.left.equalTo(iconContainerView.snp_right).offset(16 * AutoSizeScaleX)
                make.centerY.height.equalTo(bgView)
                make.width.equalTo(200 * AutoSizeScaleX)
            }
            self.benifitsTitleLab = benifitsTitleLab
            
            let timeRightArrow: UIImageView = UIImageView()
            timeRightArrow.image = UIImage.init(named: "RightArrow")
            timeRightArrow.contentMode = .scaleAspectFit
            bgView.addSubview(timeRightArrow)
            timeRightArrow.snp.makeConstraints { (make) in
                make.right.equalTo(bgView).offset(-20 * AutoSizeScaleX)
                make.centerY.equalTo(bgView)
                make.height.equalTo(14 * AutoSizeScaleX)
                make.width.equalTo(8 * AutoSizeScaleX)
            }
        }
    }
