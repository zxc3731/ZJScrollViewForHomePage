//
//  ZJScrollViewForHomePage.h
//  acggou
//
//  Created by MACMINI on 15/9/11.
//  Copyright (c) 2015年 LZJ. All rights reserved.
//

#import "ZJView.h"
#import "CycleScrollView.h"
typedef void(^ZJScrollViewClickBlock)(NSInteger index);
@interface ZJScrollViewForHomePage : ZJView
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, weak)   UIViewController *vc; // 代理
@property (nonatomic, strong) UIView *theView; // 放置滚动的view
@property (nonatomic, strong) UIPageControl *pageC; // PageControl
@property (nonatomic, assign) NSInteger scrollTime; // 设置滚动(全部图片滚完)时长
@property (nonatomic, strong) NSArray<UIView *> *customViews; // 如果数组长度大于等于1时，将以数组元素-UIView对象add到滚动上
@property (nonatomic, assign) BOOL isStringArray; // 判断images是获取本地图片还是用URL地址获取图片 YES:本地图片 默认NO:通过URL获取图片(!!!依赖SDWebImage框架!!!)
@property (nonatomic, copy)   ZJScrollViewClickBlock clickBlock;
@property (nonatomic, retain) CycleScrollView *mainScorllView;
/**
 *  设置滚动图片
 *  如果要自定义滚动view，先赋值属性，再调用一下函数。
 *
 *  @param images  图片url数组(类型为Slide)
 *  @param vc      viewController
 *  @param theView 放置滚动的view
 *  @param pageC   PageControl
 */
- (void)setScrollView:(NSArray *)images andVC:(UIViewController *)vc andView:(UIView *)theView andPageControl:(UIPageControl *)pageC;
- (void)start;
- (void)stop;
@end

/**
 *  设置滚动管理类用以管理一个界面多个滚动，要注意一点是在需要在不用时 scrollViewArray ＝ nil 以释放内存!
 */
@interface ZJScrollViewForHomePageManager : NSObject
@property (nonatomic, strong) NSArray<ZJScrollViewForHomePage *> *scrollViewArray;
+ (instancetype)shareManager;
- (void)addMainScorllView:(ZJScrollViewForHomePage *)csv;
- (void)allStart;//将一个view里面的所有滚动停止或者开启，如首页
- (void)allStop; //将一个view里面的所有滚动停止或者开启，如首页
@end
