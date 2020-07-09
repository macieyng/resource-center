### Displaying Windows 7/10 Product Key In CMD

Run cmd as Admin, then enter command `wmic path softwarelicensingservice get OA3xOriginalProductKey`

### Deactivate Windows 7/10 Product Key In CMD

Run `slmgr /dlv` in cmd as Admin. 

Copy Activation ID. 

Run `slmgr /upk "ACTIVATION ID"` in cmd as Admin.

### Activate Windows 7/10 Product Key In CMD
Run `slmgr /ipk "PRODUCT KEY"` in cmd as Admin.
