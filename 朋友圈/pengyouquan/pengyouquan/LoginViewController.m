//
//  LoginViewController.m
//  CSFinancialApp
//
//  Created by primb on 16/6/28.
//  Copyright © 2016年 primb. All rights reserved.
//

#import "LoginViewController.h"
#import "BaseTabBarViewController.h"
//#import "MyKeyChainTool.h"
//#import "NSString+MD5.h"

@interface LoginViewController ()<UITextFieldDelegate>{
    
    UITextField *userNameField;
    UITextField *passWordField;
    UIButton *loginBtn;
    UIImageView *headerImage;
    UIImageView *usernameImage;
    UIImageView *passwordImage;
    
    UIView * loginView;//login 界面的头像 两个输入框以及登录按钮和注册按钮都放置其上
    CGRect  loginViewOldRect;
}
@end

@implementation LoginViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    //延长启动图的显示时间
    [NSThread sleepForTimeInterval:1.0f];
    
    self.view.backgroundColor = [UIColor clearColor];
    UIImageView * image = [[UIImageView alloc] initWithFrame:self.view.bounds];
    image.image = [UIImage imageNamed:@"registerBg"];
    [self.view addSubview:image];
    
//    [self reloadDataBase];
    [self createLoginView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self  action:@selector(hiddenKeyBoard:)];
    tap.numberOfTapsRequired=1;
    tap.numberOfTouchesRequired=1;
    [self.view addGestureRecognizer:tap];
    
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self endKeyBordNotification];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self startKeyBordNotification];
    self.navigationController.navigationBarHidden = YES;
}
-(void)createLoginView{
    loginView  = [[UIView alloc] init];
    [self.view addSubview:loginView];
    
    headerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headerImage.png"]];
    [loginView addSubview:headerImage];
    headerImage.frame = CGRectMake(0, 0, ScreenAdaptationWidthValue(395), ScreenAdaptationWidthValue(90));
    headerImage.center = CGPointMake(ScreenWidth / 2, ScreenAdaptationWidthValue(500*0.586));
    
    usernameImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"username.png"]];
    [loginView addSubview:usernameImage];
    usernameImage.frame = CGRectMake(ScreenAdaptationWidthValue(164*0.586), ScreenAdaptationWidthValue(886*0.586),
                                     ScreenAdaptationWidthValue(954*0.586),ScreenAdaptationWidthValue(150*0.586));
    UIImageView * userNameWordImage = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenAdaptationWidthValue(60*0.586), ScreenAdaptationWidthValue(46*0.586), ScreenAdaptationWidthValue(134*0.586), ScreenAdaptationWidthValue(58*0.586))];
    userNameWordImage.image = [UIImage imageNamed:@"userNameWord"];
    [usernameImage addSubview:userNameWordImage];
    userNameField = [[UITextField alloc] init];
    userNameField.backgroundColor = [UIColor clearColor];
    [loginView addSubview:userNameField];
    userNameField.textColor= [UIColor whiteColor];
    userNameField.delegate = self;
    userNameField.frame = CGRectMake(ScreenAdaptationWidthValue(378*0.586),ScreenAdaptationWidthValue(886*0.586),
                                     ScreenAdaptationWidthValue(736*0.586),ScreenAdaptationWidthValue(150*0.586));
    
    
    passwordImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password.png"]];
    [loginView addSubview:passwordImage];
    passwordImage.frame = CGRectMake(ScreenAdaptationWidthValue(164*0.586), ScreenAdaptationWidthValue(1096*0.586) ,
                                     ScreenAdaptationWidthValue(954*0.586),ScreenAdaptationWidthValue(150*0.586));
    UIImageView * pwWordImage = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenAdaptationWidthValue(60*0.586), ScreenAdaptationWidthValue(46*0.586), ScreenAdaptationWidthValue(134*0.586), ScreenAdaptationWidthValue(58*0.586))];
    pwWordImage.image = [UIImage imageNamed:@"pwWord"];
    [passwordImage addSubview:pwWordImage];
    
    passWordField= [[UITextField alloc] init];
    passWordField.backgroundColor = [UIColor clearColor];
    [loginView addSubview:passWordField];
    passWordField.textColor= [UIColor whiteColor];
    passWordField.delegate = self;
    passWordField.secureTextEntry = YES;
    passWordField.frame = CGRectMake(ScreenAdaptationWidthValue(378*0.586),ScreenAdaptationWidthValue(1094*0.586),
                                     ScreenAdaptationWidthValue(736*0.586),ScreenAdaptationWidthValue(150*0.586));
    
    loginBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [loginView addSubview:loginBtn];
    [loginBtn addTarget:self action:@selector(checkBaseInfo) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"loginbtn.png"] forState:UIControlStateNormal];
    
    loginBtn.frame = CGRectMake(ScreenAdaptationWidthValue(164*0.586), ScreenAdaptationWidthValue(1354*0.586),
                                ScreenAdaptationWidthValue(954*0.586),ScreenAdaptationWidthValue(150*0.586));
    
    loginView.frame = CGRectMake(0, 0, ScreenWidth, loginBtn.frame.origin.y + loginBtn.frame.size.height);
    loginViewOldRect=loginView.frame;
    if([[AppPublic getUserDefaultsData:UserID] length]>0){
        userNameField.text = [AppPublic getUserDefaultsData:UserID];
    }
}

-(void)hiddenKeyBoard:(UITapGestureRecognizer *) sender{
    [userNameField resignFirstResponder];
    [passWordField resignFirstResponder];
}
//检查基础
-(void)checkBaseInfo{
    if(![self checkUserNameAndPassWordIsEmpty]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"用户名或者密码不能为空" preferredStyle: UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //点击按钮的响应事件；
        }]];
        [self presentViewController:alert animated:true completion:nil];
    }else{
        //检查网络的放在doLogin方法里了，哪里还要验证本地登陆
        [self loginSuccessAction];
    }
}
-(void)doLogin{
    [self loginSuccessAction];
    UIWindow *window  = [UIApplication sharedApplication].keyWindow;
    BaseTabBarViewController *mainViewController = [[BaseTabBarViewController alloc] init];
    window.rootViewController = mainViewController;
    [window makeKeyAndVisible];
}

#pragma mark  登陆成功后 网路登陆只是为了验证 直接加载本地信息
-(void)loginSuccessAction{
    //正常登陆代码
    NSString * UUID = [self getUUID];
    NSLog(@"UUID:%@",UUID);
//    NSString *passwdStr = [passWordField.text stringToMD5:passWordField.text];
//    passwdStr = [passwdStr uppercaseString];
    NSString * loginUrl = [NSString stringWithFormat:@"%@%@",ZJPABaseUrl,ZJPALoginAction];
    [NetRequestObject netRequestWithURL:loginUrl
                          andParameters:@{@"uName":userNameField.text,
                                          @"uPwd":passWordField.text}
                       andFinishedBlock:^(BOOL success, NSDictionary *dataDic) {
                           if(success){
                               //成功
                               UIWindow *window  = [UIApplication sharedApplication].keyWindow;
                               BaseTabBarViewController *mainViewController = [[BaseTabBarViewController alloc] init];
                               window.rootViewController = mainViewController;
                               [window makeKeyAndVisible];

                                if([dataDic isKindOfClass:[NSDictionary class]] && [dataDic[@"data"] isKindOfClass:[NSDictionary class]]){
                                    NSDictionary *data = [dataDic objectForKey:@"data"];
                                    NSString * personName = [data objectForKey:@"userName"];
                                    NSString * personId = [data objectForKey:@"userId"];
                                    NSString * department = [data objectForKey:@"userDept"];
                                    if(personName){
                                        [AppPublic setUserDefaultsData:PersonName andValue:personName];
                                    }
                                    if(personName){
                                        [AppPublic setUserDefaultsData:PersonId andValue:personId];
                                    }
                                    if(personName){
                                        [AppPublic setUserDefaultsData:Department andValue:department];
                                    }
                                }else{
                                }
                                [AppPublic setUserDefaultsData:UserID andValue:userNameField.text];
                            }else{
                                [AppPublic alertViewWithController:self andTitle:@"提示" andMessage:[dataDic objectForKey:FailedMessage]];
                            }
                       }];
}

#pragma mark 检测本地是否有用户信息

//判断用户名或者密码为空
-(BOOL)checkUserNameAndPassWordIsEmpty{
    if([userNameField.text length]<1||[passWordField.text length]<1){
        return false;
    }
    return true;
}
//判断是否有网络连接


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark 把沙盒里的数据库文件删除掉，重新复制一份过去
-(void)reloadDataBase{
    NSFileManager*fileManager =[NSFileManager defaultManager];
    NSError*error;
    NSArray*paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString*documentsDirectory =[paths objectAtIndex:0];
    
    //APP安装目录中的document目录路径
    NSString*dbPath =[documentsDirectory stringByAppendingPathComponent:@"BBHK_DB.sqlite"];
    
    
    
    if([fileManager fileExistsAtPath:dbPath]== NO)
    {
        //项目中的数据库文件路径
        NSString*resourcePath =[[NSBundle mainBundle] pathForResource:@"BBHK_DB" ofType:@"sqlite"];
        [fileManager copyItemAtPath:resourcePath toPath:dbPath error:&error];
    }
}

#pragma Start and End KeyBordNotification

- (void) keyboardWasShown:(NSNotification *) notif
{
    
    NSValue *keyboardBoundsValue = [[notif userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardBounds;
    [keyboardBoundsValue getValue:&keyboardBounds];
    [self adjustPanelsWithKeybordHeight:(keyboardBounds.size.height + 45) andCurrentEditViewYaddH:passWordField.frame.origin.y + passWordField.frame.size.height +ScreenAdaptationHeightValue(55)];
}

- (void) keyboardWasHidden:(NSNotification *) notif
{
    NSValue *keyboardBoundsValue = [[notif userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardBounds;
    [keyboardBoundsValue getValue:&keyboardBounds];
    [self adjustPanelsWithKeybordHeight:0-keyboardBounds.size.height - 45 andCurrentEditViewYaddH:0];
}

#pragma 键盘出现/消失响应调整输入框位置，然后根据输入框调整logo
-(void)adjustPanelsWithKeybordHeight:(float)height andCurrentEditViewYaddH:(float) yandH
{
    //计算获得textView所在表格高度
    __block float textviewYInView= (yandH + height) - ScreenHeight;//当前编辑框底部所在self.view中的相对位置
    __block float gap=textviewYInView;
    if(height>0){//键盘出现
        if(gap > 0){
            [UIView animateWithDuration:0.7 animations:^{
                loginView.frame = CGRectMake(loginView.frame.origin.x, 0 - gap , loginView.frame.size.width, loginView.frame.size.height);
            }];
        }
    }else{//键盘消失
        [UIView animateWithDuration:1 animations:^{
            loginView.frame = CGRectMake(loginView.frame.origin.x, 0, loginView.frame.size.width, loginView.frame.size.height);
        }];
    }
}

-(void)dismissKeyBoard{
    [[[[UIApplication sharedApplication] delegate] window] endEditing:YES];
}

#pragma Start and End KeyBordNotification

-(void)startKeyBordNotification{
    //添加键盘监听事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)endKeyBordNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


-(NSString *)getUUID{
    NSString * IDFA = [MyKeyChainTool load:UniqueDeviceId];
    if(IDFA){
        return IDFA;
    }else{
        NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [MyKeyChainTool save:UniqueDeviceId data:idfv];
        return [MyKeyChainTool load:UniqueDeviceId];
    }
    
    return nil;
}
#
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
