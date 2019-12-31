//
//  FindPlaceDetailVC.m
//  TianYiHealthy
//
//  Created by Ray Zhao on 15/9/24.
//  Copyright © 2015年 xingzhi. All rights reserved.
//

#import "FindPlaceDetailVC.h"

@interface FindPlaceDetailVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView* mainTableview;

@end

@implementation FindPlaceDetailVC
{
    NSArray *dataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.mainTableview];
    [self getPlacesAction];
}
-(void)getPlacesAction{
    NSDictionary *param = @{@"parentid": _parentid};
    NSDictionary *params = @{@"area": param};
    __weak SFHttpRequest *sharedRequest = [SFHttpRequest sharedHttpRequest];
    
    sharedRequest.tempType = 103;
    [[SFHttpRequest sharedHttpRequest] query:params queryType:@"326" completionBlock:^(ASIHTTPRequest *request, NSData *reponseData, NSError *error) {
        sharedRequest.tempType = 0;
        id obj = [HHTool decodeReponseData:reponseData toView:self.view];
        if (obj != nil) {
            dataArr = [obj objectForKey:@"arealist"];
            
            
            [self.mainTableview reloadData];
        }
    } failedBlock:^(ASIHTTPRequest *request, NSError *error) {
        
    }];

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UITableView *)mainTableview{
    if (!_mainTableview) {
        _mainTableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _mainTableview.delegate = self;
        _mainTableview.dataSource = self;
        _mainTableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        
        
    }
    return _mainTableview;
}
#pragma mark - tableview delegate and datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr.count;
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"cellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text =dataArr[indexPath.row][@"areaname"];
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //点击查询相关地级市
    NSDictionary *nowDic = [dataArr objectAtIndex:indexPath.row];
    
    if (_delegate && [_delegate respondsToSelector:@selector(selectedOnePlace:)]) {
                [_delegate selectedOnePlace:nowDic];
    
    }
    
    
            NSString *title = [nowDic objectForKey:@"areaname"];
           // [super toBack:nil];
            [NSUD setObject:title forKey:@"place"];
            [NSUD synchronize];
    //        [[NSNotificationCenter defaultCenter]postNotificationName:@"refreashHospList" object:nil];
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-3] animated:YES];

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
