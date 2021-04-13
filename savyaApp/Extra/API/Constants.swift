//
//  urls.swift
//  savyaApp
//
//  Created by Yash on 6/26/19.
//  Copyright © 2019 Yash Rathod. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

struct MainURL {
    //static let mainurl = "https://testserver.savyajewelsbusiness.com/"
    static let mainurl = "https://api.savyajewelsbusiness.com/"
    
}
struct urls {
    static let baseURL = MainURL.mainurl + "api"
    
}

struct Apis {
    
    static let login = urls.baseURL + "/user/login"
    static let signup = urls.baseURL + "/user/register"
    static let profile_update = urls.baseURL + "/user/profile/update"
    static let forgotPassword = urls.baseURL + "user/forgetpassword"
    static let otpVerified = urls.baseURL + "/user/register/otpverified"
    static let events = urls.baseURL + "/user/events/all"
    static let notifications = urls.baseURL + "/user/notification/all"
    static let profile = urls.baseURL + "/user/profile/view"
    static let dashboard = urls.baseURL + "/user/dashboard/home"
    static let menu = urls.baseURL + "/admin/app/navigation"
    static let productList = urls.baseURL + "/product/list"
    static let aboutus = urls.baseURL + "/user/about"
    static let contactus = urls.baseURL + "/user/contact"
    static let privacyPolicy = urls.baseURL + ""
    static let termsandcondition = urls.baseURL + "/user/terms"
    static let liverate = "https://skymcx.in/NKChainsJSON.php"
    static let addressView = urls.baseURL + "/user/address/view"
    static let addressEdit = urls.baseURL + "/user/address/edit"
    static let addressDelete = urls.baseURL + "/user/address/delete"
    static let addressAdd = urls.baseURL + "/user/address/add"
    static let subsubcate = urls.baseURL + "/user/subsubcategory/single"
    static let subcata = urls.baseURL + "/user/subcategory/single"
    static let productDetail = urls.baseURL + "/product/list"
    static let wishlistView = urls.baseURL + "/user/wishlist/view"
    static let wishlistDelete = urls.baseURL + "/user/wishlist/delete"
    static let wishlistStore = urls.baseURL + "/user/wishlist/store"
    static let offers = urls.baseURL + "/product/offer"
    static let productDetails = urls.baseURL + "/single/product/details"
    static let priceList = urls.baseURL + "/product/list/price"
    static let addtocar = urls.baseURL + "/cart"
    static let viweCart = urls.baseURL + "/user/cart/view"
    //static let order = urls.baseURL + "/order/history"
    static let order = urls.baseURL + "/checkout"
    static let cartDelete = urls.baseURL + "/cart/delete"
    static let checkout = urls.baseURL + "/checkout"
    static let filterData = urls.baseURL + "/search/filter/menu"
    static let searchurl = urls.baseURL + "/search"
    static let docUpload = urls.baseURL + "/user/kyc"
    static let filterMenu = urls.baseURL + "/search/filter/menu"
    static let filter = urls.baseURL + "/search/filter"
    static let enquiry = urls.baseURL + "/enquiry"
    static let machineryMenu = urls.baseURL + "/subcategory/navigation"
    static let invoice = urls.baseURL + "/invoice_send/"
    static let cartUpdate = urls.baseURL + "/cart/update"
}

struct header {
    static let headers : HTTPHeaders = ["Content-type":"application/json","APP_KEY":APPKEY.appkey] 
}

struct APPKEY {
    static let appkey = "8447126401"
}

struct OneSignalAppID {
    static let onesignalAppID = "1444a43f-8e18-4612-90aa-4ad9aa58072c"
}

struct NewAPI {
    static let login = urls.baseURL + "/login"
    static let register = urls.baseURL + "/register"
    static let otpRequest = urls.baseURL + "/otp/request"
    static let editprofile = urls.baseURL + "/edit"
    static let profile_update = urls.baseURL + "/user/profile/update"
    static let forgotPassword = urls.baseURL + "user/forgetpassword"
    static let otpVerified = urls.baseURL + "/user/register/otpverified"
    static let events = urls.baseURL + "/user/events/all"
    static let notifications = urls.baseURL + "/user/notification/all"
    static let profile = urls.baseURL + "/details"
    static let dashboard = urls.baseURL + "/home"
    static let menu = urls.baseURL + "/home/navigation"
    static let productList = urls.baseURL + "/productlist"
    //static let aboutus = urls.baseURL + "/user/about"
    static let contactus = urls.baseURL + "/contact"
    static let termsandcondition = urls.baseURL + "/user/terms"
    static let liverate = urls.baseURL + "/live_price"
    static let addressView = urls.baseURL + "/address"
    static let addressEdit = urls.baseURL + "/address/"
    static let addressDelete = urls.baseURL + "/address/"
    static let addressAdd = urls.baseURL + "/address"
    static let subsubcate = urls.baseURL + "/subsubcategory"
    static let subcata = urls.baseURL + "/subcategory"
    static let productDetail = urls.baseURL + "/product/list"
    static let wishlistView = urls.baseURL + "/wishlist"
    static let wishlistDelete = urls.baseURL + "/wishlist/"
    static let wishlistStore = urls.baseURL + "/wishlist"
    static let offers = urls.baseURL + "/offer"
    static let productDetails = urls.baseURL + "/product/"
    static let priceList = urls.baseURL + "/product/list/price"
    static let addtocar = urls.baseURL + "/user/cart"
    static let viweCart = urls.baseURL + "/cart/show?user_id="
    static let order = urls.baseURL + "/order/history"
    static let cartDelete = urls.baseURL + "/user/cart/delete"
    static let checkout = urls.baseURL + "/user/checkout"
    static let filterData = urls.baseURL + "/search/filter/menu"
    static let searchurl = urls.baseURL + "/product"
    static let docUpload = urls.baseURL + "/user/kyc"
    static let filterMenu = urls.baseURL + "/search/filter/menu"
    static let filter = urls.baseURL + "/search/filter"
    static let enquiry = urls.baseURL + "/enquiry"
    static let machineryMenu = urls.baseURL + "/subcategory/navigation"
    static let category = urls.baseURL + "/category"
    static let banner = urls.baseURL + "/banner"
    static let bulianState = urls.baseURL + "/state"
    static let bulianCity = urls.baseURL + "/cities/"
    static let bullianList = urls.baseURL + "/BulianMerchant/"
    static let bullianDetail = urls.baseURL + "/BulianMerchant/details/"
    static let machineryDashboard = urls.baseURL + "/machinery"
    static let machineList = urls.baseURL + "/machinarylist"
    static let machineryDetail = urls.baseURL + "/machinery/"
    static let buying = urls.baseURL + "/pages/4"
    static let selling = urls.baseURL + "/pages/5"
    static let termConditions = urls.baseURL + "/pages/3"
    static let returnPayment = urls.baseURL + "/pages/1"
    static let aboutUs = urls.baseURL + "/pages/2"
    static let machinerySearchURL = urls.baseURL + "/machinarylist"
    static let productsFilter = urls.baseURL + "/menu"
    static let kyc_banners = urls.baseURL + "/kyc_banners"
    static let verifyreferalcode = urls.baseURL + "/verify-referal-code"
    
    
}
