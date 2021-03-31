3.0.0 Release notes (2021-03-29)
=============================================================

### API Breaking Changes

* Change supported OS to iOS 11 or above.
* Renewed public API. See StudyplusAPI, StudypusRecord, StudyplusLoginDelegate, StudyplusError.

### Enhancements

* Supports Swift Package Manager.
* Code format.
* Update README.

### Bugfixes

* None.

2.0.1 Release notes (2019-09-24)
=============================================================

### API Breaking Changes

* Stoped support iOS8.
* LSApplicationQueriesSchemes is always required to see if studyplus is installed. Please check README.md.

### Enhancements

* None.

### Bugfixes

* None.

2.0.0 Release notes (2019-09-24)
=============================================================

### API Breaking Changes

* Stoped support iOS8.
* LSApplicationQueriesSchemes is always required to see if studyplus is installed. Please check README.md.

### Enhancements

* None.

### Bugfixes

* Fixed to check if studyplus is installed.

1.3.6 Release notes (2019-08-30)
=============================================================

### API Breaking Changes

* None.

### Enhancements

* show sdk verison string.

### Bugfixes

* None.

1.3.3 Release notes (2019-08-30)
=============================================================

### API Breaking Changes

* None.

### Enhancements

* None.

### Bugfixes

* None.

1.3.2 Release notes (2019-06-21)
=============================================================

### API Breaking Changes

* None.

### Enhancements

* change url of app store

### Bugfixes

* None.

1.3.1 Release notes (2019-06-17)
=============================================================

### API Breaking Changes

* None.

### Enhancements

* added lower than 24 hours validation when post study record.

### Bugfixes

* None.

1.3.0 Release notes (2019-04-09)
=============================================================

### API Breaking Changes

* None.

### Enhancements

* change the consumer key and secret.
  * You can call this method to switch to a different key when logging in to Studyplus or posting study records.
  * If multiple applications are connected with Studyplus, you need to call this method.
  * If there is only one connected application, you do not need to call this method.
* Built with Xcode 10.2 & Swift 5.
* Update library.

### Bugfixes

* None.

1.2.1 Release notes (2019-01-15)
=============================================================

### API Breaking Changes

* None.

### Enhancements

* Built with Xcode 10 & Swift 4.2.
* Update library.

### Bugfixes

* None.

1.2.0 Release notes (2018-07-02)
=============================================================

### API Breaking Changes

* None.

### Enhancements

* None.

### Bugfixes

* fail to post study record when 24 hour system setting is invalid.

1.1.1 Release notes (2017-11-14)
=============================================================

### API Breaking Changes

* None.

### Enhancements

* None

### Bugfixes

* use shared when call URLSession.

1.1.0 Release notes (2017-09-25)
=============================================================

### API Breaking Changes

* None.

### Enhancements

* Build with Xcode 9 and Converted the project to Swift 4

### Bugfixes

* None.

1.0.9 Release notes (2017-07-06)
=============================================================

### API Breaking Changes

* None.

### Enhancements

* None.

### Bugfixes

* Fixed warning that license file can not be read when pod install

1.0.8 Release notes (2017-07-06)
=============================================================

### API Breaking Changes

* None.

### Enhancements

* None.

### Bugfixes

* Display date string with current local
* Call finishTasksAndInvalidate
