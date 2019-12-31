//
//  ViewController.m
//  NewAddressBookDemo
//
//  Created by 许艳豪 on 16/3/17.
//  Copyright © 2016年 ideal_Mac. All rights reserved.
//

#import "ViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(hha) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(100, 100, 200, 200);
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
}
- (void)hha{
    //遍历获取通讯录信息
    CNContactStore * stroe = [[CNContactStore alloc]init];
    CNContactFetchRequest * request = [[CNContactFetchRequest alloc]initWithKeysToFetch:@[CNContactGivenNameKey,CNContactFamilyNameKey,CNContactPhoneNumbersKey]];
    [stroe enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        NSLog(@"%@",contact.phoneNumbers);
//        NSString *name = [NSString stringWithFormat:@"%@%@",contact.familyName,contact.givenName];
//        NSString *phone = @"";
//        for (CNLabeledValue *value in contact.phoneNumbers){
//            CNPhoneNumber *phonenum = value.value;
//            if ([phonenum.stringValue rangeOfString:@"-"].location != NSNotFound) {
//                //包含
//                NSArray *phonearr = [phonenum.stringValue componentsSeparatedByString:@"-"];
//                for (int i = 0; i < phonearr.count; i ++) {
//                    phone = [phone stringByAppendingString:phonearr[i]];
//                }
//            }else{
//                //不包含
//                phone = phonenum.stringValue;
//            }
//        }
//        NSLog(@"姓名：%@--电话：%@",name,phone);
//        NSString * foematter =[CNContactFormatter stringFromContact:contact style:CNContactFormatterStylePhoneticFullName];
//        NSLog(@"%@",foematter);
    }];
    
    //弹出系统通讯录
    CNContactPickerViewController * con = [[CNContactPickerViewController alloc]init];
    [self presentViewController:con animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
