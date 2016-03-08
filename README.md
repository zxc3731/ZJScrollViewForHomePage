# ZJScrollViewForHomePage
iOS实现图片的无限滚动，以及对多个滚动试图的管理
```objective-C
    self.automaticallyAdjustsScrollViewInsets = NO; // 有可能会出现错位问题，可以这样设置
    NSArray *imagesURL = @[@"acggoudemo_1",@"acggoudemo_2",@"acggoudemo_3",@"acggoudemo_4"];
    self.cycolView = [ZJScrollViewForHomePage new];
    self.cycolView.isStringArray = YES;
    [self.cycolView setScrollView:[imagesURL copy] andVC:self andView:self.myview andPageControl:nil];
    self.cycolView.clickBlock = ^(NSInteger index){
        NSLog(@"i:%d", index);
    };
    
    NSArray *imagesURL1 = @[@"wo1",@"wo2",@"wo3",@"wo4"];
    self.cycolView1 = [ZJScrollViewForHomePage new];
    self.cycolView1.isStringArray = YES;
    [self.cycolView1 setScrollView:[imagesURL1 copy] andVC:self andView:self.myview1 andPageControl:nil];
    self.cycolView1.clickBlock = ^(NSInteger index){
        NSLog(@"i1:%d", index);
    };
    
    // 以下有需要管理多个滚动视图的话可以这样，没有需求的就免了
    ZJScrollViewForHomePageManager *man = [ZJScrollViewForHomePageManager shareManager];
    [man addMainScorllView:self.cycolView];
    [man addMainScorllView:self.cycolView1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [man allStop];
        man.scrollViewArray = nil; // 如果用到 ZJScrollViewForHomePageManager 需要设置nil以释放内存
    });
```
![](https://github.com/zxc3731/ZJScrollViewForHomePage/blob/master/tem22.gif)

框架的URL图片加载依赖SDWebImage，有需要可以自己改就好
