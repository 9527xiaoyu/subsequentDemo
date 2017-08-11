//
//  ModifyCollectionView.m
//  PostHTTPSDemo
//
//  Created by 杨晓宇 on 2017/8/10.
//  Copyright © 2017年 com.ywart. All rights reserved.
//

#import "SubsequentView.h"
#import "SubsequentCell.h"
#import <Masonry.h>


#import "subsequentModel.h"

#define kCell @"kCell"

@interface SubsequentView()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *myScroll;


@property (nonatomic ,assign) CGFloat offsetY;
@property (nonatomic ,assign) CGAffineTransform animationTrans;

@end

@implementation SubsequentView

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
    
}

- (void)configView
{
    [self addSubview:self.collectionView];
    [self addRefreshHeader];
    [self addRefreshFoot];
}

- (void)configData
{
    
}

- (void)configConstraint
{
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)reloadView
{
    [self.collectionView reloadData];
}


#pragma mark - Lazy load
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 200);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
        [_collectionView registerClass:[SubsequentCell class] forCellWithReuseIdentifier:kCell];
        [self.collectionView.mj_header beginRefreshing];
    }
    return _collectionView;
}

- (UIScrollView *)myScroll
{
    if (!_myScroll) {
        _myScroll = [[UIScrollView alloc]init];
        _myScroll.userInteractionEnabled = YES;
    }
    return _myScroll;
}

#pragma mark - 更新
- (void)addRefreshHeader
{
    __weak typeof(self) cv = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof(cv) cv= self;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [cv.collectionView reloadData];
            // 结束刷新
            [cv.collectionView.mj_header endRefreshing];
            [cv.delegate headerRefreshIsTouched:YES];
        });
        
    }];
    [header setTitle:@"艺网 www.ywart.com" forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新数据中" forState:MJRefreshStateRefreshing];
    [header setTitle:@"下拉可以刷新" forState:MJRefreshStateIdle];
    self.collectionView.mj_header = header;
}

- (void)addRefreshFoot
{
    __weak typeof(self) cv = self;
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        __strong typeof(cv) cv= self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [cv.collectionView reloadData];
            // 结束刷新
            [cv.collectionView.mj_footer endRefreshing];
            [cv.delegate footRefreshIsTouched:YES];
        });
        
    }];
    [footer setTitle:@"艺网 www.ywart.com" forState:MJRefreshStatePulling];
    [footer setTitle:@"没有更多信息了" forState:MJRefreshStateNoMoreData];
    [footer setTitle:@"正在刷新数据中" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"上拉可以刷新" forState:MJRefreshStateIdle];
    self.collectionView.mj_footer = footer;
}

#pragma mark - Touch-Event/Action
#pragma mark - delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.modelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SubsequentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCell forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
}

//添加每个cell出现时的3D动画
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(SubsequentCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    SubsequentModel *model = self.modelArray[indexPath.row];
//    if (![[SDWebImageManager sharedManager] memoryCachedImageExistsForURL:[NSURL URLWithString:model.imageUrl]]) {
        CATransform3D rotation;//3D旋转
        
        rotation = CATransform3DMakeTranslation(0 ,50 ,20);
        //        rotation = CATransform3DMakeRotation( M_PI_4 , 0.0, 0.7, 0.4);
        //逆时针旋转
        rotation = CATransform3DScale(rotation, 0.9, .9, 1);
        
        rotation.m34 = 1.0/ -600;
        
        cell.layer.shadowColor = [[UIColor blackColor]CGColor];
        cell.layer.shadowOffset = CGSizeMake(10, 10);
        cell.alpha = 0;
        
        cell.layer.transform = rotation;
        
        [UIView beginAnimations:@"rotation" context:NULL];
        //旋转时间
        [UIView setAnimationDuration:0.6];
        cell.layer.transform = CATransform3DIdentity;
        cell.alpha = 1;
        cell.layer.shadowOffset = CGSizeMake(0, 0);
        [UIView commitAnimations];
//    }
    [cell cellOffset];
    cell.model = model;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
        NSArray<SubsequentCell *> *array = [self.collectionView visibleCells];
        
        [array enumerateObjectsUsingBlock:^(SubsequentCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [obj cellOffset];
        }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if ([scrollView isEqual:self.myScroll]) {
        int index = floor((self.myScroll.contentOffset.x - scrollView.frame.size.width / 2) / scrollView.frame.size.width) + 1;
        
        self.currentIndexPath = [NSIndexPath indexPathForRow:index inSection:self.currentIndexPath.section];
        [self.collectionView scrollToItemAtIndexPath:self.currentIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
        [self.collectionView setNeedsDisplay];
        SubsequentCell *cell = (SubsequentCell*)[self.collectionView cellForItemAtIndexPath:self.currentIndexPath];
        
        [cell cellOffset];
        
        CGRect rect = [cell convertRect:cell.bounds toView:nil];
        self.animationTrans = cell.imgView.transform;
        self.offsetY = rect.origin.y;
    }
}

@end
