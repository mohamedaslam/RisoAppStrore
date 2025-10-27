//
//  VendorsListsCollectionViewCell.swift
//  business-finance-app-ios
//
//  Created by Mohammed Aslam on 2023/1/15.
//  Copyright © 2023 Viable Labs. All rights reserved.
//

import UIKit

class VendorsListsCollectionViewCell: UICollectionViewCell {
    public var vouchersCountLab: UILabel = UILabel()
    public var bgView: UIView = UIView()
    public var totalAmountLab: UILabel = UILabel()
    public var logoImageView : UIImageView = UIImageView()
    let spaceBtnCell = 2 * AutoSizeScaleX
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       // self.contentView.backgroundColor = UIColor.App.TableView.grayBackground
        
        configView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configView() {
        let bgView: UIView = UIView()
        bgView.backgroundColor = UIColor.white
        bgView.layer.cornerRadius = 4 * AutoSizeScaleX
        bgView.layer.borderWidth = 1 * AutoSizeScaleX
        bgView.layer.borderColor = UIColor.clear.cgColor
        bgView.layer.shadowColor = UIColor.black.cgColor
        bgView.layer.shadowOffset = CGSize.zero
        bgView.layer.shadowOpacity = 0.12
        bgView.layer.shadowRadius = 3
        self.contentView.addSubview(bgView)
        self.bgView = bgView
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(spaceBtnCell * AutoSizeScaleX)
            make.bottom.equalTo(-spaceBtnCell * AutoSizeScaleX)
            make.left.equalTo(self.contentView).offset(spaceBtnCell * AutoSizeScaleX)
            make.right.equalTo(self.contentView).offset(-spaceBtnCell * AutoSizeScaleX)
        }
        
        let logoImg: UIImageView = UIImageView()
        logoImg.image = UIImage.init(named: "")
        logoImg.contentMode = .scaleAspectFit
        self.bgView.addSubview(logoImg)
        self.logoImageView = logoImg
        logoImg.snp.makeConstraints { (make) in
            make.centerY.centerX.equalTo(self.bgView)
            make.width.equalTo(70 * AutoSizeScaleX)
            make.height.equalTo(52 * AutoSizeScaleX)
        }
        
        let vouchersCountLab: UILabel = UILabel()
        vouchersCountLab.textColor = UIColor.init(hexString: "#2B395C")
        vouchersCountLab.textAlignment = .center
        vouchersCountLab.font = UIFont.appFont(ofSize: 14, weight: .regular)
        bgView.addSubview(vouchersCountLab)
        vouchersCountLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(bgView)
            make.bottom.equalTo(bgView).offset(-4 * AutoSizeScaleX)
            make.height.equalTo(18 * AutoSizeScaleX)
        }
        self.vouchersCountLab = vouchersCountLab
        
    }
}
