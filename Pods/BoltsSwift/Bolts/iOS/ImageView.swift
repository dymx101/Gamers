/*
 *  Copyright (c) 2015, Ken Van Hoeylandt
 *  All rights reserved.
 *
 *  This source code is licensed under the MIT license found in the
 *  LICENSE file in the root directory of this source tree.
 */

import Foundation
import Bolts

public extension UIImageView
{
	func setImageAsync(url : NSURL!) -> BFTask!
	{
		var tcs = BFTaskCompletionSource()

		return UIImage.imageAsync(url)
			.onSuccessInMainThread
			{
				(task: BFTask!) -> AnyObject! in

				self.image = task.result as? UIImage
				
				return nil
			}
	}
}