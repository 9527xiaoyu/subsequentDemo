//
//  EveryDayModel.m
//  开眼
//
//  Created by juvham on 16/1/21.
//  Copyright © 2016年 juvham. All rights reserved.
//

#import "SubsequentModel.h"

@implementation SubsequentModel

+ (instancetype)subsequentModelWithDict:(NSDictionary *)dict{
    SubsequentModel *model = [[SubsequentModel alloc]init];
    if (dict != nil) {
        NSString *link = [dict objectForKey:@"link"];
        model.link = link;
        NSString *publishDate = [dict objectForKey:@"publishDate"];
        model.publishDate = publishDate;
        NSString *imageUrl = [dict objectForKey:@"imageUrl"];
        model.imageUrl = imageUrl;
        NSString *title = [dict objectForKey:@"title"];
        model.title = title;
    }
    return model;
}

@end
