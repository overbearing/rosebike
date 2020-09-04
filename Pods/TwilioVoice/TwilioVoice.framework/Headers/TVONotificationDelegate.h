//
//  TVONotificationDelegate.h
//  TwilioVoice
//
//  Copyright © 2016-2019 Twilio, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TVOCallInvite;

/**
 * Objects can conform to the `TVONotificationDelegate` protocol to be informed when incoming Call Invites are
 * received or canceled.
 */
@protocol TVONotificationDelegate <NSObject>

/**
 * @name Required Methods
 */

/**
 * @brief Notifies the delegate that a Call Invite was received.
 *
 * @discussion An Invite may be in the `TVOCallInviteStatePending` or `TVOCallInviteStateCanceled` state.
 *
 * @discussion Calling `[TwilioVoice handleMessage:]` will synchronously process your notification payload and
 * provide you a `TVOCallInvite` object with `TVOCallInviteStatePending` state.
 * The SDK may call `[TVONotificationDelegate callInviteReceived:]` asynchronously on the main dispatch queue
 * with a `TVOCallInvite` state of `TVOCallInviteStateCanceled` if the caller hangs up or the client
 * encounters any other error before the called party could answer or reject the call.
 *
 * @param callInvite A `<TVOCallInvite>` object.
 *
 * @see TVOCallInvite
 */
- (void)callInviteReceived:(nonnull TVOCallInvite *)callInvite;

/**
 * @brief Notifies the delegate synchronously that an error occurred when processing the `VoIP` push notification payload.
 *
 * @param error An `NSError` object describing the error.
 *
 * @see TVOError
 */
- (void)notificationError:(nonnull NSError *)error;

@end
