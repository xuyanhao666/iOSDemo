//
//  MainViewController.m
//  通讯录Demo
//
//  Created by ZhangCheng on 14-4-7.
//  Copyright (c) 2014年 zhangcheng. All rights reserved.
//

#import "MainViewController.h"
#import "ZCAddressBook.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray*array=@[@"添加联系人",@"获得Vcard",@"短信群发",@"获得指定联系人信息",@"跳出程序发短信"];
    
    for (int i=0; i<5; i++) {
        UIButton*button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(100, i*100, 200, 50);
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.tag=1000+i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
    
}
-(void)buttonClick:(UIButton*)button{
    BOOL isSucceed;
    
    NSMutableDictionary*dic;
    NSArray*array;
    switch (button.tag-1000) {
        case 0:
            //添加联系人 label是备注
            isSucceed=[[ZCAddressBook shareControl]addContactName:@"张三" phoneNum:@"34456789"withLabel:@"dfghjklvbn"];
            NSLog(@"添加是否成功%d",isSucceed);
            break;
        case 1:
            //获得Vcard
            dic= [[ZCAddressBook shareControl]getPersonInfo];
            //获得序列索引
            array=[[ZCAddressBook shareControl]sortMethod];
            NSLog(@"Vcard%@~~~序列%@",dic,array);
            break;
        case 2:
            //发送短信,群发，可以有指定内容
            [[ZCAddressBook alloc]initWithTarget:self MessageNameArray:@[@"13811928431"] Message:@"发送消息的内容" Block:^(int type) {
                NSLog(@"发送短信后的状态");
            }];

            break;
        case 3:
            
            //调用系统控件，选中后获得指定人信息
            [[ZCAddressBook alloc]initWithTarget:self PhoneView:^(BOOL isSucceed, NSDictionary *dic) {
                NSLog(@"从系统中获得指定联系人的信息%@",dic);
            }];
            break;
        case 4:
            //跳出程序进行发送短信
            [ZCAddressBook sendMessage:@"13811928431"];
            break;
        default:
            break;
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
