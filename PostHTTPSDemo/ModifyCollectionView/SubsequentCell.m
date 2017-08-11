//
//  ModifyCollectionCell.m
//  PostHTTPSDemo
//
//  Created by 杨晓宇 on 2017/8/10.
//  Copyright © 2017年 com.ywart. All rights reserved.
//

#import "SubsequentCell.h"
#import <Masonry.h>

#define kWidth self.contentView.bounds.size.width
#define kHeight self.contentView.bounds.size.height
@implementation SubsequentCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self anywayInit];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self anywayInit];
}

- (void)anywayInit
{
    [self configParam];
    [self configView];
    [self configData];
    [self configConstraint];
}

- (void)configParam
{
//    self.selectionStyle = UITableViewCellSeparatorStyleNone;
    self.clipsToBounds = YES;
}

- (void)configView
{
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.mainTitle];
}

- (void)configData{}

- (void)configConstraint
{
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.contentView).offset(0);
    }];
}

#pragma mark - Lazy load
- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -(kHeight/1.7 -100)/2, kWidth, kHeight/1.7)];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imgView;
}

- (UILabel *)mainTitle
{
    if (!_mainTitle) {
        _mainTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 250/2-20, kWidth, 40)];
        _mainTitle.textAlignment = NSTextAlignmentCenter;
        _mainTitle.textColor = [UIColor whiteColor];
        _mainTitle.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    }
    return _mainTitle;
}
#pragma mark - Touch-Event/Action
#pragma mark - delegate

- (CGFloat)cellOffset {
    
    CGRect centerToWindow = [self convertRect:self.bounds toView:self.window];
    CGFloat centerY = CGRectGetMidY(centerToWindow);
    CGPoint windowCenter = self.superview.center;
    
    CGFloat cellOffsetY = centerY - windowCenter.y;
    
    CGFloat offsetDig =  cellOffsetY / self.superview.frame.size.height *2;
    CGFloat offset =  -offsetDig * (kHeight/2 - 100)/2;
    
    CGAffineTransform transY = CGAffineTransformMakeTranslation(0,offset);
    
    self.imgView.transform = transY;
    
    return offset;
}

- (void)setModel:(SubsequentModel *)model
{
    if (_model != model) {
        _model = model;
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:nil];
    }
}
@end
