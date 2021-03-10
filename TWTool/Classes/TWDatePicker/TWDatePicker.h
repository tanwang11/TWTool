//
//  TWDatePicker.h
//  TWTool_Example
//
//  Created by TW on 2021/3/10.
//  Copyright © 2021 tanwang11. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSDate+TWDatePicker.h"

NS_ASSUME_NONNULL_BEGIN

#define PdpRGBA(r, g, b, a) [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:a]

typedef void(^TWDatePickerDateBlock)(NSDate * _Nullable date);

/**
 *  弹出日期类型
 */
typedef NS_ENUM(int, TWDatePickerStyle) {
    TWDatePickerStyle_YMDHM = 0,//年月日时分
    TWDatePickerStyle_MDHM,     //月日时分
    TWDatePickerStyle_YMD,      //年月日
    TWDatePickerStyle_YM,       //年月
    TWDatePickerStyle_MD,       //月日
    TWDatePickerStyle_HM,       //时分
    TWDatePickerStyle_Y,        //年
    TWDatePickerStyle_M,        //月
    TWDatePickerStyle_DHM,      //日时分
};


@interface TWDatePicker : UIView

/**
 *  确定按钮颜色
 */
@property (nonatomic, strong) UIColor *doneBTColor;
/**
 *  长期按钮颜色
 */
@property (nonatomic, strong) UIColor *longTimeBTColor;
/**
 *  年-月-日-时-分 文字颜色(默认橙色)
 */
@property (nonatomic, strong) UIColor *dateLabelColor;
/**
 *  滚轮日期颜色(默认黑色)
 */
@property (nonatomic, strong) UIColor *datePickerColor;

/**
 *  限制最大时间（默认2099）datePicker大于最大日期则滚动回最大限制日期
 */
@property (nonatomic, strong) NSDate *maxLimitDate;
/**
 *  限制最小时间（默认0） datePicker小于最小日期则滚动回最小限制日期
 */
@property (nonatomic, strong) NSDate *minLimitDate;

/**
 *  大号年份字体颜色(默认灰色)想隐藏可以设置为clearColor
 */
@property (nonatomic, strong) UIColor *yearLabelColor;

/**
 *  隐藏背景年份文字
 */
@property (nonatomic        ) BOOL hideBackgroundYearLabel;

/**
 *  是否显示 “长期” 按钮，默认为 NO
 */
@property (nonatomic        ) BOOL showLongTime;


@property (nonatomic, strong) UIView       * bottomView;
@property (nonatomic, strong) UILabel      * showYearLabel;
@property (nonatomic, strong) UIButton     * doneBT;
@property (nonatomic, strong) UIButton     * longTimeBT; // 长期有效按钮, showLongTime 设置为 YES 时显示，点击返回 nil

@property (nonatomic, strong) UIPickerView * datePicker;
@property (nonatomic, strong) NSDate       * scrollToDate;//滚到指定日期

@property (nonatomic, copy  ) TWDatePickerDateBlock doneBlock;
@property (nonatomic        ) TWDatePickerStyle datePickerStyle;

/**
 默认滚动到当前时间
 */
- (instancetype)initWithDateStyle:(TWDatePickerStyle)datePickerStyle CompleteBlock:(TWDatePickerDateBlock)completeBlock;

/**
 滚动到指定的的日期
 */
- (instancetype)initWithDateStyle:(TWDatePickerStyle)datePickerStyle scrollToDate:(NSDate *)scrollToDate CompleteBlock:(TWDatePickerDateBlock)completeBlock;

- (void)show;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
