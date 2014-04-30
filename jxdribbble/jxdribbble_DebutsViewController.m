//
//  jxdribbble_DebutsViewController.m
//  jxdribbble
//
//  Created by Jiang Xiaodong on 13-10-10.
//  Copyright (c) 2013年 Jiang Xiaodong. All rights reserved.
//

#import "jxdribbble_DebutsViewController.h"
#import "jxdribbble_shots.h"
#import "jxdribbble_HeaderView.h"
#import "jxdribbble_TableViewCell.h"
#import "jxdribbble_DetailViewController.h"
#import "jxdribbble_PlayerViewController.h"

@interface jxdribbble_DebutsViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSUInteger     pageIndex;

@property (strong, nonatomic) UIActivityIndicatorView *spinner;
@property (strong, nonatomic) UIButton *refreshButton;

@end

@implementation jxdribbble_DebutsViewController

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
    self.title = @"Debuts";

    [self.navigationController.navigationBar setTranslucent:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [_spinner setCenter:CGPointMake(300.0 , 20.0)];
    
    self.refreshButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 20.0, 20.0)];
    [self.refreshButton setImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    [self.refreshButton addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0,49, 0);
    __weak jxdribbble_DebutsViewController *weakSelf = self;
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

    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filename = [Path stringByAppendingPathComponent:@"debuts"];
    if ([jxdribbble_Global is_file_exist:filename]) {
        NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
        NSArray *shots = [dic objectForKey:@"shots"];
        NSMutableArray *dataArray = [[NSMutableArray alloc] initWithCapacity:50];
        for (NSDictionary * shotDic in shots){
            jxdribbble_shots  *shot = [[jxdribbble_shots alloc] initWithShotInfo:shotDic];
            [self.dataSource addObject:shot];
        }

        [self.dataSource addObjectsFromArray:dataArray];
        [self.tableView reloadData];

    }

    
    [self getData];
  
}

- (void)showMenu
{

}


- (void) viewWillAppear:(BOOL)animated
{

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
    return 270.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = [indexPath section];
    
    static NSString *CellIdentifier = @"Cell";
    jxdribbble_shots *shot =  [self.dataSource objectAtIndex:section];
    //NSString *url = shot.image_url;
    jxdribbble_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ( cell == nil ){
        cell = [[jxdribbble_TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    cell.hud.hidden = NO;
    cell.gifImageView.hidden = YES;
    __weak typeof(cell) weakCell = cell;
    
    NSURL *url;
    if ( [[shot.image_url substringWithRange:NSMakeRange(shot.image_url.length - 4,4)] isEqualToString:@".gif"] )
    {
        url = [NSURL URLWithString:shot.image_teaser_url];
        cell.gifImageView.hidden = NO;
    }else{
        url = [NSURL URLWithString:shot.image_url];
    }

    [cell.shot_imageView setImageWithURL:url
                        placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                                 options:SDWebImageLowPriority
                                progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                    double p = (double)receivedSize/(double)expectedSize;
                                    weakCell.hud.progress = p;
                                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                    if (error) {


                                    }else{
                                        weakCell.shot_imageView.image = image;
                                    }

                                    weakCell.hud.hidden = YES;
                                }];
    
    cell.likesLabel.text = [NSString stringWithFormat:@"%@",shot.likes_count];
    cell.viewsLabel.text = [NSString stringWithFormat:@"%@",shot.views_count];
    cell.commentsLabel.text = [NSString stringWithFormat:@"%@",shot.comments_count];
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
    jxdribbble_DetailViewController *detail = [[jxdribbble_DetailViewController alloc] init];
    detail.shot = (jxdribbble_shots *)[self.dataSource objectAtIndex:indexPath.section];
    [self.navigationController pushViewController:detail animated:YES];
    
}


#pragma mark - HeaderViewTouched

- (void)headerViewTouched : (jxdribbble_HeaderView *)sender
{
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
        
        UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:_spinner];
        [self navigationItem].rightBarButtonItem = barButton;
        [_spinner startAnimating];
        
        self.refreshButton.hidden = YES;
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.dribbble.com/shots/debuts?page=%@&per_page=20",[NSString stringWithFormat:@"%lu",(unsigned long)self.pageIndex]]];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSDictionary *jsonDic = JSON;

            if (self.pageIndex == 1) {
                NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
                NSString *filename = [Path stringByAppendingPathComponent:@"debuts"];
                [NSKeyedArchiver archiveRootObject:jsonDic toFile:filename];
            }

            NSArray *shots = [jsonDic objectForKey:@"shots"];
            NSMutableArray *dataArray = [[NSMutableArray alloc] initWithCapacity:50];
            for (NSDictionary * shotDic in shots)
            {
                jxdribbble_shots  *shot = [[jxdribbble_shots alloc] initWithShotInfo:shotDic];
                
                if ( self.pageIndex != 1 ){
                    bool isExist = NO;
                    for ( jxdribbble_shots *s in self.dataSource ){
                        if ( [[NSString stringWithFormat:@"%@",s.id] isEqualToString:[NSString stringWithFormat:@"%@",shot.id]] ){
                            isExist = YES;
                            break;
                        }
                    }
                    if (!isExist)[ dataArray addObject:shot];
                }else{
                    [ dataArray addObject:shot];
                }
            }
            
            /**
             *  if refresh
             */
            if ( self.pageIndex == 1 ){
                [self.dataSource removeAllObjects];
            }

            [self.dataSource addObjectsFromArray:dataArray];
            [self.tableView reloadData];

            [self.tableView.infiniteScrollingView stopAnimating];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            [_spinner stopAnimating];
            
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.refreshButton];
            self.refreshButton.hidden = NO;
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
            
            [self.tableView.infiniteScrollingView stopAnimating];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            [_spinner stopAnimating];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.refreshButton];
            self.refreshButton.hidden = NO;
            if(self.pageIndex > 1)self.pageIndex--;
        }];
        
        [operation start];
    }else{
        [self.tableView.infiniteScrollingView stopAnimating];
        if(self.pageIndex > 1)self.pageIndex--;
    }
    
}

#pragma mark - refresh

- (void)refresh
{
    self.pageIndex = 1;
    [self getData];
}

#pragma mark - loadMore

- (void)loadMore
{
    self.pageIndex++;
    [self getData];
}


@end
