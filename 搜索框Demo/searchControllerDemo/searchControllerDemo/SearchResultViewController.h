//
//  SearchResultViewController.h
//  searchControllerDemo
//
//  Created by primb_xuyanhao on 2018/12/28.
//  Copyright © 2018 Primb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchResultViewController : UIViewController<UISearchResultsUpdating>
@property (strong, nonatomic) UINavigationController *nav;
@property (strong, nonatomic) UISearchBar *searchBar;

@property (strong, nonatomic) NSMutableArray *dataListArry;

@end

NS_ASSUME_NONNULL_END
