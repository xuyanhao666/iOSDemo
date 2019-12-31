Demo说明：
注意：
	1.本Demo只是做一个示例，说明发起支付的流程，下单和签名、查单和支付通知均在服务器后台实现。
	2.本Demo是64位的SDK
测试步骤：
	1.打开目录下./lib/payRequsestHandler.h，修改商户相关参数；
	2.用XCode打开项目，【项目属性】-【Info】-【URL Schemes】设置微信开放平台深圳的应用APPID，如图文件夹下"设置appid.jpg"所示。
开发要点：
	1.设置好正确【项目属性】-【Info】-【URL Schemes】才能正常调起支付；
	2.调用支付前需要调用代码注册APPID：[WXApi registerApp:APP_ID withDescription:@"demo 2.0"];