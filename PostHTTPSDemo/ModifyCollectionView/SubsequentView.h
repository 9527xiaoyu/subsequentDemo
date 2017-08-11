//
//  ModifyCollectionView.h
//  PostHTTPSDemo
//
//  Created by 杨晓宇 on 2017/8/10.
//  Copyright © 2017年 com.ywart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TFHpple.h>
#import <MJRefresh.h>

@protocol SubsequentViewDelegate <NSObject>

- (void)headerRefreshIsTouched:(BOOL)touch;
- (void)footRefreshIsTouched:(BOOL)touch;

@end

@interface SubsequentView : UIView

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@property (nonatomic, strong) NSMutableArray *modelArray;

@property (nonatomic, weak) id<SubsequentViewDelegate> delegate;

- (void)reloadView;

@end
