//
//  PartnerConfig.h
//  AlipaySdkDemo
//
//  Created by ChaoGanYing on 13-5-3.
//  Copyright (c) 2013年 RenFei. All rights reserved.
//
//  提示：如何获取安全校验码和合作身份者id
//  1.用您的签约支付宝账号登录支付宝网站(www.alipay.com)
//  2.点击“商家服务”(https://b.alipay.com/order/myorder.htm)
//  3.点击“查询合作者身份(pid)”、“查询安全校验码(key)”
//

#ifndef MQPDemo_PartnerConfig_h
#define MQPDemo_PartnerConfig_h

//合作身份者id，以2088开头的16位纯数字
#define PartnerID @"2088611075948671"
//收款支付宝账号
#define SellerID  @"support@xxx.com"

//安全校验码（MD5）密钥，以数字和字母组成的32位字符
#define MD5_KEY @""

//商户私钥，自助生成
#define PartnerPrivKey @"MIICeQIBADANBgkqhkiG9w0BAQEFAASCAmMwggJfAgEAAoGBANJR7UFPe0rExR9/27CDaQqer5wHESBtE80hr10CoqBd8PAvdXqjxTc9/BGFk6lMggTQKNMGmI5Vvr8ZuJZq3tpR8S70ri6381iL0egPAlAwmEcjSRUswEV7wwL3edHvhAm443DKk2l00hkhfUaEiJGTs9cXqMQ+ykHHfIVUFdqdAgMBAAECgYEAz2SsUVfAG0WXoG0jRJcA0NEUGAa787675O7PjycXGI4qFZ6m+O1ffw7nbpvKtQpVt8tQRm9dphWVh7okVGdEIje5+Qd9lOdWd5MvN/cwOlD2BPy8EzE4S3QhsBxgqq8dqDh7R5p/2LwcuaaPlVmIMITZvEYMFohRpMPamXGIwT0CQQD75MLzCjberDnt2UkUo8sWHYwaAYmIXqB0EIRKFvswhLvlrRw9kymJcMyI8UDBXgxJmUl5sZ01rwp8e2/SsYVTAkEA1b+qGiaUPulsRq0uXjqwFkBZVNVZVhF5DsqZNb1JjcTHOBC5pPkbQ/wl4HnA1sfH3Pjx5QeuRfSTtWBA4JoSTwJBAJKSt9nijLEfuImtkTfgY5FX2ilb0aK3pVhEMCZInxvJcOihxbgSxO3D5FCfSZX7Wt0MxFN6xcbyNwDeduA8Ch8CQQC70d3zeqDbIxssg3JyBFnEQ6j7XTlR 4qqgL7Auw3RFaXqwrimiZ+3ocEEMHZAwan4ZknpjiLs+5yl/v+NiOKALAkEA8hLs UMy+jrkm9yoOOzufpgkOvts/BBO4GD7BQynv1lMK9dvBO9jYV0ACBca965gR6c7vi5cJ5ROn6X7DXcMngg=="


//支付宝公钥
#define AlipayPubKey   @"MIGfMA0GCoqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB"

#endif
