//
//  ZJScrollViewForHomePage.m
//  acggou
//
//  Created by MACMINI on 15/9/11.
//  Copyright (c) 2015年 LZJ. All rights reserved.
//

#import "ZJScrollViewForHomePage.h"
#define mainScorllViewTag 9999
@implementation ZJScrollViewForHomePage
- (void)setScrollView:(NSArray *)images andVC:(UIViewController *)vc andView:(UIView *)theView andPageControl:(UIPageControl *)pageC {
    if (images.count == 0) {
        return;
    }
    _images  = images;
    _vc      = vc;
    _theView = theView;
    _pageC   = pageC;
    [self setScrollView:_images];
}
- (void)setScrollView:(NSArray *)slideImgs {
    
    NSMutableArray<UIView *> *viewsArray = [@[] mutableCopy];
    
    if (_customViews.count >= 1) {
        [viewsArray addObjectsFromArray:_customViews];
    }
    else {
        for (int i = 0; i < slideImgs.count; i++) {
            NSString *sl     = slideImgs[i];
            UIImageView *tem = [[UIImageView alloc] initWithFrame:_theView.bounds];
            if (self.isStringArray == YES) {
                tem.image = [UIImage imageNamed:sl];
            }
            else {
                if ([tem respondsToSelector:@selector(sd_setImageWithURL:)]) {
                    [tem performSelector:@selector(sd_setImageWithURL:) withObject:sl];
                }
            }
            [viewsArray addObject:tem];
        }
    }
    
    if (viewsArray.count == 1) {
        [_theView addSubview:viewsArray.firstObject];
        
        UIImageView *temimg           = (UIImageView *)viewsArray.firstObject;
        temimg.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneImageClickAction:)];
        [temimg addGestureRecognizer:tap];
    }
    else {
        id temview = [_theView viewWithTag:mainScorllViewTag];
        if (temview) {
            self.mainScorllView = temview;
        }
        else {
            self.mainScorllView        = [[CycleScrollView alloc] initWithFrame:_theView.bounds animationDuration:_scrollTime==0?2:_scrollTime];
            self.mainScorllView.tag    = mainScorllViewTag;
            self.mainScorllView.isOpen = 0;
            [_theView addSubview:self.mainScorllView];
        }
    }

    if (_pageC) {
        _pageC.numberOfPages                        = slideImgs.count;
        UIPageControl *temcontrol                   = _pageC;
        self.mainScorllView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
            if (pageIndex-1 < 0) {
                temcontrol.currentPage = temcontrol.numberOfPages-1;
            }
            else{
                temcontrol.currentPage = pageIndex-1;
            }
            return viewsArray[pageIndex];
        };
    }
    else {
        self.mainScorllView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
            return viewsArray[pageIndex];
        };
    }
    
    NSUInteger count1 = slideImgs.count;
    self.mainScorllView.totalPagesCount = ^NSInteger(void){
        return count1;
    };

    [_theView bringSubviewToFront:_pageC];
}
- (void)setClickBlock:(ZJScrollViewClickBlock)clickBlock {
    _clickBlock = clickBlock;
    
    if (self.images.count > 1 && self.mainScorllView) {
        __weak __typeof(self) weakSelf = self;
        self.mainScorllView.TapActionBlock = ^(NSInteger pageIndex){
            weakSelf.clickBlock(pageIndex);
        };
    }
}
- (void)stop {
    [_mainScorllView theViewStop];
}
- (void)start {
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(delayStart) userInfo:nil repeats:NO];
}
- (void)delayStart {
    [_mainScorllView theViewStart];
}
- (void)oneImageClickAction:(UITapGestureRecognizer *)tap {
    self.clickBlock(0);
}
- (void)dealloc {
    [_mainScorllView theViewInvild];
    NSLog(@"dealloc - 444");
}
@end
@implementation ZJScrollViewForHomePageManager
+ (instancetype)shareManager {
    static ZJScrollViewForHomePageManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[ZJScrollViewForHomePageManager alloc] init];
        sharedMyManager.scrollViewArray = [NSArray new];
    });
    return sharedMyManager;
}
- (void)addMainScorllView:(ZJScrollViewForHomePage *)csv {
    self.scrollViewArray = [self.scrollViewArray arrayByAddingObject:csv];
}
- (void)allStop {
    for (ZJScrollViewForHomePage *temview in self.scrollViewArray) {
        [temview.mainScorllView theViewStop];
    }
}
- (void)allStart {
    for (ZJScrollViewForHomePage *temview in self.scrollViewArray) {
        [temview.mainScorllView theViewStart];
    }
}
- (void)dealloc {
    NSLog(@"dealloc - 111");
}
@end