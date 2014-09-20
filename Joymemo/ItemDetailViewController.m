//
//  ItemDetailViewController.m
//  
//
//  Created by kanta on 2014/09/20.
//
//

#import "ItemDetailViewController.h"
#import "TKRSegueOptions.h"

@interface ItemDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *LargeImageView;

@end

@implementation ItemDetailViewController

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
    self.itemId = self.segueOptions.stringValue;
    self.navigationItem.title = self.itemId;
    NSLog(@"%@", self.itemId);
}

- (void)viewWillAppear:(BOOL)animated
{
    
    
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
