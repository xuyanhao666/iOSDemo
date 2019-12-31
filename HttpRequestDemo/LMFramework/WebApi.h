//
//  WebApi.h
//  WKApp
//
//  Created by 少年 on 14-9-24.
//  Copyright (c) 2014年 少年. All rights reserved.
//


#define USERNAME @"account"
#define PASSWORD @"password"
#define AUTOLOGIN @"autoLogin"

#define ImageURL(l) [NSString stringWithFormat:@"http://%@:%@/CHIS%@",[(LMServiceClient*)[LMServiceClient shareInstance] baseURL].host,[[[LMServiceClient shareInstance] baseURL]port],l]

//http://180.166.162.44:8080/SHRMYY/RmyyJsonServlet  掌上市一

#define BASE_URL @"/SHRMYY/RmyyJsonServlet"
#define TEMP_BASE_URL @"/healthgate/PHJsonService"
///冯曦本地地址
//#define Host_URL @"http://10.4.251.42:8080"
///公司测试地址
//#define Host_URL @"http://10.4.247.70:8411"
///肿瘤医院内网地址
//#define Host_URL @"http://172.172.172.28:8433"
///肿瘤医院外网地址
//#define Host_URL @"http://180.166.126.220:8433"

#define IntranetURL @"http://180.166.162.44:8080"
#define OuternetURL  @"http://180.166.162.44:8080"
#define TempURL @"http://222.73.1.134:8433"

///后台验证接口
static NSString* const ApiCheckCode = @"2027";
///发送验证码接口
static NSString* const ApiSendCode = @"2004";
///获取个人资料
static NSString* const ApiUserInfo = @"2005";
///查询首页公济快讯新闻列表
static NSString* const ApiNewsList = @"2000";
///查询首页公济快讯新闻详情
static NSString* const ApiNewsDetail = @"2001";
///查询首页公济快讯BBS信息列表
static NSString* const ApiBBSDataInfo = @"2002";
///修改首页公济快讯BBS读取状态
static NSString* const ApiBBSStatus  = @"2003";
///查询科室公告列表
static NSString* const ApiDeptNoticeList = @"2006";
///公告详情
static NSString* const ApiCommentList = @"2007";
///发布科室公告
static NSString* const ApiDeptComment = @"2008";
///回复公告
static NSString* const ApiSendDeptData = @"2009";
///查询科室介绍
static NSString* const ApiDeptIntroduce = @"";

///病人详情
static NSString* const ApiPatientInfo = @"2011";
///用药医嘱
static NSString* const ApiMedicalAdvice = @"1106";
///非药医嘱
static NSString* const ApiNonMedicalAdvice = @"11066";

///医技报告，检验报告
static NSString* const ApiMedicalTechniciansReportJY = @"1104";
///医技报告，检查报告
static NSString* const ApiMedicalTechniciansReportJC = @"2018";
///检验报告详情
static NSString* const ApiReportJYDetail = @"1105";


///病人列表
static NSString* const ApiPatientList = @"2010";
///病人主诉
static NSString* const ApiPatientService= @"2012";
///病人病程
static NSString* const ApiPatientHistory = @"2013";
///我的预约，（门诊预约）
static NSString* const ApiMyOrderList = @"2014";
///门诊排班
static NSString* const ApiDeptAppoint = @"2015";
///入院证列表
static NSString* const ApiEnterCerList = @"2019";


///科室医生列表
static NSString* const ApiAuthorList = @"2022";
///搜索医生
static NSString* const ApiSearchDoctorList = @"2023";
///删除添加医生权限
static NSString* const ApiDeleteAuthor = @"2025";
///添加科室成员
static NSString* const ApiAddDeptMember = @"2024";

///获取大楼信息
static NSString* const ApiBuildInfo = @"2020";
///查询科室楼层信息
static NSString* const ApiFloorInfo = @"2021";



/*
///获取费用统计查询类型列表
static NSString *const ApiSalaryList = @"3";
///获取费用统计详情
static NSString * const ApiSalaryDetail = @"1106";
///获取科室列表
static NSString* const ApiDepartmentList = @"8";
///查询科室下面所有的人员
static NSString* const ApiContanctsInDepartment = @"9";
///查询联系人，根据姓名，短号，手机号模糊查询
static NSString* const ApiSearchContacts = @"10";
/////查询危急值列表
//static NSString* const ApiCriticalValue = @"101";
///获取首页展示项目
static NSString* const ApiHomepageGetItems = @"";
///会诊查询
static NSString* const ApiConsultationInquire = @"201";
///会诊查询详细页
static NSString* const ApiConsultationDetail = @"202";
///会诊处理接口
static NSString *const ApiCheckConsultation = @"203";
///危机值查询
static NSString *const ApiCrisisInquire = @"101";
///危机值查询详情页
static NSString *const ApiCrisisInquireDetail = @"102";
///危机值处理接口
static NSString *const ApiCrisisInquireCheck  = @"103";
///药品使用
static NSString *const ApiDrug = @"301";
///药品使用详情页
static NSString *const ApiDrugDetail = @"302";
///药品处理意见接口
static NSString *const ApiDrugAppical = @"303";
///医生工作量
static NSString *const ApiDocWorkload = @"1109";
///在线医生列表
static NSString *const ApiOnlineDocList = @"1107";
///日志列表
static NSString *const ApiLogList = @"1108";
///查询在院病人所在病区列表
static NSString *const ApiPatientPartList = @"1111";
///查询病区中病人列表
static NSString *const ApiPatientList = @"1101";
///查询病人病史类别列表
static NSString *const ApiMedicalClassList = @"1104";
///查询病史类别详情
static NSString *const ApiMedicalClassDetail =@"1105";
///查询病人报告列表
static NSString *const ApiReportList = @"1103";
///查询病人医嘱列表
static NSString *const ApiOrderList = @"1102";
///查询我的出院病人列表
static NSString *const ApiMyOutPatientList = @"11011";
///更改用户资料
static NSString *const ApiEditUser = @"21";
///用户反馈接口
static NSString *const ApiUserFeedBack = @"11";
///修改密码接口
static NSString *const ApiChangePassword = @"20";
///根据月份查日历
static NSString *const ApiMyCalendar = @"13";
///添加日程
static NSString *const ApiAddCalendar = @"12";
///编辑日程
static NSString *const ApiEditCalendar = @"15";
///删除日程
static NSString *const ApiDeleteCalendar = @"16";
///改变日程状态
static NSString *const ApiChangeCalendarState = @"14";
///查询健康宣教列表
static NSString *const ApiHealthEducateState = @"31";
*/


///查询科室（通讯录
static NSString* const ApiContactDeptmentList = @"2016";
///查询医生（通讯录）
static NSString* const ApiContactList = @"2017";

