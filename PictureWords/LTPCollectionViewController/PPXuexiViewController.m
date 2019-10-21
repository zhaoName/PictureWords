//
//  PPXuexiViewController.m
//  LearnWord
//
//  Created by famin on 2019/4/4.
//  Copyright © 2019年 english. All rights reserved.
//

#import "PPXuexiViewController.h"
#import "CCDraggableContainer.h"
#import "PPXueXiCardView.h"

@interface PPXuexiViewController ()<CCDraggableContainerDelegate, CCDraggableContainerDataSource>

@property (nonatomic, strong) CCDraggableContainer *container; /**< 卡片*/

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *engLabel;
@property (weak, nonatomic) IBOutlet UILabel *chLabel;
@property (weak, nonatomic) IBOutlet UILabel *styleLabel;
@property (weak, nonatomic) IBOutlet UILabel *chContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *enContentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageview;

@property (nonatomic,strong) UIButton *rightButton ;
@property (nonatomic,assign) NSInteger currentIndex ;
@end

@implementation PPXuexiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = [NSString stringWithFormat:@"1/%zd", self.datasource.count];
    self.view.backgroundColor = [[ZZMediator defaultZZMediator] cat_colorWithHexString:@"0xefefef"];
    
    self.container = [[CCDraggableContainer alloc] initWithFrame:CGRectMake(20, 125, ScreenWidth-40, 436) style:CCDraggableStyleUpOverlay];
    self.container.delegate = self;
    self.container.dataSource = self;
    [self.view addSubview:self.container];
    [self.container reloadData];
    
    if (self.isShowCollectionButton) {
        self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightButton.frame = CGRectMake(0, 0, 40, 40);
        [self.rightButton setImage:[UIImage imageNamed:@"collecting"] forState:UIControlStateNormal];
        [self.rightButton setImage:[UIImage imageNamed:@"collected"] forState:UIControlStateSelected];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
        [self.rightButton addTarget:self action:@selector(clickCollection:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark -- CCDraggableContainerDataSource

- (NSInteger)numberOfIndexs
{
    return self.datasource.count;
}

- (CCDraggableCardView *)draggableContainer:(CCDraggableContainer *)draggableContainer viewForIndex:(NSInteger)index
{
    PPXueXiCardView *cardView = [[PPXueXiCardView alloc] initWithFrame:draggableContainer.bounds];
    NSDictionary *dic = [self.datasource objectAtIndex:index];
    DataModel *model = [DataModel modelWithDictionary:dic];
    [cardView showCardView:model];
    return cardView;
}

#pragma mark -- CCDraggableContainerDelegate

- (void)draggableContainer:(CCDraggableContainer *)draggableContainer cardView:(CCDraggableCardView *)cardView draggableDirection:(CCDraggableDirection)draggableDirection horizontalOffset:(CGFloat)offset
{
    //NSLog(@"%f", offset);
}

- (void)draggableContainer:(CCDraggableContainer *)draggableContainer draggableDirection:(CCDraggableDirection)draggableDirection didSelectIndex:(NSInteger)didSelectIndex move:(BOOL)moveEnd
{
    if (moveEnd) {
        self.currentIndex++;
        NSInteger index = MIN(self.currentIndex+1, self.datasource.count);
        self.navigationItem.title = [NSString stringWithFormat:@"%zd/%zd", index, self.datasource.count];
    }
}

#pragma mark -- IBAction

- (void)clickCollection:(UIButton *)sender
{
//    sender.selected = !sender.selected;
//    NSDictionary *dic = [self.datasource objectAtIndex:self.currentIndex];
//    DataModel *model = [DataModel modelWithDictionary:dic];
//    if (sender.selected) {
//        [[PPDataManager shareManager] ltp_addCollectionModel:model];
//    }else
//    {
//        [[PPDataManager shareManager] ltp_removeCollectionModel:model]
//    }
}



@end
