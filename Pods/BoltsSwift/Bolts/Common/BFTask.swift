/*
 *  Copyright (c) 2015, Ken Van Hoeylandt
 *  All rights reserved.
 *
 *  This source code is licensed under the MIT license found in the
 *  LICENSE file in the root directory of this source tree.
 */

import Foundation
import Bolts

public extension BFTask
{
	public enum Thread
	{
		case Background	// uses global queue with DISPATCH_QUEUE_PRIORITY_DEFAULT
		case Main		// uses main queue
	}
	
	// MARK: Task creation
	
	private static func task(queue: dispatch_queue_t, closure: () -> AnyObject?) -> BFTask!
	{
		var tcs = BFTaskCompletionSource()
		
		dispatch_async(queue,
		{
			if let result : AnyObject? = closure()
			{
				tcs.setResult(result)
			}
			else
			{
				tcs.setResult(nil)
			}
		});
		
		return tcs.task;
	}
	
	public static func task(thread: Thread = .Background, closure: () -> AnyObject?) -> BFTask!
	{
		if thread == .Background
		{
			return task(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), closure: closure)
		}
		else
		{
			return task(dispatch_get_main_queue(), closure: closure)
		}
	}
	
	// MARK: Continuations
	
	public func continueWith(thread: Thread, continuation: BFContinuationBlock) -> BFTask!
	{
		if (thread == .Background)
		{
			return continueWithExecutor(BFExecutor.defaultExecutor(), withBlock: continuation)
		}
		else
		{
			return continueWithExecutor(BFExecutor.mainThreadExecutor(), withBlock: continuation)
		}
	}

	public func continueInBackground(continuation: BFContinuationBlock) -> BFTask!
	{
		return continueWith(.Background, continuation: continuation)
	}
	
	public func continueInMainThread(continuation: BFContinuationBlock) -> BFTask!
	{
		return continueWith(.Main, continuation: continuation)
	}
	
	public func onSuccess(thread: Thread, continuation: BFContinuationBlock) -> BFTask!
	{
		if (thread == .Background)
		{
			return continueWithExecutor(BFExecutor.defaultExecutor(), withSuccessBlock: continuation)
		}
		else
		{
			return continueWithExecutor(BFExecutor.mainThreadExecutor(), withSuccessBlock: continuation)
		}
	}
	
	public func onSuccessInMainThread(continuation: BFContinuationBlock) -> BFTask!
	{
		return onSuccess(.Main, continuation: continuation);
	}

	public func onSuccessInBackground(continuation: BFContinuationBlock) -> BFTask!
	{
		return onSuccess(.Background, continuation: continuation);
	}
}