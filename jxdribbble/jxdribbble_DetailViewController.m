//
//  jxdribbble_DetailViewController.m
//  jxdribbble
//
//  Created by Jiang Xiaodong on 13-10-14.
//  Copyright (c) 2013年 Jiang Xiaodong. All rights reserved.
//

#import "jxdribbble_DetailViewController.h"
#import "jxdribbble_comments.h"
#import "jxdribbble_CommentCell.h"
#import "NSString+HTML.h"
#import "jxdribbble_PlayerViewController.h"
#import "jxdribbble_NavigationViewController.h"

@interface jxdribbble_DetailViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSUInteger     pageIndex;

@end

@implementation jxdribbble_DetailViewController

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

    jxdribbble_AppDelegate *appDelegate =[[UIApplication sharedApplication] delegate];
    appDelegate.sideMenuViewController.panGestureEnabled = NO;

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"BACK"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(backToPreViewController)];
    self.title = @"DETAIL";
    
    [self.navigationController.navigationBar setTranslucent:YES];
    self.view.backgroundColor = [UIColor whiteColor];

    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    
    __weak jxdribbble_DetailViewController *weakSelf = self;
    // setup infinite scrolling
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMore];
    }];
    self.tableView.tableHeaderView = [self setUpHeaderView] ;
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



- (UIControl *)setUpHeaderView
{
    
    UIControl *headerView = [[UIControl alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 300.0)];
    
    //UIImageView *avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 7.0, 35.0, 35.0)];
    UIImageView *avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 35.0, 35.0)];
    avatarImageView.layer.masksToBounds = YES;
    avatarImageView.layer.cornerRadius = 17.5;
    [avatarImageView setImageWithURL:[NSURL URLWithString:self.shot.player.avatar_url] placeholderImage:[UIImage imageNamed:@"headimg_bg"]];
    
    
    UIButton *userButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [userButton setFrame:CGRectMake(10.0, 7.0, 35.0, 35.0)];
    [userButton addTarget:self action:@selector(userInfo) forControlEvents:UIControlEventTouchUpInside];
    [userButton addSubview:avatarImageView];
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50.0, 5.0, 250.0, 20.0)];
    titleLabel.text = self.shot.title;
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0];
    titleLabel.textColor = [UIColor colorWithRed:(236.0/255.0) green:(71.0/255.0) blue:(137.0/255.0) alpha:1.0];
    
    UILabel *usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50.0, 30.0, 150.0, 15.0)];
    usernameLabel.text = [NSString stringWithFormat:@"by %@", self.shot.player.name];
    usernameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0];
    usernameLabel.textColor = [UIColor colorWithRed:(236.0/255.0) green:(71.0/255.0) blue:(137.0/255.0) alpha:1.0];
    
    UILabel *created_atLabel = [[UILabel alloc] initWithFrame:CGRectMake(200.0, 30.0, 107.0, 15.0)];
    created_atLabel.text = [self.shot.created_at substringToIndex:16];
    created_atLabel.textAlignment = NSTextAlignmentRight;
    created_atLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0];
    created_atLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 50.0, 300.0, 225.0)];
    [imageView setImageWithURL:[NSURL URLWithString:self.shot.image_url] placeholderImage:[UIImage imageNamed:@"placeholde"]];
    
    UILabel *viewsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 280.0, 90.0, 15.0)];
    viewsLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0];
    viewsLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    viewsLabel.textAlignment = NSTextAlignmentLeft;
    
    UILabel *likesLabel = [[UILabel alloc] initWithFrame:CGRectMake(110.0, 280.0, 90.0, 15.0)];
    likesLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0];
    likesLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    likesLabel.textAlignment = NSTextAlignmentCenter;
    
    
    UILabel *commentsLabel = [[UILabel alloc] initWithFrame:CGRectMake(200.0, 280.0, 100.0, 15.0)];
    commentsLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0];
    commentsLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    commentsLabel.textAlignment = NSTextAlignmentRight;
    
    likesLabel.text = [NSString stringWithFormat:@"likes %@",self.shot.likes_count];
    viewsLabel.text = [NSString stringWithFormat:@"views %@",self.shot.views_count];
    commentsLabel.text = [NSString stringWithFormat:@"comments %@",self.shot.comments_count];
    
    [headerView addSubview:userButton];
    [headerView addSubview:titleLabel];
    [headerView addSubview:usernameLabel];
    [headerView addSubview:created_atLabel];
    
    [headerView addSubview:imageView];
    [headerView addSubview:viewsLabel];
    [headerView addSubview:likesLabel];
    [headerView addSubview:commentsLabel];
    
    return headerView;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)userInfo
{
    jxdribbble_PlayerViewController *playerViewController = [[jxdribbble_PlayerViewController alloc] init];
    playerViewController.player = self.shot.player;
    [self.navigationController pushViewController:playerViewController animated:YES];
}

- (void)backToPreViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSAttributedString *attributedText =
    [[NSAttributedString alloc]
     initWithString:[[(jxdribbble_comments *)[self.dataSource objectAtIndex:indexPath.row] body] stringByConvertingHTMLToPlainText]
     attributes:@
     {
        NSFontAttributeName: [UIFont systemFontOfSize:12]
     }];
    
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){250.0, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize  size = rect.size;
    CGFloat height = ceilf(size.height);
    
    return height + 70.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    jxdribbble_CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ( cell == nil )
    {
        cell = [[jxdribbble_CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    jxdribbble_comments *comment = [self.dataSource objectAtIndex:indexPath.row];

    NSAttributedString *attributedText =
    [[NSAttributedString alloc]
     initWithString:[[(jxdribbble_comments *)[self.dataSource objectAtIndex:indexPath.row] body] stringByConvertingHTMLToPlainText]
     attributes:@
     {
        NSFontAttributeName: [UIFont systemFontOfSize:12]
     }];
    
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){250.0, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize  size = rect.size;
    
    cell.frame = CGRectMake(0.0, 0.0, 320.0, size.height + 70.0);
    
    cell.bodyLabel.frame = CGRectMake(50.0, 35.0, 250.0, size.height);
    [cell.avatarImageView setImageWithURL:[NSURL URLWithString:comment.player.avatar_url] placeholderImage:[UIImage imageNamed:@"headimg_bg"]];
    cell.usernameLabel.text = comment.player.name;
    cell.bodyLabel.text = [comment.body stringByConvertingHTMLToPlainText];
    
    cell.likesLabel.frame = CGRectMake(50.0, size.height + 50.0, 100.0, 10);
    if ( [comment.likes_count integerValue] > 0)
    {
        cell.likesLabel.text = [NSString stringWithFormat:@"likes:%@",comment.likes_count];
    }
    
    cell.created_atLabel.frame = CGRectMake(160.0, size.height + 50.0, 150.0, 10);
    cell.created_atLabel.text =  [comment.created_at substringToIndex:16];;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    jxdribbble_PlayerViewController *playerViewController = [[jxdribbble_PlayerViewController alloc] init];
    playerViewController.player = [(jxdribbble_comments *)[self.dataSource objectAtIndex:indexPath.row] player];
    [self.navigationController pushViewController:playerViewController animated:YES];
    
}


#pragma mark - getdata

- (void)getData
{
    if ([CheckNetwork isExistenceNetwork])
    {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.dribbble.com/shots/%@/comments?page=%@&per_page=20",self.shot.id,[NSString stringWithFormat:@"%lu",(unsigned long)self.pageIndex]]];

        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSDictionary *jsonDic = JSON;
            //NSLog(@"App.net Global Stream: %@", jsonDic);
            NSArray *comments = [jsonDic objectForKey:@"comments"];
            NSMutableArray *dataArray = [[NSMutableArray alloc] initWithCapacity:50];
            for (NSDictionary * commentsDic in comments)
            {
                jxdribbble_comments  *comment = [[jxdribbble_comments alloc] initWithCommentInfo:commentsDic];
                
                if ( self.pageIndex != 1 )
                {
                    bool isExist = NO;
                    for ( jxdribbble_comments *s in self.dataSource )
                    {
                        if ( [[NSString stringWithFormat:@"%@",s.id] isEqualToString:[NSString stringWithFormat:@"%@",comment.id]] )
                        {
                            isExist = YES;
                            break;
                        }
                    }
                    if (!isExist)[ dataArray addObject:comment];
                }
                else
                {
                    [ dataArray addObject:comment];
                }

            }
            if ( [dataArray count ]< 20 )
            {
                self.tableView.showsInfiniteScrolling = NO;
            }
            
            [self.dataSource addObjectsFromArray:dataArray];
            [self.tableView reloadData];
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
            NSLog(@"%@",error);
            self.pageIndex--;
        }];
        
        [operation start];
    }
    else
    {
        self.pageIndex--;
    }
    
}

#pragma mark - loadMore

- (void)loadMore
{
    __weak jxdribbble_DetailViewController *weakSelf = self;
    
    int64_t delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.pageIndex++;
        [self getData];
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
    });
}



@end
