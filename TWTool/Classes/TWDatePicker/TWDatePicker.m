//
//  TWDatePicker.m
//  TWTool_Example
//
//  Created by TW on 2021/3/10.
//  Copyright © 2021 tanwang11. All rights reserved.
//

#import "TWDatePicker.h"

#define PdpScreenWidth       [UIScreen mainScreen].bounds.size.width
#define PdpScreenHeight      [UIScreen mainScreen].bounds.size.height
#define PdpPickerSize        self.datePicker.frame.size

#define PdpMaxYear           2099
#define PdpMinYear           1900

#define PickViewHeight       270
#define PickViewLabelHeight  226
#define PickViewButtonHeight 44

@interface TWDatePicker ()<UIPickerViewDelegate,UIPickerViewDataSource,UIGestureRecognizerDelegate> {
    //日期存储数组
    NSMutableArray *_yearArray;
    NSMutableArray *_monthArray;
    NSMutableArray *_dayArray;
    NSMutableArray *_hourArray;
    NSMutableArray *_minuteArray;
    NSString *_dateFormatter;
    //记录位置
    NSInteger yearIndex;
    NSInteger monthIndex;
    NSInteger dayIndex;
    NSInteger hourIndex;
    NSInteger minuteIndex;
    
    NSInteger preRow;
    
    NSDate *_startDate;
}

@end

@implementation TWDatePicker

/**
 默认滚动到当前时间
 */
- (instancetype)initWithDateStyle:(TWDatePickerStyle)datePickerStyle CompleteBlock:(TWDatePickerDateBlock)completeBlock {
    if (self = [super init]) {
        self.datePickerStyle = datePickerStyle;
        switch (datePickerStyle) {
            case TWDatePickerStyle_YMDHM:
                _dateFormatter = @"yyyy-MM-dd HH:mm";
                break;
            case TWDatePickerStyle_MDHM:
                _dateFormatter = @"yyyy-MM-dd HH:mm";
                break;
            case TWDatePickerStyle_YMD:
                _dateFormatter = @"yyyy-MM-dd";
                break;
            case TWDatePickerStyle_YM:
                _dateFormatter = @"yyyy-MM";
                break;
            case TWDatePickerStyle_MD:
                _dateFormatter = @"yyyy-MM-dd";
                break;
            case TWDatePickerStyle_HM:
                _dateFormatter = @"HH:mm";
                break;
            case TWDatePickerStyle_Y:
                _dateFormatter = @"yyyy";
                break;
            case TWDatePickerStyle_M:
                _dateFormatter = @"MM";
                break;
            case TWDatePickerStyle_DHM:
                _dateFormatter = @"dd HH:mm";
                break;
            default:
                _dateFormatter = @"yyyy-MM-dd HH:mm";
                break;
        }
        
        [self setupUI];
        [self defaultConfig];
        
        self.doneBlock = completeBlock;
    }
    return self;
}

/**
 滚动到指定的的日期
 */
- (instancetype)initWithDateStyle:(TWDatePickerStyle)datePickerStyle scrollToDate:(NSDate *)scrollToDate CompleteBlock:(TWDatePickerDateBlock)completeBlock {
    if (self = [super init]) {
        self.datePickerStyle = datePickerStyle;
        self.scrollToDate = scrollToDate;
        switch (datePickerStyle) {
            case TWDatePickerStyle_YMDHM:
                _dateFormatter = @"yyyy-MM-dd HH:mm";
                break;
            case TWDatePickerStyle_MDHM:
                _dateFormatter = @"yyyy-MM-dd HH:mm";
                break;
            case TWDatePickerStyle_YMD:
                _dateFormatter = @"yyyy-MM-dd";
                break;
            case TWDatePickerStyle_YM:
                _dateFormatter = @"yyyy-MM";
                break;
            case TWDatePickerStyle_MD:
                _dateFormatter = @"yyyy-MM-dd";
                break;
            case TWDatePickerStyle_HM:
                _dateFormatter = @"HH:mm";
                break;
            case TWDatePickerStyle_Y:
                _dateFormatter = @"yyyy";
                break;
            case TWDatePickerStyle_M:
                _dateFormatter = @"MM";
                break;
            case TWDatePickerStyle_DHM:
                _dateFormatter = @"dd HH:mm";
                break;
            default:
                _dateFormatter = @"yyyy-MM-dd HH:mm";
                break;
        }
        
        [self setupUI];
        [self defaultConfig];
        
        self.doneBlock = completeBlock;
    }
    return self;
}

- (void)setupUI {
    self.frame = CGRectMake(0, 0, PdpScreenWidth, PdpScreenHeight);
    //NSLog(@"frame: %@", NSStringFromCGRect(self.frame));
    self.bottomView = ({
        UIView * view = [UIView new];
        view.layer.cornerRadius  = 10;
        view.layer.masksToBounds = YES;
        view.frame               = CGRectMake(10, self.frame.size.height-PickViewHeight - [TWDatePicker safeBottomMargin], self.frame.size.width-20, PickViewHeight);
        view.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:view];
        view;
    });
    self.showYearLabel = ({
        UILabel * l = [UILabel new];
        l.frame              = CGRectMake(0, 0, self.bottomView.frame.size.width, PickViewLabelHeight);
        l.backgroundColor    = [UIColor clearColor];
        l.font               = [UIFont systemFontOfSize:110];
        l.textColor          = PdpRGBA(233, 237, 242, 1);
        l.textAlignment      = NSTextAlignmentCenter;
        l.userInteractionEnabled = NO;
        
        [self.bottomView addSubview:l];
        l;
    });
    self.doneBT = ({
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, PickViewLabelHeight, self.bottomView.frame.size.width, PickViewButtonHeight);
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self.bottomView addSubview:button];
        
        [button addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
        
        button;
    });
    self.longTimeBT = ({
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, PickViewLabelHeight, 0, PickViewButtonHeight);
        [button setTitle:@"长期" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self.bottomView addSubview:button];
        
        [button addTarget:self action:@selector(longTimeAction:) forControlEvents:UIControlEventTouchUpInside];
        
        button;
    });
    
    self.datePicker = ({
        UIPickerView * dp = [[UIPickerView alloc] initWithFrame:self.showYearLabel.bounds];
        dp.showsSelectionIndicator = YES;
        dp.delegate   = self;
        dp.dataSource = self;
        
        [self.bottomView addSubview:dp];
        dp;
    });

    self.doneBTColor        = PdpRGBA(247, 133, 51, 1);
    self.longTimeBTColor    = PdpRGBA(210, 210, 210, 1);
    self.doneBT.backgroundColor     = self.doneBTColor;
    self.longTimeBT.backgroundColor = self.longTimeBTColor;
    
    //点击背景是否影藏
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    self.backgroundColor = PdpRGBA(0, 0, 0, 0);
    [self layoutIfNeeded];
    
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
}

- (void)defaultConfig {
    if (!_scrollToDate) {
        _scrollToDate = [NSDate date];
    }
    
    //循环滚动时需要用到
    preRow       = (self.scrollToDate.year-PdpMinYear)*12+self.scrollToDate.month-1;

    //设置年月日时分数据
    _yearArray   = [self setArray:_yearArray];
    _monthArray  = [self setArray:_monthArray];
    _dayArray    = [self setArray:_dayArray];
    _hourArray   = [self setArray:_hourArray];
    _minuteArray = [self setArray:_minuteArray];
    
    for (int i=0; i<60; i++) {
        NSString *num = [NSString stringWithFormat:@"%02d",i];
        if (0<i && i<=12) {
            [_monthArray addObject:num];
        }
        if (i<24) {
            [_hourArray addObject:num];
        }
        [_minuteArray addObject:num];
    }
    for (NSInteger i=PdpMinYear; i<=PdpMaxYear; i++) {
        NSString *num = [NSString stringWithFormat:@"%ld",(long)i];
        [_yearArray addObject:num];
    }
    
    // !!!:设置的最大时间在这里无效，在时间选择器滚动过程中生效
    //最大最小限制
    if (!self.maxLimitDate) {
        self.maxLimitDate = [NSDate date:@"2099-12-31 23:59" WithFormat:@"yyyy-MM-dd HH:mm"];
    }
    //最小限制
    if (!self.minLimitDate) {
        self.minLimitDate = [NSDate date:@"1900-01-01 00:00" WithFormat:@"yyyy-MM-dd HH:mm"];
    }
}

- (void)addLabelWithName:(NSArray *)nameArr {
    for (id subView in self.showYearLabel.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            [subView removeFromSuperview];
        }
    }
    
    if (!_dateLabelColor) {
        _dateLabelColor =  PdpRGBA(247, 133, 51, 1);
    }
    
    for (int i=0; i<nameArr.count; i++) {
        CGFloat labelX = PdpPickerSize.width/(nameArr.count*2)+18+PdpPickerSize.width/nameArr.count*i;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(labelX, self.showYearLabel.frame.size.height/2-15/2.0, 15, 15)];
        label.text = nameArr[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor =  _dateLabelColor;
        label.backgroundColor = [UIColor clearColor];
        [self.showYearLabel addSubview:label];
    }
}


- (void)setDateLabelColor:(UIColor *)dateLabelColor {
    _dateLabelColor = dateLabelColor;
    for (id subView in self.showYearLabel.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            UILabel *label = subView;
            label.textColor = _dateLabelColor;
        }
    }
}


- (NSMutableArray *)setArray:(id)mutableArray {
    if (mutableArray)
        [mutableArray removeAllObjects];
    else
        mutableArray = [NSMutableArray array];
    return mutableArray;
}

- (void)setYearLabelColor:(UIColor *)yearLabelColor {
    self.showYearLabel.textColor = yearLabelColor;
}

#pragma mark - UIPickerViewDelegate,UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    switch (self.datePickerStyle) {
        case TWDatePickerStyle_YMDHM:
            [self addLabelWithName:@[@"年",@"月",@"日",@"时",@"分"]];
            return 5;
        case TWDatePickerStyle_MDHM:
            [self addLabelWithName:@[@"月",@"日",@"时",@"分"]];
            return 4;
        case TWDatePickerStyle_YMD:
            [self addLabelWithName:@[@"年",@"月",@"日"]];
            return 3;
        case TWDatePickerStyle_YM:
            [self addLabelWithName:@[@"年",@"月"]];
            return 2;
        case TWDatePickerStyle_MD:
            [self addLabelWithName:@[@"月",@"日"]];
            return 2;
        case TWDatePickerStyle_HM:
            [self addLabelWithName:@[@"时",@"分"]];
            return 2;
        case TWDatePickerStyle_Y:
            [self addLabelWithName:@[@"年"]];
            return 1;
        case TWDatePickerStyle_M:
            [self addLabelWithName:@[@"月"]];
            return 1;
        case TWDatePickerStyle_DHM:
            [self addLabelWithName:@[@"日",@"时",@"分"]];
            return 3;
        default:
            return 0;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSArray *numberArr = [self getNumberOfRowsInComponent];
    return [numberArr[component] integerValue];
}

- (NSArray *)getNumberOfRowsInComponent {
    
    NSInteger yearNum = _yearArray.count;
    NSInteger monthNum = _monthArray.count;
    NSInteger dayNum = [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
    
    NSInteger dayNum2 = [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:1];//确保可以选到31日
    
    NSInteger hourNum = _hourArray.count;
    NSInteger minuteNUm = _minuteArray.count;
    
    NSInteger timeInterval = PdpMaxYear - PdpMinYear;
    
    switch (self.datePickerStyle) {
        case TWDatePickerStyle_YMDHM:
            return @[@(yearNum),@(monthNum),@(dayNum),@(hourNum),@(minuteNUm)];
            break;
        case TWDatePickerStyle_MDHM:
            return @[@(monthNum*timeInterval),@(dayNum),@(hourNum),@(minuteNUm)];
            break;
        case TWDatePickerStyle_YMD:
            return @[@(yearNum),@(monthNum),@(dayNum)];
            break;
        case TWDatePickerStyle_YM:
            return @[@(yearNum),@(monthNum)];
            break;
        case TWDatePickerStyle_MD:
            return @[@(monthNum*timeInterval),@(dayNum),@(hourNum)];
            break;
        case TWDatePickerStyle_HM:
            return @[@(hourNum),@(minuteNUm)];
            break;
        case TWDatePickerStyle_Y:
            return @[@(yearNum)];
            break;
        case TWDatePickerStyle_M:
            return @[@(monthNum)];
            break;
        case TWDatePickerStyle_DHM:
            return @[@(dayNum2),@(hourNum),@(minuteNUm)];
            break;
        default:
            return @[];
            break;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *customLabel = (UILabel *)view;
    if (!customLabel) {
        customLabel = [[UILabel alloc] init];
        customLabel.textAlignment = NSTextAlignmentCenter;
        [customLabel setFont:[UIFont systemFontOfSize:17]];
    }
    NSString *title;
    
    switch (self.datePickerStyle) {
        case TWDatePickerStyle_YMDHM:
            if (component==0) {
                title = _yearArray[row];
            }
            if (component==1) {
                title = _monthArray[row];
            }
            if (component==2) {
                title = _dayArray[row];
            }
            if (component==3) {
                title = _hourArray[row];
            }
            if (component==4) {
                title = _minuteArray[row];
            }
            break;
        case TWDatePickerStyle_YMD:
            if (component==0) {
                title = _yearArray[row];
            }
            if (component==1) {
                title = _monthArray[row];
            }
            if (component==2) {
                title = _dayArray[row];
            }
            break;
        case TWDatePickerStyle_YM:
            if (component==0) {
                title = _yearArray[row];
            }
            if (component==1) {
                title = _monthArray[row];
            }
            break;
        case TWDatePickerStyle_MDHM:
            if (component==0) {
                title = _monthArray[row%12];
            }
            if (component==1) {
                title = _dayArray[row];
            }
            if (component==2) {
                title = _hourArray[row];
            }
            if (component==3) {
                title = _minuteArray[row];
            }
            break;
        case TWDatePickerStyle_MD:
            if (component==0) {
                title = _monthArray[row%12];
            }
            if (component==1) {
                title = _dayArray[row];
            }
            break;
        case TWDatePickerStyle_HM:
            if (component==0) {
                title = _hourArray[row];
            }
            if (component==1) {
                title = _minuteArray[row];
            }
            break;
        case TWDatePickerStyle_Y:
            if (component==0) {
                title = _yearArray[row];
            }
            break;
        case TWDatePickerStyle_M:
            if (component==0) {
                title = _monthArray[row];
            }
            break;
        case TWDatePickerStyle_DHM:
            if (component==0) {
                title = _dayArray[row];
            }
            if (component==1) {
                title = _hourArray[row];
            }
            if (component==2) {
                title = _minuteArray[row];
            }
            break;
        default:
            title = @"";
            break;
    }
    
    customLabel.text = title;
    if (!_datePickerColor) {
        _datePickerColor = [UIColor blackColor];
    }
    customLabel.textColor = _datePickerColor;
    return customLabel;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    switch (self.datePickerStyle) {
        case TWDatePickerStyle_YMDHM:{
            if (component == 0) {
                yearIndex = row;
                self.showYearLabel.text =_yearArray[yearIndex];
            }
            if (component == 1) {
                monthIndex = row;
            }
            if (component == 2) {
                dayIndex = row;
            }
            if (component == 3) {
                hourIndex = row;
            }
            if (component == 4) {
                minuteIndex = row;
            }
            if (component == 0 || component == 1){
                [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
                if (_dayArray.count-1<dayIndex) {
                    dayIndex = _dayArray.count-1;
                }
            }
        }
            break;
        case TWDatePickerStyle_YMD:{
            if (component == 0) {
                yearIndex = row;
                self.showYearLabel.text =_yearArray[yearIndex];
            }
            if (component == 1) {
                monthIndex = row;
            }
            if (component == 2) {
                dayIndex = row;
            }
            if (component == 0 || component == 1){
                [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
                if (_dayArray.count-1<dayIndex) {
                    dayIndex = _dayArray.count-1;
                }
            }
        }
            break;
        case TWDatePickerStyle_YM:{
            if (component == 0) {
                yearIndex = row;
                self.showYearLabel.text =_yearArray[yearIndex];
                NSLog(@"yearIndex = %ld", (long)row);
            }
            if (component == 1) {
                monthIndex = row;
                NSLog(@"monthIndex = %ld",(long)row);
            }
        }
            break;
        case TWDatePickerStyle_MDHM:{
            if (component == 1) {
                dayIndex = row;
            }
            if (component == 2) {
                hourIndex = row;
            }
            if (component == 3) {
                minuteIndex = row;
            }
            if (component == 0) {
                [self yearChange:row];
                [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
                if (_dayArray.count-1<dayIndex) {
                    dayIndex = _dayArray.count-1;
                }
            }
            [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
            
        }
            break;
        case TWDatePickerStyle_MD:{
            if (component == 1) {
                dayIndex = row;
            }
            if (component == 0) {
                [self yearChange:row];
                [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
                if (_dayArray.count-1<dayIndex) {
                    dayIndex = _dayArray.count-1;
                }
            }
            [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
        }
            break;
        case TWDatePickerStyle_HM:{
            if (component == 0) {
                hourIndex = row;
            }
            if (component == 1) {
                minuteIndex = row;
            }
        }
            break;
        case TWDatePickerStyle_Y:{
            if (component == 0) {
                yearIndex = row;
                self.showYearLabel.text =_yearArray[yearIndex];
            }
        }
            break;
        case TWDatePickerStyle_M:{
            if (component == 0) {
                monthIndex = row;
            }
        }
            break;
        case TWDatePickerStyle_DHM:{
            if (component == 0) {
                dayIndex = row;
            }
            if (component == 1) {
                hourIndex = row;
            }
            if (component == 2) {
                minuteIndex = row;
            }
        }
            break;
        default:
            break;
    }
    
    [pickerView reloadAllComponents];
    
    NSString *dateStr;
    switch (self.datePickerStyle) {
        case TWDatePickerStyle_YMDHM:{
            dateStr = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",_yearArray[yearIndex],_monthArray[monthIndex],_dayArray[dayIndex],_hourArray[hourIndex],_minuteArray[minuteIndex]];
            break;
        }
        case TWDatePickerStyle_MDHM: {
            dateStr = [NSString stringWithFormat:@"%@-%@ %@:%@", _monthArray[monthIndex],_dayArray[dayIndex],_hourArray[hourIndex],_minuteArray[minuteIndex]];
            break;
        }
        case TWDatePickerStyle_YMD: {
            dateStr = [NSString stringWithFormat:@"%@-%@-%@",_yearArray[yearIndex],_monthArray[monthIndex],_dayArray[dayIndex]];
            break;
        }
        case TWDatePickerStyle_YM: {
            dateStr = [NSString stringWithFormat:@"%@-%@",_yearArray[yearIndex],_monthArray[monthIndex]];
            break;
        }
        case TWDatePickerStyle_MD: {
            // !!!: 原作者这里保留了year属性.
            dateStr = [NSString stringWithFormat:@"%@-%@-%@",_yearArray[yearIndex],_monthArray[monthIndex],_dayArray[dayIndex]];
            break;
        }
        case TWDatePickerStyle_HM: {
            dateStr = [NSString stringWithFormat:@"%@:%@",_hourArray[hourIndex],_minuteArray[minuteIndex]];
            break;
        }
        case TWDatePickerStyle_Y: {
            dateStr = [NSString stringWithFormat:@"%@",_yearArray[yearIndex]];
            break;
        }
        case TWDatePickerStyle_M: {
            dateStr = [NSString stringWithFormat:@"%@",_monthArray[monthIndex]];
            break;
        }
        case TWDatePickerStyle_DHM: {
            dateStr = [NSString stringWithFormat:@"%@ %@:%@",_dayArray[dayIndex],_hourArray[hourIndex],_minuteArray[minuteIndex]];
            break;
        }
        default: {
            dateStr = nil;
            break;
        }
    }
    
    self.scrollToDate = [[NSDate date:dateStr WithFormat:_dateFormatter] dateWithFormatter:_dateFormatter];
    
    if ([self.scrollToDate compare:self.minLimitDate] == NSOrderedAscending) {
        self.scrollToDate = self.minLimitDate;
        [self getNowDate:self.minLimitDate animated:YES];
    }else if ([self.scrollToDate compare:self.maxLimitDate] == NSOrderedDescending){
        self.scrollToDate = self.maxLimitDate;
        [self getNowDate:self.maxLimitDate animated:YES];
    }
    
    _startDate = self.scrollToDate;
}

- (void)yearChange:(NSInteger)row {
    
    monthIndex = row%12;
    
    //年份状态变化
    if (row-preRow <12 && row-preRow>0 && [_monthArray[monthIndex] integerValue] < [_monthArray[preRow%12] integerValue]) {
        yearIndex ++;
    } else if(preRow-row <12 && preRow-row > 0 && [_monthArray[monthIndex] integerValue] > [_monthArray[preRow%12] integerValue]) {
        yearIndex --;
    }else {
        NSInteger interval = (row-preRow)/12;
        yearIndex += interval;
    }
    
    self.showYearLabel.text = _yearArray[yearIndex];
    
    preRow = row;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if( [touch.view isDescendantOfView:self.bottomView]) {
        return NO;
    }
    return YES;
}

#pragma mark - Action
- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomView.frame = CGRectMake(self.bottomView.frame.origin.x, self.frame.size.height-PickViewHeight - [TWDatePicker safeBottomMargin], self.bottomView.frame.size.width, self.bottomView.frame.size.height);
        
        self.backgroundColor = PdpRGBA(0, 0, 0, 0.4);
//        [self layoutIfNeeded];
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomView.frame = CGRectMake(self.bottomView.frame.origin.x, self.frame.size.height, self.bottomView.frame.size.width, self.bottomView.frame.size.height);
        self.backgroundColor = PdpRGBA(0, 0, 0, 0);
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self removeFromSuperview];
    }];
}

- (void)doneAction:(UIButton *)btn {
    _startDate = [self.scrollToDate dateWithFormatter:_dateFormatter];
    
    if (self.doneBlock) {
        self.doneBlock(_startDate);
    }
    [self dismiss];
}

- (void)longTimeAction:(UIButton *)btn {
    if (self.doneBlock) {
        self.doneBlock(nil);
    }
    [self dismiss];
}


#pragma mark - set
- (void)setShowLongTime:(BOOL)showLongTime {
    _showLongTime = showLongTime;
    if (_showLongTime) {
        self.longTimeBT.frame = CGRectMake(0, PickViewLabelHeight, 100, PickViewButtonHeight);
        self.doneBT.frame     = CGRectMake(CGRectGetMaxX(self.longTimeBT.frame), PickViewLabelHeight, self.bottomView.frame.size.width-CGRectGetMaxX(self.longTimeBT.frame), PickViewButtonHeight);
    } else {
        self.longTimeBT.frame = CGRectMake(0, PickViewLabelHeight, 0, PickViewButtonHeight);
        self.doneBT.frame     = CGRectMake(0, PickViewLabelHeight, self.bottomView.frame.size.width, PickViewButtonHeight);
    }
}


#pragma mark - tools
//通过年月求每月天数
- (NSInteger)DaysfromYear:(NSInteger)year andMonth:(NSInteger)month {
    NSInteger num_year  = year;
    NSInteger num_month = month;
    
    BOOL isrunNian = num_year%4==0 ? (num_year%100==0? (num_year%400==0?YES:NO):YES):NO;
    switch (num_month) {
        case 1:case 3:case 5:case 7:case 8:case 10:case 12:{
            [self setdayArray:31];
            return 31;
        }
        case 4:case 6:case 9:case 11:{
            [self setdayArray:30];
            return 30;
        }
        case 2:{
            if (isrunNian) {
                [self setdayArray:29];
                return 29;
            }else{
                [self setdayArray:28];
                return 28;
            }
        }
        default:
            break;
    }
    return 0;
}

//设置每月的天数数组
- (void)setdayArray:(NSInteger)num {
    [_dayArray removeAllObjects];
    for (int i=1; i<=num; i++) {
        [_dayArray addObject:[NSString stringWithFormat:@"%02d",i]];
    }
}

//滚动到指定的时间位置
- (void)getNowDate:(NSDate *)date animated:(BOOL)animated {
    if (!date) {
        date = [NSDate date];
    }
    
    [self DaysfromYear:date.year andMonth:date.month];
    
    yearIndex   = date.year-PdpMinYear;
    monthIndex  = date.month-1;
    dayIndex    = date.day-1;
    hourIndex   = date.hour;
    minuteIndex = date.minute;

    //循环滚动时需要用到
    preRow      = (self.scrollToDate.year-PdpMinYear)*12+self.scrollToDate.month-1;
    
    NSArray *indexArray;
    
    switch (self.datePickerStyle) {
        case TWDatePickerStyle_YMDHM: {
            indexArray = @[@(yearIndex),@(monthIndex),@(dayIndex),@(hourIndex),@(minuteIndex)];
            break;
        }
        case TWDatePickerStyle_MDHM: {
            indexArray = @[@(monthIndex),@(dayIndex),@(hourIndex),@(minuteIndex)];
            break;
        }
        case TWDatePickerStyle_YMD: {
            indexArray = @[@(yearIndex),@(monthIndex),@(dayIndex)];
            break;
        }
        case TWDatePickerStyle_YM: {
            indexArray = @[@(yearIndex),@(monthIndex)];
            break;
        }
        case TWDatePickerStyle_MD: {
            indexArray = @[@(monthIndex),@(dayIndex)];
            break;
        }
        case TWDatePickerStyle_HM: {
            indexArray = @[@(hourIndex),@(minuteIndex)];
            break;
        }
        case TWDatePickerStyle_Y: {
            indexArray = @[@(yearIndex)];
            break;
        }
        case TWDatePickerStyle_M: {
            indexArray = @[@(monthIndex)];
            break;
        }
        case TWDatePickerStyle_DHM: {
            indexArray = @[@(dayIndex),@(hourIndex),@(minuteIndex)];
            break;
        }
            
        default: {
            indexArray = @[@(yearIndex),@(monthIndex),@(dayIndex),@(hourIndex),@(minuteIndex)];
            break;
        }
    }
    
    self.showYearLabel.text = _yearArray[yearIndex];
    
    [self.datePicker reloadAllComponents];
    
    for (int i=0; i<indexArray.count; i++) {
        if ((self.datePickerStyle == TWDatePickerStyle_MDHM || self.datePickerStyle == TWDatePickerStyle_MD)&& i==0) {
            NSInteger mIndex = [indexArray[i] integerValue]+(12*(self.scrollToDate.year - PdpMinYear));
            [self.datePicker selectRow:mIndex inComponent:i animated:animated];
        } else {
            [self.datePicker selectRow:[indexArray[i] integerValue] inComponent:i animated:animated];
        }
    }
}

#pragma mark -
- (void)setMinLimitDate:(NSDate *)minLimitDate {
    _minLimitDate = minLimitDate;
    if ([_scrollToDate compare:self.minLimitDate] == NSOrderedAscending) {
        _scrollToDate = self.minLimitDate;
    }
    [self getNowDate:self.scrollToDate animated:NO];
}

- (void)setdoneBTColor:(UIColor *)doneBTColor {
    _doneBTColor = doneBTColor;
    self.doneBT.backgroundColor = doneBTColor;
}

- (void)setHideBackgroundYearLabel:(BOOL)hideBackgroundYearLabel {
    _showYearLabel.textColor = [UIColor clearColor];
}

+ (BOOL)isIphoneXScreen {
    BOOL iPhoneX = NO;
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.top > 20.0) {
            iPhoneX = YES;
        }
    }
    return iPhoneX;
}

+ (CGFloat)safeBottomMargin {
    if ([self isIphoneXScreen]) {
        return 34;
    }else{
        return 10;
    }
}


@end
