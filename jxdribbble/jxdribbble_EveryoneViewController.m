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
#import "jxdribbble_DetailViewController.h"
#import "jxdribbble_PlayerViewController.h"

@interface jxdribbble_EveryoneViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

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
    
    self.title = @"EVERYONE";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, [UIScreen mainScreen].bounds.size.height - 44.0 - 20.0) style:UITableViewStylePlain];
    __weak jxdribbble_EveryoneViewController *weakSelf = self;
    // setup pull-to-refresh
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf refresh];
    }];
    // setup infinite scrolling
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMore];
    }];
    //self.scrollForHideNavigation = self.tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollsToTop = YES;
    self.tableView.scrollEnabled = YES;
    [self.tableView setBackgroundView:nil];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];

    self.dataSource = [[NSMutableArray alloc] initWithCapacity:50];
    self.pageIndex = 1;

    [self getData];

}

- (BOOL) scrollViewShouldScrollToTop:(UIScrollView*) scrollView
{
    if (scrollView == self.tableView)
    {
        return YES;
    }
    else
    {
        return NO;
    }
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
    return 255.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = [indexPath section];

    static NSString *CellIdentifier = @"Cell";
    jxdribbble_shots *shot =  [self.dataSource objectAtIndex:section];
    //NSString *url = shot.image_url;
    jxdribbble_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ( cell == nil )
    {
        cell = [[jxdribbble_TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell.shot_imageView setImageWithURL:[NSURL URLWithString:shot.image_url] placeholderImage:[UIImage imageNamed:@"placeholder"]];
     

    cell.likesLabel.text = [NSString stringWithFormat:@"❤️ %@",shot.likes_count];
    cell.viewsLabel.text = [NSString stringWithFormat:@"👀 %@",shot.views_count];
    cell.commentsLabel.text = [NSString stringWithFormat:@"💬 %@",shot.comments_count];
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
    NSLog(@"%@",[(jxdribbble_shots *)[self.dataSource objectAtIndex:indexPath.section] title]);
    
    jxdribbble_DetailViewController *detail = [[jxdribbble_DetailViewController alloc] init];
    detail.shot = (jxdribbble_shots *)[self.dataSource objectAtIndex:indexPath.section];
    [self.navigationController pushViewController:detail animated:YES];
}


#pragma mark - HeaderViewTouched

- (void)headerViewTouched : (jxdribbble_HeaderView *)sender
{
    NSLog(@"%@",sender.shot.player.username);
    
    jxdribbble_PlayerViewController *playerViewController = [[jxdribbble_PlayerViewController alloc] init];
    playerViewController.player = sender.shot.player;
    [self.navigationController pushViewController:playerViewController animated:YES];
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
            //NSLog(@"App.net Global Stream: %@", jsonDic);
            NSArray *shots = [jsonDic objectForKey:@"shots"];
            NSMutableArray *dataArray = [[NSMutableArray alloc] initWithCapacity:50];
            for (NSDictionary * shotDic in shots)
            {
                jxdribbble_shots  *shot = [[jxdribbble_shots alloc] initWithShotInfo:shotDic];
                
                if ( self.pageIndex != 1 )
                {
                    bool isExist = NO;
                    for ( jxdribbble_shots *s in self.dataSource )
                    {
                        if ( [[NSString stringWithFormat:@"%@",s.id] isEqualToString:[NSString stringWithFormat:@"%@",shot.id]] )
                        {
                            isExist = YES;
                            break;
                        }
                    }
                    if (!isExist)[ dataArray addObject:shot];
                }
                else
                {
                    [ dataArray addObject:shot];
                }
            }
            
            /**
             *  if refresh
             */
            if ( self.pageIndex == 1 )
            {
                [self.dataSource removeAllObjects];
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

#pragma mark - refresh

- (void)refresh
{
    __weak jxdribbble_EveryoneViewController *weakSelf = self;
    
    int64_t delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.pageIndex = 1;
        [self getData];
        [weakSelf.tableView.pullToRefreshView stopAnimating];
    });
}

#pragma mark - loadMore

- (void)loadMore
{
    __weak jxdribbble_EveryoneViewController *weakSelf = self;
    
    int64_t delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
       self.pageIndex++;
       [self getData];
       [weakSelf.tableView.infiniteScrollingView stopAnimating];
    });
}

@end
