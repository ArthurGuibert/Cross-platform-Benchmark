//
//  AGMasterViewController.m
//  ToDoVeille
//
//  Created by Arthur GUIBERT on 16/12/2013.
//  Copyright (c) 2013 Arthur GUIBERT. All rights reserved.
//

#import "AGMasterViewController.h"

#import "AGDetailViewController.h"

@interface AGMasterViewController () {
    NSMutableArray *_objects;
    UIAlertView* _dialog;
}
@end

@implementation AGMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(promptForNewTask:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    self.title = @"To Do Veille";
    
    // Load saved tasks
    NSArray* tasks = [[NSUserDefaults standardUserDefaults] arrayForKey:@"tasks"];
    _objects = [[NSMutableArray alloc] initWithArray:tasks];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Alert View Dialog

- (void) promptForNewTask:(id)sender
{
    _dialog = [[UIAlertView alloc] init];
    [_dialog setDelegate:self];
    [_dialog setTitle:@"Enter a new task"];
    [_dialog setMessage:@""];
    [_dialog addButtonWithTitle:@"Cancel"];
    [_dialog addButtonWithTitle:@"Add"];
    [_dialog setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [[_dialog textFieldAtIndex:0] setDelegate:self];
    [_dialog show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1) {
        [self addTask:[[alertView textFieldAtIndex:0] text]];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(_dialog) {
        [_dialog dismissWithClickedButtonIndex:1 animated:YES];
        [self addTask:[textField text]];
    }
    return YES;
}

#pragma mark - Tasks

-(void)addTask:(NSString*)task
{
    [_objects insertObject:task atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self saveTasks];
}

-(void)saveTasks
{
    // Save tasks
    [[NSUserDefaults standardUserDefaults] setObject:_objects forKey:@"tasks"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDate *object = _objects[indexPath.row];
    cell.textLabel.text = [object description];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [self saveTasks];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

@end
