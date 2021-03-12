//
//  SVViewController.m
//  TWTool_Example
//
//  Created by TW on 2021/3/12.
//  Copyright © 2021 tanwang11. All rights reserved.
//

#import "SVViewController.h"
#import "TWTool.h"
#import <Masonry/Masonry.h>




@interface SVViewController ()

@property (nonatomic, strong) TWSegmentView         * infoHSV;
@property (nonatomic, strong) UIScrollView_twPanGR  * infoSV;

@end


@implementation SVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"测试界面";
    
    
    TWSegmentView * hsv = [[TWSegmentView alloc] initWithStyle:TanwangSegmentViewTypeView];
    hsv.layer.masksToBounds = YES;
    
    hsv.titleArray    = @[@"111", @"222", @"333"];
    hsv.originX       = 10;
    hsv.btTitleNColor = PColorBlack3;
    hsv.btTitleNFont  = PFONT16;
    hsv.lineWidthFlexible = YES;
    hsv.lineWidthScale    = 1.1;
    hsv.backgroundColor = [UIColor whiteColor];
    [hsv setUI];
    self.infoHSV = hsv;
    [self.view addSubview:self.infoHSV];
    
    UIScrollView_twPanGR * sv = [UIScrollView_twPanGR new];
    sv.backgroundColor = [UIColor whiteColor];
    sv.pagingEnabled = YES;
    [self.view addSubview:sv];
    self.infoSV = sv;
    
    self.infoHSV.weakLinkSV = self.infoSV;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.infoSV.contentSize = CGSizeMake(PSCREEN_WIDTH*self.infoHSV.titleArray.count, self.infoSV.height);
    });
    
    for (int i = 0; i < self.infoHSV.titleArray.count; i++) {
        UIButton * btn = [UIButton new];
        btn.tag = i;
        btn.frame = CGRectMake(20, 100, 200, 48);
        btn.backgroundColor = [UIColor blackColor];
        [btn setTitle:self.infoHSV.titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(toucheBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.infoSV addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0).offset(PSCREEN_WIDTH*i);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(200, 48));
        }];
    }
    
    
    
    [self.infoHSV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    [self.infoSV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.infoHSV.mas_bottom);
        make.left.mas_equalTo(0);
        if (self.hidesBottomBarWhenPushed) {
            make.bottom.mas_equalTo(0);
        }else{
            make.bottom.mas_equalTo(-49);
        }
        make.right.mas_equalTo(0);
    }];
    
    
}


- (void)toucheBtnEvent:(UIButton*)btn {
//    UIButton * hsvB = self.infoHSV.btArray[btn.tag+1];
//    [self.infoHSV updateLineViewToBT:hsvB];
    [self.infoHSV scrollToIndex:(btn.tag+1)];
}



@end
