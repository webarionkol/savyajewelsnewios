//
//  VCCells.swift
//  savyaApp
//
//  Created by Yash on 6/17/19.
//  Copyright © 2019 Yash Rathod. All rights reserved.
//

import Foundation
import UIKit
import DLRadioButton
//import VerticalSteppedSlider
import ZoomImageView
import SimpleCheckbox
import AVFoundation
import Material
import TTRangeSlider

class profileCell:UITableViewCell {
    
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var lbl1:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}


class addrCell1:UITableViewCell {
    
    @IBOutlet weak var img:UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

class addrCell2:UITableViewCell {
    
    @IBOutlet weak var fnameTxt:UITextField!
    @IBOutlet weak var lnameTxt:UITextField!
    @IBOutlet weak var designationBtn:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class addrCell3:UITableViewCell {
    
    @IBOutlet weak var countryTxt:UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
class addrCell4:UITableViewCell {
    
    @IBOutlet weak var addrTxt:UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.addrTxt.layer.borderColor = UIColor.lightGray.cgColor
        self.addrTxt.layer.borderWidth = 1
    }
}
class addrCell5:UITableViewCell {
    
    @IBOutlet weak var pincodeTxt:UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
class addrCell6:UITableViewCell {
    
    @IBOutlet weak var cityTxt:UITextField!
    @IBOutlet weak var regionTxt:UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
class addrCell7:UITableViewCell {
    
    @IBOutlet weak var mobileTxt:UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

class addrCell8:UITableViewCell {
    
    @IBOutlet weak var saveBtn:UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.saveBtn.layer.cornerRadius = 10
        self.saveBtn.clipsToBounds = true
    }
}


class sideCell:UITableViewCell {
    
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var lbl1:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

class sideBottomCell:UITableViewCell {
    
    @IBOutlet weak var btn1:UIButton!
    @IBOutlet weak var btn2:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.btn1.layer.borderColor = UIColor.lightGray.cgColor
        self.btn2.layer.borderColor = UIColor.lightGray.cgColor
        
        self.btn2.layer.borderWidth = 1
        self.btn1.layer.borderWidth = 1
    }
}

class sideBottomCell1:UITableViewCell {
    
    @IBOutlet weak var btn1:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.btn1.layer.borderColor = UIColor.lightGray.cgColor
        
        self.btn1.layer.borderWidth = 1
        
    }
}
class exclusive_bannerCell:UICollectionViewCell {
    
    @IBOutlet weak var img:UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

class subcategoryCell:UICollectionViewCell {
    
    @IBOutlet weak var lbl1:UILabel!
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var view1:UIView!
    @IBOutlet weak var viewShadow:UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

class notificationCell:UITableViewCell {
    
    @IBOutlet weak var dateLbl:UILabel!
    @IBOutlet weak var dateView:UIView!
    @IBOutlet weak var timeLbl:UILabel!
    @IBOutlet weak var contentLbl:UILabel!
    @IBOutlet weak var mainView:UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

class unlimited_banner:UITableViewCell {
    
    @IBOutlet weak var titleLbl:UILabel!
    @IBOutlet weak var subtitlLbl:UILabel!
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var titleLbl1:UILabel!
    @IBOutlet weak var subtitleLbl1:UILabel!
    @IBOutlet weak var designLbl:UILabel!
    @IBOutlet weak var desginView:UIView!
    @IBOutlet weak var preiceView:UIView!
    @IBOutlet weak var priceLbl:UILabel!
    @IBOutlet weak var view1:UIView!
    @IBOutlet weak var btn1:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

class eventsCell:UITableViewCell {
    
    @IBOutlet weak var dateLbl:UILabel!
    @IBOutlet weak var eventName:UILabel!
    @IBOutlet weak var eventypeLbl:UILabel!
    @IBOutlet weak var timeLbl:UILabel!
    @IBOutlet weak var addrLbl:UILabel!
    @IBOutlet weak var topView:UIView!
    @IBOutlet weak var bottomView:UIView!
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var viewCorner:UIView!
    @IBOutlet weak var viewShadow:UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class eventsCellCollection:UICollectionViewCell {
    
    @IBOutlet weak var dateLbl:UILabel!
    @IBOutlet weak var eventName:UILabel!
    @IBOutlet weak var eventypeLbl:UILabel!
    @IBOutlet weak var timeLbl:UILabel!
    @IBOutlet weak var addrLbl:UILabel!
    @IBOutlet weak var topView:UIView!
    @IBOutlet weak var bottomView:UIView!
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var viewCorner:UIView!
    @IBOutlet weak var viewShadow:UIView!
    @IBOutlet weak var registerBtn:UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class productCell:UICollectionViewCell {
    
    @IBOutlet weak var view1:UIView!
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var newView:UIView!
    @IBOutlet weak var favButton:UIButton!
    @IBOutlet weak var originalPriceLbl:UILabel!
    @IBOutlet weak var offerPrice:UILabel!
    @IBOutlet weak var btn1:UIButton!
    @IBOutlet weak var shadowView:UIView!
    @IBOutlet weak var diamondLbl:UILabel!
    @IBOutlet weak var ctLbl:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class contactusCell:UITableViewCell {
    
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var lbl:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class wishlistCell:UITableViewCell {
    
    @IBOutlet weak var viewCorner:UIView!
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var namelbl:UILabel!
    @IBOutlet weak var priceLbl:UILabel!
    @IBOutlet weak var deleteBtn:UIButton!
    @IBOutlet weak var cartBtn:UIButton!
    @IBOutlet weak var viewShadow:UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class liverateHeadCell:UITableViewCell {
    
    @IBOutlet weak var lbl1:UILabel!
    @IBOutlet weak var lbl2:UILabel!
    @IBOutlet weak var lbl3:UILabel!
    @IBOutlet weak var lbl4:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

class liverateCell:UITableViewCell {
    
    @IBOutlet weak var symbolLbl:UILabel!
    @IBOutlet weak var lowLbl:UILabel!
    @IBOutlet weak var highLbl:UILabel!
    @IBOutlet weak var askLbl:UILabel!
    @IBOutlet weak var bidLbl:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class addressCellList:UITableViewCell {
    
    @IBOutlet weak var txt1:UITextView!
    @IBOutlet weak var btn1:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

class addressCellEmpty:UITableViewCell {
    
    @IBOutlet weak var img:UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

class subSubCell:UITableViewCell {
    
    @IBOutlet weak var btn:UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class emptyCell:UITableViewCell {
    
    @IBOutlet weak var img:UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}



//MARK: Product Details Cell
class productSizeCell:UITableViewCell {
    
    @IBOutlet weak var btnSize:UIButton!
    @IBOutlet weak var lblTitle:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

class productColorCell:UITableViewCell {
    
    @IBOutlet weak var roseBtn:UIButton!
    @IBOutlet weak var goldBtn:UIButton!
    @IBOutlet weak var whiteBtn:UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
class productMetalCell:UITableViewCell {
    
    @IBOutlet weak var k8Btn:UIButton!
    @IBOutlet weak var k12Btn:UIButton!
    @IBOutlet weak var k16Btn:UIButton!
    @IBOutlet weak var k18Btn:UIButton!
    @IBOutlet weak var productCodeLbl:UILabel!
   
    @IBOutlet weak var goldWeightLbl:UILabel!
    @IBOutlet weak var goldRateTitleLbl:UILabel!
    @IBOutlet weak var goldRateLbl:UILabel!
    @IBOutlet weak var totalLbl:UILabel!
    
    @IBOutlet weak var wastageTitleLbl:UILabel!
    @IBOutlet weak var goldFineWeightitleLbl:UILabel!
    @IBOutlet weak var wastageLbl:UILabel!
    @IBOutlet weak var goldFineWeightLbl:UILabel!
    @IBOutlet weak var goldTotalLbl:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

class productDiamondCell:UITableViewCell {
    
    @IBOutlet weak var d1Btn:UIButton!
    @IBOutlet weak var d2Btn:UIButton!
    @IBOutlet weak var d3Btn:UIButton!
    @IBOutlet weak var d4Btn:UIButton!
    @IBOutlet weak var d5Btn:UIButton!
    
    @IBOutlet weak var d1Btnc:UIButton!
    @IBOutlet weak var d2Btnc:UIButton!
    @IBOutlet weak var d3Btnc:UIButton!
    @IBOutlet weak var d4Btnc:UIButton!
    @IBOutlet weak var d5Btnc:UIButton!
    @IBOutlet weak var d6BtnC: UIButton!
    
    @IBOutlet weak var diamondTypeBtn:UIButton!
    
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblWeight:UILabel!
    @IBOutlet weak var lblPrice:UILabel!
    @IBOutlet weak var lblNoDiamond:UILabel!
    @IBOutlet weak var lblDiamondTotal:UILabel!
    @IBOutlet weak var lblDiamondColorClarity:UILabel!
    
    @IBOutlet weak var viewColCla: UIView!
    @IBOutlet weak var viewDiaTotal: UIView!
    @IBOutlet weak var viewDiaNo: UIView!
    @IBOutlet weak var viewPrice: UIView!
    @IBOutlet weak var viewWeight: UIView!
    @IBOutlet weak var viewName: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class productDiamondCellCertified:UITableViewCell {
    
    @IBOutlet weak var d1Btn:UIButton!
    @IBOutlet weak var d2Btn:UIButton!
    @IBOutlet weak var d3Btn:UIButton!
    @IBOutlet weak var d4Btn:UIButton!
    @IBOutlet weak var d5Btn:UIButton!
    
    
    @IBOutlet weak var d1Btnc:UIButton!
    @IBOutlet weak var d2Btnc:UIButton!
    @IBOutlet weak var d3Btnc:UIButton!
    @IBOutlet weak var d4Btnc:UIButton!
    @IBOutlet weak var d5Btnc:UIButton!
    
    @IBOutlet weak var diamondTypeBtn:UIButton!
    
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblWeight:UILabel!
    @IBOutlet weak var lblPrice:UILabel!
    @IBOutlet weak var lblNoDiamond:UILabel!
    @IBOutlet weak var lblCertificateCharges:UILabel!
    @IBOutlet weak var lblTotalCertificateCharges:UILabel!
    @IBOutlet weak var lblDiamondTotal:UILabel!
    @IBOutlet weak var lblDiamondColorClarity:UILabel!
    
    @IBOutlet weak var viewName: UIView!
    @IBOutlet weak var viewWeight: UIView!
    @IBOutlet weak var viewPrice: UIView!
    @IBOutlet weak var viewDiaNo: UIView!
    @IBOutlet weak var viewCertCharge: UIView!
    @IBOutlet weak var viewCertTotal: UIView!
    @IBOutlet weak var viewDiaTotal: UIView!
    @IBOutlet weak var viewColcla: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class productPlatinumCell:UITableViewCell {
    
    @IBOutlet weak var lblProdcutCode:UILabel!
    @IBOutlet weak var lblPlatinumPrice:UILabel!
    @IBOutlet weak var lblPlatinumWeight:UILabel!
    @IBOutlet weak var lblPlatinumPurity:UILabel!
    @IBOutlet weak var lblPlatinumWasteage:UILabel!
    @IBOutlet weak var lblPlatinumMakingCharge:UILabel!
    @IBOutlet weak var lblTotalMakingCharge:UILabel!
    @IBOutlet weak var lblPlatinumTotal:UILabel!
    
    @IBOutlet weak var viewastage: UIView!
    @IBOutlet weak var viewMakingCharge: UIView!
    @IBOutlet weak var viewFineGoldWeight: UIView!
    @IBOutlet weak var viewFineGoldRate: UIView!
    @IBOutlet weak var viewTotalMakingCharge: UIView!
    @IBOutlet weak var viewTotalAmount: UIView!
    @IBOutlet weak var viewNetGoldWeight: UIView!
    @IBOutlet weak var viewPurity: UIView!
    @IBOutlet weak var viewCode: UIView!
    @IBOutlet weak var viewPrice: UIView!
    
    @IBOutlet weak var viewWeigh: UIView!
    @IBOutlet weak var viewMaking: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
class productSilverCell:UITableViewCell {
    
    @IBOutlet weak var lblPurity: UILabel!
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var lblProductCode: UILabel!
    @IBOutlet weak var lblWeight:UILabel!
    @IBOutlet weak var lblSilverPrice:UILabel!
    @IBOutlet weak var lblSilverMakingCharge:UILabel!
    @IBOutlet weak var lblSilverTotal:UILabel!
    
    @IBOutlet weak var viewType: UIView!
    @IBOutlet weak var viewTotal: UIView!
    @IBOutlet weak var viewTotalMaking: UIView!
    @IBOutlet weak var viewMaking: UIView!
    @IBOutlet weak var viewPurity: UIView!
    @IBOutlet weak var viewWeight: UIView!
    @IBOutlet weak var viewRate: UIView!
    @IBOutlet weak var viewCode: UIView!
    
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    
    @IBOutlet weak var lblFineSilverRate: UILabel!
    @IBOutlet weak var viewFineSIlverRate: UIView!
    @IBOutlet weak var viewWastage: UIView!
    @IBOutlet weak var lblWastage: UILabel!
    @IBOutlet weak var viewFineSilverWeight: UIView!
    @IBOutlet weak var lblFineSilverWeight: UILabel!
    
    @IBOutlet weak var viewChargeType: UIView!
    @IBOutlet weak var lblChargeType: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
class productStoneCell:UITableViewCell {
    
    @IBOutlet weak var downArrow: UIImageView!
    @IBOutlet weak var viewTot: UIView!
    @IBOutlet weak var viewRate: UIView!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewWeight: UIView!
    @IBOutlet weak var btnStoneType:UIButton!
    @IBOutlet weak var lblNoOfStone:UILabel!
    @IBOutlet weak var lblStoneWeight:UILabel!
    @IBOutlet weak var lblStonePrice:UILabel!
    @IBOutlet weak var lblStoneTotal:UILabel!
    @IBOutlet weak var lblStoneMakingCharge:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

class productCertifiedByCell:UITableViewCell {
    
    @IBOutlet weak var img1:UIImageView!
    @IBOutlet weak var img2:UIImageView!
    @IBOutlet weak var img3:UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
class productManufactureByCell:UITableViewCell {
    
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var lbl1:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
class productOtherDetailsCell:UITableViewCell {
    
    @IBOutlet weak var txtDetails:UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

class productPriceCell:UITableViewCell {
    
    @IBOutlet weak var lblToTtitle: UILabel!
    @IBOutlet weak var lblTotalPrice:UILabel!
    @IBOutlet weak var lblGrossWe: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
class quantityCell:UITableViewCell {
    
    @IBOutlet weak var plusBtn:UIButton!
    @IBOutlet weak var minusBtn:UIButton!
    @IBOutlet weak var qtyLbl:UILabel!
    
}
class imgCell:UICollectionViewCell {
    
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var img:UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

class trendingProCell:UICollectionViewCell {
    
    @IBOutlet weak var ctlabel: UILabel!
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var lblname:UILabel!
    @IBOutlet weak var priceLbl:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

class cartInsideCell:UITableViewCell {
    
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl3: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
class codecell:UITableViewCell {
    
    @IBOutlet weak var lblCode: UILabel!
   
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class cartCell:UITableViewCell {
    
    @IBOutlet weak var tblInside: UITableView!
    @IBOutlet weak var stackheight: NSLayoutConstraint!
    @IBOutlet weak var view1:UIView!
    @IBOutlet weak var lblname:UILabel!
    @IBOutlet weak var goldLbl1:UILabel!
    @IBOutlet weak var goldLbl2:UILabel!
    @IBOutlet weak var goldLbl3:UILabel!
    @IBOutlet weak var diamondLbl1:UILabel!
    @IBOutlet weak var diamondLbl2:UILabel!
    @IBOutlet weak var diamondLbl3:UILabel!
    @IBOutlet weak var stoneLbl1:UILabel!
    @IBOutlet weak var stoneLbl2:UILabel!
    @IBOutlet weak var stoneLbl3:UILabel!
    @IBOutlet weak var priceLbl:UILabel!
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var btnminus:UIButton!
    @IBOutlet weak var btnPlus:UIButton!
    @IBOutlet weak var quantityLbl:UILabel!
    @IBOutlet weak var saveForLatterBtn:UIButton!
    @IBOutlet weak var removeBtn:UIButton!
    
    @IBOutlet weak var view11:UIView!
    @IBOutlet weak var view22:UIView!
    @IBOutlet weak var view33:UIView!
    @IBOutlet weak var view44: UIView!
    
    @IBOutlet weak var lblPlat1: UILabel!
    @IBOutlet weak var lblPlat2: UILabel!
    @IBOutlet weak var lblplat3: UILabel!
    @IBOutlet weak var btnEidt: UIButton!
    
    
    
    var arrData = [[String:Any]]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tblInside.dataSource = self
        tblInside.delegate = self
    }
    
    
}
extension cartCell : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tblInside.dequeueReusableCell(withIdentifier: "cartInsideCell") as! cartInsideCell
        
        
        cell.lbl1.text = arrData[indexPath.row]["one"] as! String
        cell.lbl2.text = arrData[indexPath.row]["two"] as! String
        cell.lbl3.text = "\(arrData[indexPath.row]["three"] as! String) g"
        
        cell.selectionStyle = .none
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 20
    }
}

class customerSayCell:UICollectionViewCell {
    
    @IBOutlet weak var imgCust:UIImageView!
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var product_img:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

class offersCell:UITableViewCell {
    
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var titleLbl:UILabel!
    @IBOutlet weak var descrlbl:UILabel!
    @IBOutlet weak var codeLbl:UILabel!
    @IBOutlet weak var valueLbl:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

class orderCell:UITableViewCell {
    
    @IBOutlet weak var view1:UIView!
    @IBOutlet weak var shadowView:UIView!
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var orideridLbl:UILabel!
    @IBOutlet weak var timeLbl:UILabel!
    @IBOutlet weak var totalAmountLbl:UILabel!
    @IBOutlet weak var countLbl:UILabel!
    @IBOutlet weak var dateLbl:UILabel!
    @IBOutlet weak var reorderBtn:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
class orderDetailCell:UITableViewCell {
    
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var nameLbl:UILabel!
    @IBOutlet weak var quantityLbl:UILabel!
    @IBOutlet weak var goldWeight:UILabel!
    @IBOutlet weak var amountlbl:UILabel!
    @IBOutlet weak var makingChargeLbl:UILabel!
    @IBOutlet weak var colorLbl:UILabel!
    @IBOutlet weak var sizeLbl:UILabel!
    @IBOutlet weak var stoneWeightLbl:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class checkoutAddrCell:UITableViewCell {
    
    @IBOutlet weak var nameLbl:UILabel!
    @IBOutlet weak var addrTxt:UITextView!
    @IBOutlet weak var btn1:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class checkoutLastCell:UITableViewCell {
    
    @IBOutlet weak var lblTotalPay: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblCGST: UILabel!
    @IBOutlet weak var lblSGST: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblTotalGrossWeight: UILabel!
    @IBOutlet weak var lblSurCharge: UILabel!
    @IBOutlet weak var lblDelCharge: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class checkoutFeedBackCell:UITableViewCell {
    
    @IBOutlet weak var txt1:UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

class orderSLiderCell:UITableViewCell {
    
    @IBOutlet weak var slider:UISlider!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

class orderCell1:UITableViewCell {
    
    @IBOutlet weak var lblOrderiD:UILabel!
    @IBOutlet weak var lblData:UILabel!
    @IBOutlet weak var lblAmount:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

class searchCell:UITableViewCell {
    
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var nameLbl:UILabel!
    @IBOutlet weak var productidLbl:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}


class liveRateCard:UICollectionViewCell {
    
    @IBOutlet weak var symbolLbl:UILabel!
    @IBOutlet weak var lowLbl:UILabel!
    @IBOutlet weak var highLbl:UILabel!
    @IBOutlet weak var lowLbl1:UILabel!
    @IBOutlet weak var highLbl1:UILabel!
    @IBOutlet weak var askLbl:UILabel!
    @IBOutlet weak var bidLbl:UILabel!
    @IBOutlet weak var askLbl1:UILabel!
    @IBOutlet weak var bidLbl1:UILabel!
    @IBOutlet weak var viewCard:UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class bannerImgCell:UICollectionViewCell {
    
    @IBOutlet weak var img:UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
class hintCell:UICollectionViewCell {
    
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var lbl1:UILabel!
    @IBOutlet weak var lbl2:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

class kycCell1:UITableViewCell {
    
    @IBOutlet weak var lbl1:UILabel!
    @IBOutlet weak var txt1:UITextField!
    @IBOutlet weak var btnUpload:UIButton!
    @IBOutlet weak var img1:UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

class kycCell2:UITableViewCell {
    
    
    @IBOutlet weak var btnUpload:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

class patnershipCell:UICollectionViewCell {
    
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var lbl1:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

//MARK: Filter Cell Menu
class filterMenuNameCell:UITableViewCell {
    
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var shadowView:UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
           
    }
}

class filterMenuValueCell:UITableViewCell {
    
    @IBOutlet weak var checkbox:Checkbox!
    @IBOutlet weak var lbl1:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
           
    }
}

class ProductFilterSliderCell:UITableViewCell {
    
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var descriptionLabel:UILabel!
    @IBOutlet weak var wightSlider:TTRangeSlider!
    
    override func awakeFromNib() {
        super.awakeFromNib()
           
    }
}


class editProfileCell1:UITableViewCell {
    
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var editBtn:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class editProfileCell2:UITableViewCell {
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblDescr:UILabel!
    @IBOutlet weak var btnVerify:UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

class editProfileCell3:UITableViewCell {
    
    @IBOutlet weak var txt1:TextField!
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

class kycCell:UITableViewCell {
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var uploadBtn:UIButton!
    @IBOutlet weak var lblTxt:UITextView!
    @IBOutlet weak var view1:UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

class wrongDocCell:UICollectionViewCell {
    
    @IBOutlet weak var img:UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
class bulliceCityCell:UICollectionViewCell {
    
    @IBOutlet weak var img:UIImageView!
    @IBOutlet weak var lbl1:UILabel!
}
class ShotTableViewCell: UITableViewCell, ASAutoPlayVideoLayerContainer {
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var shotImageView: UIImageView!
    var playerController: ASVideoPlayerController?
    var videoLayer: AVPlayerLayer = AVPlayerLayer()
    var videoURL: String? {
        didSet {
            if let videoURL = videoURL {
                ASVideoPlayerController.sharedVideoPlayer.setupVideoFor(url: videoURL)
            }
            videoLayer.isHidden = videoURL == nil
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        shotImageView.layer.cornerRadius = 5
        shotImageView.backgroundColor = UIColor.gray.withAlphaComponent(0.7)
        shotImageView.clipsToBounds = true
        shotImageView.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        shotImageView.layer.borderWidth = 0.5
        videoLayer.backgroundColor = UIColor.clear.cgColor
        videoLayer.videoGravity = AVLayerVideoGravity.resize
        shotImageView.layer.addSublayer(videoLayer)
        selectionStyle = .none
    }
    
    func configureCell(imageUrl: String?,
                       description: String,
                       videoUrl: String?) {
     //   self.descriptionLabel.text = description
        //self.shotImageView.imageURL = imageUrl
        self.videoURL = videoUrl
    }

    override func prepareForReuse() {
       // shotImageView.imageURL = nil
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let horizontalMargin: CGFloat = 20
        let width: CGFloat = bounds.size.width - horizontalMargin * 2
        let height: CGFloat = (width * 0.9).rounded(.up)
        videoLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
    }
    
    func visibleVideoHeight() -> CGFloat {
        let videoFrameInParentSuperView: CGRect? = self.superview?.superview?.convert(shotImageView.frame, from: shotImageView)
        guard let videoFrame = videoFrameInParentSuperView,
            let superViewFrame = superview?.frame else {
             return 0
        }
        let visibleVideoFrame = videoFrame.intersection(superViewFrame)
        return visibleVideoFrame.size.height
    }
}

class GoldDetailCell:UITableViewCell {
    
    @IBOutlet weak var lblMakingTitle: UILabel!
    @IBOutlet weak var producCodeLbl:UILabel!
    @IBOutlet weak var goldPurityLbl:UILabel!
    @IBOutlet weak var netGoldWeightLbl:UILabel!
    @IBOutlet weak var goldMakingChargeLbl:UILabel!
    @IBOutlet weak var fineGoldWeightlbl:UILabel!
    @IBOutlet weak var fineGoldRateLbl:UILabel!
    @IBOutlet weak var totalMakingChargelbl:UILabel!
    @IBOutlet weak var totalAmount:UILabel!
    
    @IBOutlet weak var lblWastage: UILabel!
    @IBOutlet weak var viewGoldWastage: UIView!
    @IBOutlet weak var k8Btn:UIButton!
    @IBOutlet weak var k12Btn:UIButton!
    @IBOutlet weak var k16Btn:UIButton!
    @IBOutlet weak var k18Btn:UIButton!
    @IBOutlet weak var viewMakingCharge: UIView!
    @IBOutlet weak var viewFineGoldWeight: UIView!
    @IBOutlet weak var viewFineGoldRate: UIView!
    @IBOutlet weak var viewTotalMakingCharge: UIView!
    @IBOutlet weak var viewTotalAmount: UIView!
    @IBOutlet weak var viewNetGoldWeight: UIView!
    @IBOutlet weak var viewPurity: UIView!
}

class PrivacyPolicyCell:UITableViewCell {
    
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var shadowView:UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
