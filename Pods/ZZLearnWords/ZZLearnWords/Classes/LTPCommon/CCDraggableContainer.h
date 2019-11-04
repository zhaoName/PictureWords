//
//  CCDraggableContainer.h
//  CCDraggableCard-Master
//
//  Created by jzzx on 16/7/6.
//  Copyright © 2016年 xmj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CCDraggableConfig.h"
#import "CCDraggableCardView.h"

@class CCDraggableContainer;


/**
 Delegate
 */
@protocol CCDraggableContainerDelegate <NSObject>

@optional
- (void)draggableContainer:(CCDraggableContainer *)draggableContainer
                  cardView:(CCDraggableCardView *)cardView
        draggableDirection:(CCDraggableDirection)draggableDirection
          horizontalOffset:(CGFloat)offset;
-(void)draggableContainer:(CCDraggableContainer *)draggableContainer
       draggableDirection:(CCDraggableDirection)draggableDirection didSelectIndex:(NSInteger)didSelectIndex move:(BOOL)moveEnd;
- (void)draggableContainer:(CCDraggableContainer *)draggableContainer
                  cardView:(CCDraggableCardView *)cardView
            didSelectIndex:(NSInteger)didSelectIndex;

- (void)draggableContainer:(CCDraggableContainer *)draggableContainer draggableDirection:(CCDraggableDirection)draggableDirection finishedDraggableLastCard:(BOOL)finishedDraggableLastCard;

@end

/**
 DataSource
 */
@protocol CCDraggableContainerDataSource <NSObject>

@required
- (CCDraggableCardView *)draggableContainer:(CCDraggableContainer *)draggableContainer
                               viewForIndex:(NSInteger)index;

- (NSInteger)numberOfIndexs;

@end

/**
 CCDraggableContainer
 */
@interface CCDraggableContainer : UIView

@property (nonatomic, weak) IBOutlet id <CCDraggableContainerDelegate>delegate;
@property (nonatomic, weak) IBOutlet id <CCDraggableContainerDataSource>dataSource;

@property (nonatomic) CCDraggableStyle     style;
@property (nonatomic) CCDraggableDirection direction;

- (instancetype)initWithFrame:(CGRect)frame style:(CCDraggableStyle)style;
- (void)removeForDirection:(CCDraggableDirection)direction;
- (void)reloadData;

@end
