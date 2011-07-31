UIToastAlert - README
=====================

So I really liked the toast style notification on Android, and wanted a new project. This class should function somewhat similarly to the actual toast notifications on Android.

Usage
------
  I've included 4 convenience methods that should cover a lot of what is needed by these notifications. You basically call these selectors, get back a new _UIToastAlert_ instance. Once you have the instance all you need to do is call _show_ on the instance. This will display the toast for the given configuration parameters.

	+ (UIToastAlert *)toastForMessage:(NSString *)message atPosition:(UIToastAlertPosition)position withDuration:(NSTimeInterval)duration;
	+ (UIToastAlert *)shortToastForMessage:(NSString *)message atPosition:(UIToastAlertPosition)position;
	+ (UIToastAlert *)longToastForMessage:(NSString *)message atPosition:(UIToastAlertPosition)position;
	+ (UIToastAlert *)toastForMessage:(NSString *)message;
Configurable Properties
-----------------------

While not all of the properties that you can change are available from the convenience methods, you can feel free to modify any of them before calling show. Here is a list of things you may customize...

* (NSTimeInterval) \_showDuration - the amount of time (in seconds) to show the toast.
* (NSTimeInterval) \_animationDuration - the amount of time (in seconds) to animate the toast.
* (UIColor) \_tintColor - the color which the notification should be. 
* (BOOL) \_lightText - Whether or not the text should be drawn light (say if you have a dark \_tintColor).
* (UIToastAlertPosition) \_position - Where to position the message (Currently only UIToastAlertPositionTop or UIToastAlertPositionBottom).

It should also be noted that if you do not configure any of the properties, the defaults will take over and things should look just fine!

Screen Shots
------------
[Picture One](http://bit.ly/pTshQk "Alert One")
[Picture Two](http://bit.ly/nOCkf4 "Alert Two")

Here's some videos!
[Video One](http://bit.ly/pANgES "Video One")
[Video Two](http://bit.ly/pYB5bI "Video Two")

License
-------

Please see the LICENSE file for more information