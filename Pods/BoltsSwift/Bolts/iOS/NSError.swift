/*
 *  Copyright (c) 2015, Ken Van Hoeylandt
 *  All rights reserved.
 *
 *  This source code is licensed under the MIT license found in the
 *  LICENSE file in the root directory of this source tree.
 */

import Foundation

internal extension NSError
{
	static func error(localizedDescription: NSString) -> NSError
	{
		var user_info = [NSObject : AnyObject]()
		user_info[NSLocalizedDescriptionKey] = localizedDescription
		
		return NSError(domain:"net.kenvanhoeylandt.bolts", code:-1, userInfo: user_info)
	}
}