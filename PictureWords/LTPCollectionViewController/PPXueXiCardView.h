//
//  PPXueXiCardView.h
//  LearnWord
//
//  Created by zhao on 2019/4/9.
//  Copyright © 2019 english. All rights reserved.
//

#import "CCDraggableCardView.h"

NS_ASSUME_NONNULL_BEGIN
@class DataModel;
@interface PPXueXiCardView : CCDraggableCardView

- (void)showCardView:(DataModel *)model;

@end

NS_ASSUME_NONNULL_END
