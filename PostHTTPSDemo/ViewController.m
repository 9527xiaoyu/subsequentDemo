//
//  ViewController.m
//  PostHTTPSDemo
//
//  Created by 杨晓宇 on 2017/8/10.
//  Copyright © 2017年 com.ywart. All rights reserved.
//

#import "ViewController.h"
//#import <AFNetworking.h>

#import <Masonry.h>

#import "SubsequentView.h"
#import "SubsequentModel.h"

#import <MJRefresh.h>

#define URL @"https://pages.ywart.com/news-dana"

@interface ViewController ()<SubsequentViewDelegate>
@property (nonatomic, strong) SubsequentView *modView;
@property (nonatomic, strong) NSMutableDictionary *avatarMutableDict;
@property (nonatomic, strong) NSMutableArray *avatarMutableArray;

@property (nonatomic, assign) NSInteger index;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.avatarMutableArray = [@[] mutableCopy];
    self.avatarMutableDict = [@{} mutableCopy];
    self.index = 0;
    [self.view addSubview:self.modView];
    [self.modView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self json];
    
    [self.modView.collectionView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)json{
    NSString *url = @"https://pages.ywart.com/news-dana";
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:data];
    
    NSArray *dataArr = [xpathParser searchWithXPathQuery:@"//article[@class = 'content-item page spec-index-item']"];
    
    for (TFHppleElement *element in dataArr) {
#pragma 取出HTML中的链接和发布时间
        if ([[element objectForKey:@"class"] isEqualToString:@"content-item page spec-index-item"]) {
            NSArray *LinkElementsArr = [element searchWithXPathQuery:@"//a"];
            for (TFHppleElement *tempAElement in LinkElementsArr) {
                //链接
                NSString *linkStr = [tempAElement objectForKey:@"href"];
                NSString *subStr = [@"http:" stringByAppendingString:linkStr];
                //发布时间
                NSString *titleStr =  [tempAElement content];
                NSString *f1 = [titleStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                NSString *resust = [f1 substringToIndex:10];
                [self.avatarMutableDict setObject:subStr forKey:@"link"];
                [self.avatarMutableDict setObject:resust forKey:@"publishDate"];
            }
#pragma 取图片和标题
            NSArray *IMGElementsArr = [element searchWithXPathQuery:@"//img"];
            for (TFHppleElement *tempAElement in IMGElementsArr) {
                //图片
                NSString *imgStr = [tempAElement objectForKey:@"src"];
                NSString *subStr = [@"http:" stringByAppendingString:imgStr];
                //标题
                NSString *titleStr = [tempAElement objectForKey:@"alt"];
                NSString *realStr = [titleStr stringByReplacingOccurrencesOfString:@"  预览图" withString:@""];
                [self.avatarMutableDict setObject:subStr forKey:@"imageUrl"];
                [self.avatarMutableDict setObject:realStr forKey:@"title"];
            }
#pragma 存入模型
            SubsequentModel *model = [SubsequentModel subsequentModelWithDict:self.avatarMutableDict];
            [self.avatarMutableArray addObject:model];
        }
    }
}


- (SubsequentView *)modView
{
    if (!_modView) {
        _modView = [[SubsequentView alloc]init];
        _modView.delegate = self;
    }
    return _modView;
}


- (void)headerRefreshIsTouched:(BOOL)touch
{
    if (touch) {
        NSMutableArray *temp = [@[] mutableCopy];
        NSInteger tempIdx = 0;
        for (int i=0; i<10; i++) {
            [temp addObject:self.avatarMutableArray[i]];
            tempIdx ++;
        }
        self.modView.modelArray = temp;
        self.index = tempIdx;
        [self.modView reloadView];
    }
}

- (void)footRefreshIsTouched:(BOOL)touch
{
    if (touch) {
        NSMutableArray *temp = [@[] mutableCopy];
        NSInteger tempIdx = self.index;
        
        for (int i=1; i<=10; i++) {
            if (self.avatarMutableArray.count>(tempIdx+i)) {
                [temp addObject:self.avatarMutableArray[tempIdx]];
                tempIdx ++;
            }else{
                [temp addObject:self.avatarMutableArray[tempIdx]];
                break;
            }
        }
        [self.modView.modelArray addObjectsFromArray:temp];
        self.index = tempIdx;
        [self.modView reloadView];
    }
}

@end
