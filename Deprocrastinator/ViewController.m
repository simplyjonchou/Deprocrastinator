//
//  ViewController.m
//  Deprocrastinator
//
//  Created by Jonathan Chou on 10/27/14.
//  Copyright (c) 2014 Jonathan Chou. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property NSMutableArray *listArray;
@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property BOOL editButton;
@property int editCount;
@property int swipeCount;
@property NSMutableArray *checkButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    self.swipeCount = 0;
    self.checkButton = [[NSMutableArray alloc] initWithCapacity: 100];
    for (int i = 0; i < 100; i++){
    [self.checkButton addObject: @"NO"];
    }
    self.editButton = NO;
    self.editCount = 0;
    [super viewDidLoad];
    //    self.listTableView.allowsMultipleSelection = YES;
    //    self.listArray = [@[] mutableCopy];
    self.listArray = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.listArray[indexPath.row];
    
    return cell;}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    if(!self.checkedIndexPath){
    //        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    //        self.checkedIndexPath = indexPath;
    //    }
    //
    //    else if([self.checkedIndexPath isEqual:indexPath]){
    //        self.checkedIndexPath = nil;
    //        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //        cell.accessoryType = UITableViewCellAccessoryNone;
    //
    //    }
    //
    //    else
    //    {
    //        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //        cell.accessoryType = UITableViewCellAccessoryNone;
    //    }
    
    if([self.checkButton[indexPath.row] boolValue] == NO){
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.checkButton[indexPath.row]= @"YES";
    }
    
    else if([self.checkButton[indexPath.row] boolValue] == YES){
        self.checkButton[indexPath.row] = @"NO";
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    
    if(self.editButton)
    {   [self.listArray removeObjectAtIndex:indexPath.row];
        [self.listTableView reloadData];
    }
    
    
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self onAddButtonPressed:nil];
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Confirmation" message:@"Are you sure you would like to delete this item?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *delete = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryNone;
            [self.listArray removeObjectAtIndex:indexPath.row];
            [tableView reloadData];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:delete];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
        
        [tableView reloadData];
    }
}

#pragma mark DONT FORGET TO DO YOUR PRAGMA MARKS!

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    NSString *stringToMove = self.listArray[sourceIndexPath.row];
    [self.listArray removeObjectAtIndex:sourceIndexPath.row];
    [self.listArray insertObject:stringToMove atIndex:destinationIndexPath.row];
}

- (IBAction)onAddButtonPressed:(id)sender
{
    
    if (![self.textField.text isEqualToString:@""])
    {
        NSString *list = self.textField.text;
        [self.listArray addObject:list];
        
        [self.listTableView reloadData];
        self.textField.text = nil;
        [self.textField resignFirstResponder];
    }
}

- (IBAction)editButtonPressed:(UINavigationItem *)editButton
{
    self.listTableView.editing = YES;
    self.editCount++;
    if(self.editCount%2){
        self.editButton = YES;
        editButton.title = @"Done";
    }
    else{
        self.editButton = NO;
        editButton.title = @"Edit";
        self.listTableView.editing = NO;
    }
}
- (IBAction)onSwipeGestureRecognizer:(UIGestureRecognizer *)gesture {
    //PROVED
    //    self.textField.text = @"Alexey";
    self.swipeCount = self.swipeCount%4;
    CGPoint location = [gesture locationInView:self.listTableView];
    NSIndexPath *swipedIndexPath = [self.listTableView indexPathForRowAtPoint:location];
    UITableViewCell *swipedCell = [self.listTableView cellForRowAtIndexPath:swipedIndexPath];
    NSArray *colorArray = @[[UIColor redColor], [UIColor yellowColor], [UIColor greenColor], [UIColor whiteColor]];
    swipedCell.backgroundColor = colorArray[self.swipeCount];
    //    UIButton *highButton = [[UIButton alloc]initWithFrame:(0,0,0,0)]
    //UITextField *color =[self.listArray objectAtIndex:indexPath.row];
    //    color.backgroundColor = [UIColor blueColor];
        self.swipeCount++;
    
}


@end
