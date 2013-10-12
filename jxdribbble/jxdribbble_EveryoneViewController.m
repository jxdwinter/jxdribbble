//
//  jxdribbble_EveryoneViewController.m
//  jxdribbble
//
//  Created by Jiang Xiaodong on 13-10-10.
//  Copyright (c) 2013年 Jiang Xiaodong. All rights reserved.
//

#import "jxdribbble_EveryoneViewController.h"
#import "jxdribbble_shots.h"
#import "jxdribbble_HeaderView.h"
#import "jxdribbble_TableViewCell.h"

@interface jxdribbble_EveryoneViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSUInteger     pageIndex;

@end

@implementation jxdribbble_EveryoneViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Everyone";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, [UIScreen mainScreen].bounds.size.height - 44.0 - 20.0) style:UITableViewStylePlain];
    __weak jxdribbble_EveryoneViewController *weakSelf = self;
    // setup infinite scrolling
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMore];
    }];
    self.scrollForHideNavigation = self.tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setBackgroundView:nil];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];

    self.dataSource = [[NSMutableArray alloc] initWithCapacity:50];
    self.pageIndex = 1;

    [self getData];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 265.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = [indexPath section];

    static NSString *CellIdentifier = @"Cell";
    jxdribbble_shots *shot =  [self.dataSource objectAtIndex:section];
    NSString *url = shot.image_url;
    jxdribbble_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ( cell == nil )
    {
        cell = [[jxdribbble_TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell.shot_imageView setImageWithURL:[NSURL URLWithString:url ] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cell.likesLabel.text = [NSString stringWithFormat:@"likes:%@",shot.likes_count];
    cell.viewsLabel.text = [NSString stringWithFormat:@"views:%@",shot.views_count];
    cell.commentsLabel.text = [NSString stringWithFormat:@"comments:%@",shot.comments_count];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    jxdribbble_shots *shot = [self.dataSource objectAtIndex:section];
    jxdribbble_HeaderView *headerView = [[jxdribbble_HeaderView alloc] initWithPlayerInfo:shot];
    [headerView addTarget:self action:@selector(headerViewTouched :) forControlEvents:UIControlEventTouchUpInside];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}


#pragma mark - HeaderViewTouched

- (void)headerViewTouched : (jxdribbble_HeaderView *)sender
{
    NSLog(@"%@",sender.shot.player.username);
}

#pragma mark - getdata

- (void)getData
{
    if ([CheckNetwork isExistenceNetwork])
    {

        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.dribbble.com/shots/everyone?page=%@",[NSString stringWithFormat:@"%lu",(unsigned long)self.pageIndex]]];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSDictionary *jsonDic = JSON;
            NSLog(@"App.net Global Stream: %@", jsonDic);
            NSArray *shots = [jsonDic objectForKey:@"shots"];
            NSMutableArray *dataArray = [[NSMutableArray alloc] initWithCapacity:50];
            for (NSDictionary * shotDic in shots)
            {
                jxdribbble_shots  *shot = [[jxdribbble_shots alloc] initWithShotInfo:shotDic];
                [dataArray addObject:shot];
            }
            
            [self.dataSource addObjectsFromArray:dataArray];
            [self.tableView reloadData];

            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
        } failure:nil];
        
        [operation start];
    }
    else
    {
        
    }
    
}

#pragma mark - loadMore

- (void)loadMore
{
    NSLog(@"loadMore");
    
    __weak jxdribbble_EveryoneViewController *weakSelf = self;
    
    int64_t delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
       self.pageIndex++;
       [self getData];
       [weakSelf.tableView.infiniteScrollingView stopAnimating];
    });
}

@end
