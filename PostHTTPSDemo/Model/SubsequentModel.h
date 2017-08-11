//
//  EveryDayModel.h
//  开眼
//
//  Created by juvham on 16/1/21.
//  Copyright © 2016年 juvham. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubsequentModel : NSObject

@property (nonatomic, strong) NSString *link;//正文链接
@property (nonatomic, strong) NSString *publishDate;//发布时间
@property (nonatomic, strong) NSString *imageUrl;//图片链接
@property (nonatomic, strong) NSString *title;//标题

+ (instancetype)subsequentModelWithDict:(NSDictionary *)dict;

@end
