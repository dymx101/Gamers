/*
 *  Copyright (c) 2015, Ken Van Hoeylandt
 *  All rights reserved.
 *
 *  This source code is licensed under the MIT license found in the
 *  LICENSE file in the root directory of this source tree.
 */

import Foundation
import Bolts

public extension UIImage
{
	static func imageAsync(url: NSURL) -> BFTask
	{
		return BFTask.task
		{
			() -> AnyObject? in
			
			if let data = NSData(contentsOfURL: url)
			{
				return UIImage(data: data)
			}
			else
			{
				return BFTask(error: NSError.error("failed to download image"))
			}
		}
	}
}