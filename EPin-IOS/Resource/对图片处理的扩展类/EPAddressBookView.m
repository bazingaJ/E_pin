//
//  EPAddressBookView.m
//  EPin-IOS
//
//  Created by jeaderL on 16/6/20.
//  Copyright © 2016年 yangjx. All rights reserved.
//

#import "EPAddressBookView.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface EPAddressBookView() <ABPeoplePickerNavigationControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) ABPeoplePickerNavigationController *picker;
@property (nonatomic, copy) void (^complete)(NSString *phoneNum);

@end
@implementation EPAddressBookView

- (ABPeoplePickerNavigationController *)picker
{
    if (!_picker) {
        _picker = [[ABPeoplePickerNavigationController alloc] init];
        
        _picker.peoplePickerDelegate = self;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] > 8.0) {
            _picker.predicateForSelectionOfPerson = [NSPredicate predicateWithValue:false];
        }
    }
    return _picker;
}

- (void)showInViewController:(UIViewController *)VC
               completeBlock:(void (^)(NSString *phoneNum))complete
{
    _complete = complete;
    [VC presentViewController:self.picker animated:YES completion:nil];
}

#pragma mark - ABPeoplePickerNavigationControllerDelegate
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
                         didSelectPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
    long index = ABMultiValueGetIndexForIdentifier(phone, identifier);
    NSString *phoneNO = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phone, index);
    phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSLog(@"%@", phoneNO);
    if (phone && phoneNO.length == 11)
    {
        //回调过去
        _complete(phoneNO);
        [peoplePicker dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误提示" message:@"请选择正确手机号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person NS_AVAILABLE_IOS(8_0)
{
    ABPersonViewController *personViewController = [[ABPersonViewController alloc] init];
    personViewController.displayedPerson = person;
    [peoplePicker pushViewController:personViewController animated:YES];
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person NS_DEPRECATED_IOS(2_0, 8_0)
{
    return YES;
}

//iOS 8.0以后的
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier NS_DEPRECATED_IOS(2_0, 8_0)
{
    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
    long index = ABMultiValueGetIndexForIdentifier(phone,identifier);
    NSString *phoneNO = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phone, index);
    phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSLog(@"%@", phoneNO);
    if (phone && phoneNO.length == 11)
    {
        _complete(phoneNO);
        
        [peoplePicker dismissViewControllerAnimated:YES completion:nil];
        return NO;
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误提示" message:@"请选择正确手机号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
    return YES;
}


@end
