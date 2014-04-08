//
//  jxdribbble_FollowingViewController.m
//  jxdribbble
//
//  Created by Jiang Xiaodong on 13-10-10.
//  Copyright (c) 2013年 Jiang Xiaodong. All rights reserved.
//

#import "jxdribbble_FollowingViewController.h"
#import "jxdribbble_shots.h"
#import "jxdribbble_HeaderView.h"
#import "jxdribbble_TableViewCell.h"
#import "jxdribbble_DetailViewController.h"
#import "jxdribbble_PlayerViewController.h"

@interface jxdribbble_FollowingViewController ()<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSUInteger     pageIndex;

@property (strong, nonatomic) UIActivityIndicatorView *spinner;
@property (strong, nonatomic) UIButton *refreshButton;

@property (copy, nonatomic) NSString *username;

@end

@implementation jxdribbble_FollowingViewController

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
    self.title = @"Following";

    [self.navigationController.navigationBar setTranslucent:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [_spinner setCenter:CGPointMake(300.0 , 20.0)];
    
    self.refreshButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 20.0, 20.0)];
    [self.refreshButton setImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    [self.refreshButton addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0,49, 0);
    __weak jxdribbble_FollowingViewController *weakSelf = self;
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

}


- (void) viewWillAppear:(BOOL)animated
{

}


- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [userDefaults stringForKey:@"username"];
    
    if ( !username || username.length == 0 )
    {
        [self.dataSource removeAllObjects];
        [self.tableView reloadData];

        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"A Dribbble Player?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
        UITextField * textField = [alertView textFieldAtIndex:0];
        textField.keyboardType = UIKeyboardAppearanceDefault;
        textField.placeholder = @"Enter your player name";
        [alertView show];
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.refreshButton];
        self.refreshButton.hidden = NO;

        if (![username isEqualToString:self.username]){
            [self refresh];
            self.username = username;
        }
    }
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 1 )
    {
        NSString *username = [[alertView textFieldAtIndex:0] text];
        if ( username && username.length > 0 ){
            [self getUserWithUsername:username];
        }
    }
}

- (void)getUserWithUsername : (NSString *) username
{
    if ([CheckNetwork isExistenceNetwork])
    {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.dribbble.com/%@",username]];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSDictionary *jsonDic = JSON;
            jxdribbble_player *player = [[jxdribbble_player alloc] initWithPlayerInfo:jsonDic];
            if (player){
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setValue:username forKey:@"username"];
                [userDefaults synchronize];
                self.username = username;
                [self getData];
            }
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@":( No player named %@",username]
                                                               delegate:nil cancelButtonTitle:@"I'll try another one" otherButtonTitles:nil, nil];
            [alertView show];
        }];
        
        [operation start];
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
    if ( cell == nil ){
        cell = [[jxdribbble_TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.hud.hidden = NO;
    cell.gifImageView.hidden = YES;
    __weak typeof(cell) weakCell = cell;
    
    NSURL *url;
    if ( [[shot.image_url substringWithRange:NSMakeRange(shot.image_url.length - 4,4)] isEqualToString:@".gif"] ){
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
                                    weakCell.shot_imageView.image = image;
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
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *username = [userDefaults stringForKey:@"username"];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.dribbble.com/players/%@/shots/following?page=%@&per_page=20",username,[NSString stringWithFormat:@"%lu",(unsigned long)self.pageIndex]]];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSDictionary *jsonDic = JSON;

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
    __weak jxdribbble_FollowingViewController *weakSelf = self;
    
    int64_t delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        weakSelf.pageIndex++;
        [weakSelf getData];
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
    });
}


@end


