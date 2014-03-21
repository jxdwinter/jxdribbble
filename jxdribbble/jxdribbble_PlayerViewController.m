//
//  jxdribbble_PlayerViewController.m
//  jxdribbble
//
//  Created by Jiang Xiaodong on 13-10-14.
//  Copyright (c) 2013年 Jiang Xiaodong. All rights reserved.
//

#import "jxdribbble_PlayerViewController.h"
#import "jxdribbble_TableViewCell.h"
#import "jxdribbble_PlayerHeaderView.h"
#import "jxdribbble_DetailViewController.h"
#import "jxdribbble_PlayerLikesViewController.h"
#import "jxdribbble_PlayerListViewController.h"
#import "jxdribbble_WebViewController.h"

@interface jxdribbble_PlayerViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>

@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSUInteger     pageIndex;

@property (strong, nonatomic) UIActivityIndicatorView *spinner;
@property (strong, nonatomic) UIButton *refreshButton;

@end

@implementation jxdribbble_PlayerViewController

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

    self.title = self.player.username;
    
    [self.navigationController.navigationBar setTranslucent:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.refreshButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 20.0, 20.0)];
    [self.refreshButton setImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    [self.refreshButton addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
    
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [_spinner setCenter:CGPointMake(300.0 , 20.0)];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0,49, 0);
    __weak jxdribbble_PlayerViewController *weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMore];
    }];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setBackgroundView:nil];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    jxdribbble_PlayerHeaderView *headerView = [[jxdribbble_PlayerHeaderView alloc] initWithPlayerInfo:self.player];
    headerView.userInteractionEnabled = YES;
    for (UIView *view in [headerView subviews])
    {
        if ( [view isKindOfClass:[UIButton class]])
        {
            
            switch (view.tag)
            {
                case 9999://avater
                    [((UIButton *)view ) addTarget:self action:@selector(avatarButtonClicked) forControlEvents:UIControlEventTouchUpInside];
                    break;
                case 8888://draftees
                    [((UIButton *)view ) addTarget:self action:@selector(drafteesButtonClicked) forControlEvents:UIControlEventTouchUpInside];
                    break;
                case 7777://following
                    [((UIButton *)view ) addTarget:self action:@selector(followingButtonClicked) forControlEvents:UIControlEventTouchUpInside];
                    break;
                case 6666://follower
                    [((UIButton *)view ) addTarget:self action:@selector(followerButtonClicked) forControlEvents:UIControlEventTouchUpInside];
                    break;
                case 5555://likes
                    [((UIButton *)view ) addTarget:self action:@selector(likesButtonClicked) forControlEvents:UIControlEventTouchUpInside];
                    break;
                default:
                    break;
            }
        }
    }
    self.tableView.tableHeaderView = headerView;
    [self.view addSubview:self.tableView];
    self.dataSource = [[NSMutableArray alloc] initWithCapacity:50];
    self.pageIndex = 1;
    
    [self getData];
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

- (void)backToPreViewController
{
    [self.navigationController popViewControllerAnimated:YES];
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
    //NSString *url = shot.image_url;
    jxdribbble_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ( cell == nil )
    {
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
    }
    else
    {
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    jxdribbble_DetailViewController *detail = [[jxdribbble_DetailViewController alloc] init];
    detail.shot = (jxdribbble_shots *)[self.dataSource objectAtIndex:indexPath.section];
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - avatarButtonClicked

- (void) avatarButtonClicked
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"More Info About %@",self.player.username]
                                                             delegate:self
                                                    cancelButtonTitle:@"cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Twitter",@"Website",@"Open",@"Open in Safari", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];
}

#pragma mark -  actionsheetdelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        if (self.player.twitter_screen_name != (NSString *) [NSNull null] && self.player.twitter_screen_name.length > 0)
        {
            BOOL isTweetbotInstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"tweetbot:///user_profile/%@",self.player.twitter_screen_name]]];
            if ( isTweetbotInstalled )
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tweetbot:///user_profile/%@",self.player.twitter_screen_name]]];
            }
            else
            {
               [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com/%@",self.player.twitter_screen_name]]];
            }
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                message:[NSString stringWithFormat:@"%@ is not a twitter fan :(",self.player.username]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
    else if ( buttonIndex == 1 )
    {
        if (self.player.website_url != (NSString *) [NSNull null] && self.player.website_url.length > 0)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.player.website_url]];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                message:[NSString stringWithFormat:@"%@ has no webiste :(",self.player.username]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
    else if ( buttonIndex == 2 )
    {
        jxdribbble_WebViewController *webViewController = [[jxdribbble_WebViewController alloc] init];
        webViewController.urlString = self.player.url;
        webViewController.titleString = self.player.name;
        [self.navigationController pushViewController:webViewController animated:YES];
    }
    else if ( buttonIndex == 3 )
    {
        if (self.player.url != (NSString *) [NSNull null] )
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.player.url]];
        }
    }
    
}


- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    for (UIView *subview in actionSheet.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            button.titleLabel.font = [jxdribbble_Global globlaFontWithSize:15];
            button.titleLabel.textColor = [jxdribbble_Global globlaColor];
        }
    }
}


#pragma mark - draftees

- (void) drafteesButtonClicked
{
    jxdribbble_PlayerListViewController *list = [[jxdribbble_PlayerListViewController alloc] init];
    list.player = self.player;
    list.viewControllerType = 3;
    [self.navigationController pushViewController:list animated:YES];
}

#pragma mark - following

- (void) followingButtonClicked
{
    jxdribbble_PlayerListViewController *list = [[jxdribbble_PlayerListViewController alloc] init];
    list.player = self.player;
    list.viewControllerType = 1;
    [self.navigationController pushViewController:list animated:YES];
}


#pragma mark - follower

- (void) followerButtonClicked
{
    jxdribbble_PlayerListViewController *list = [[jxdribbble_PlayerListViewController alloc] init];
    list.player = self.player;
    list.viewControllerType = 2;
    [self.navigationController pushViewController:list animated:YES];
}

#pragma mark - likes

- (void) likesButtonClicked
{
    jxdribbble_PlayerLikesViewController *likes = [[jxdribbble_PlayerLikesViewController alloc] init];
    likes.player = self.player;
    [self.navigationController pushViewController:likes animated:YES];
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
        NSString *urlStr = [NSString stringWithFormat:@"http://api.dribbble.com/players/%@/shots?page=%@",self.player.username,[NSString stringWithFormat:@"%lu",(unsigned long)self.pageIndex]];
        NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSDictionary *jsonDic = JSON;
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
            if ( [dataArray count ]< 15 )
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
    __weak jxdribbble_PlayerViewController *weakSelf = self;
    int64_t delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        weakSelf.pageIndex++;
        [weakSelf getData];
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
    });
}


@end
