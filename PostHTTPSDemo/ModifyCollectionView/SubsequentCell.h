//
//  ModifyCollectionCell.h
//  PostHTTPSDemo
//
//  Created by 杨晓宇 on 2017/8/10.
//  Copyright © 2017年 com.ywart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+WebCache.h>
#import "SubsequentModel.h"

@interface SubsequentCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *mainTitle;
@property (nonatomic, strong) SubsequentModel *model;

- (CGFloat)cellOffset;

@end
