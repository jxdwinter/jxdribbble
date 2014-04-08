//
//  jxdribbble_PlayerListViewController.m
//  jxdribbble
//
//  Created by Jiang Xiaodong on 13-10-16.
//  Copyright (c) 2013年 Jiang Xiaodong. All rights reserved.
//

#import "jxdribbble_PlayerListViewController.h"
#import "jxdribbble_PlayerListCell.h"
#import "jxdribbble_PlayerViewController.h"

@interface jxdribbble_PlayerListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSUInteger     pageIndex;

@property (strong, nonatomic) UIActivityIndicatorView *spinner;
@property (strong, nonatomic) UIButton *refreshButton;

@end

@implementation jxdribbble_PlayerListViewController

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
	// Do any additional setup after loading the view.

    if ( self.viewControllerType == 1 )
    {
        self.title = @"Following";
    }
    else if ( self.viewControllerType == 2 )
    {
        self.title = @"Followers";
    }
    else if ( self.viewControllerType == 3 )
    {
        self.title = @"Draftees";
    }
    
    
    [self.navigationController.navigationBar setTranslucent:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [_spinner setCenter:CGPointMake(300.0 , 20.0)];
    
    self.refreshButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 20.0, 20.0)];
    [self.refreshButton setImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    [self.refreshButton addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
    
    NSLog(@"%@", NSStringFromCGRect([UIScreen mainScreen].bounds));
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, [UIScreen mainScreen].bounds.size.height ) style:UITableViewStylePlain];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0,49, 0);
    __weak jxdribbble_PlayerListViewController *weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMore];
    }];
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

- (void)backToPreViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    jxdribbble_PlayerListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[jxdribbble_PlayerListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell.avatarImageView setImageWithURL:[NSURL URLWithString: [(jxdribbble_player *)[self.dataSource objectAtIndex:indexPath.row] avatar_url]] placeholderImage:[UIImage imageNamed:@"headimg_bg"]];
    cell.usernameLabel.text = [(jxdribbble_player *)[self.dataSource objectAtIndex:indexPath.row] username];
    cell.nameLabel.text = [(jxdribbble_player *)[self.dataSource objectAtIndex:indexPath.row] name];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    jxdribbble_PlayerViewController *playerViewController = [[jxdribbble_PlayerViewController alloc] init];
    playerViewController.player = (jxdribbble_player *)[self.dataSource objectAtIndex:indexPath.row];
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
        
        NSURL *url;
        if (self.viewControllerType == 1){
            url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.dribbble.com/players/%@/following?page=%@",self.player.username,[NSString stringWithFormat:@"%lu",(unsigned long)self.pageIndex]]];
        }else if (self.viewControllerType == 2){
            url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.dribbble.com/players/%@/followers?page=%@",self.player.username,[NSString stringWithFormat:@"%lu",(unsigned long)self.pageIndex]]];
        }else if ( self.viewControllerType == 3 ){
            url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.dribbble.com/players/%@/draftees?page=%@",self.player.username,[NSString stringWithFormat:@"%lu",(unsigned long)self.pageIndex]]];
        }

        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSDictionary *jsonDic = JSON;
            NSArray *players = [jsonDic objectForKey:@"players"];
            NSMutableArray *dataArray = [[NSMutableArray alloc] initWithCapacity:50];
            
            for (NSDictionary * playerDic in players)
            {
                jxdribbble_player  *player = [[jxdribbble_player alloc] initWithPlayerInfo:playerDic];
                
                if ( self.pageIndex != 1 )
                {
                    bool isExist = NO;
                    for ( jxdribbble_player *p in self.dataSource )
                    {
                        if ( [[NSString stringWithFormat:@"%@",p.id] isEqualToString:[NSString stringWithFormat:@"%@",player.id]] )
                        {
                            isExist = YES;
                            break;
                        }
                    }
                    if (!isExist)[ dataArray addObject:player];
                }
                else
                {
                    [ dataArray addObject:player];
                }
            }
            
            /**
             *  if refresh
             */
            if ( self.pageIndex == 1 )
            {
                [self.dataSource removeAllObjects];
            }
            if ( [dataArray count ] < 15 )
            {
                self.tableView.showsInfiniteScrolling = NO;
            }
            
            [self.dataSource addObjectsFromArray:dataArray];
            [self.tableView reloadData];
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            [_spinner stopAnimating];
            
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.refreshButton];
            self.refreshButton.hidden = NO;
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
            NSLog(@"%@",error);
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            [_spinner stopAnimating];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.refreshButton];
            self.refreshButton.hidden = NO;
            if(self.pageIndex > 1)self.pageIndex--;
        }];
        
        [operation start];
    }
    else
    {
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
    __weak jxdribbble_PlayerListViewController *weakSelf = self;
    
    int64_t delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        weakSelf.pageIndex++;
        [weakSelf getData];
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
    });
}


@end
