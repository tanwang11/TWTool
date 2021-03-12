//
//  TWViewController.m
//  TWTool
//
//  Created by tanwang11 on 03/04/2021.
//  Copyright (c) 2021 tanwang11. All rights reserved.
//

#import "TWViewController.h"

#import "TWTool.h"


@interface TWViewController ()

@end

@implementation TWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIButton * btn = [UIButton new];
    btn.frame = CGRectMake(20, 100, 200, 48);
    btn.backgroundColor = [UIColor blackColor];
    [btn setTitle:@"cs" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(toucheBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)toucheBtnEvent {
//    /**
//     * 日期选择组件测试
//     */
//    TWDatePicker * datePicker = [[TWDatePicker alloc] initWithDateStyle:TWDatePickerStyle_YMD CompleteBlock:^(NSDate * _Nullable date) {
//        if (date)
//            NSLog(@"选择时间 %@", [date stringWithFormatter:@"yyyy-MM-dd" timeZone:[NSDate getZoneHour]]);
//        else
//            NSLog(@"选择了长期有效");
//    }];
////    datePicker.showLongTime = YES; // 显示长期按钮
//    [datePicker show];
    
    
    /**
     * 获取设备的网络
     */
    NSString * netWork = [UIDevice getWifiName];
    NSLog(@"网络：%@", netWork);
    
    
}





@end
