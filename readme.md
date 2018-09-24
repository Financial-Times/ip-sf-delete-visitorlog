# Ant Migration Tool

## Steps
Make sure build.properties has the correct credentials to the correct salesforce enviroment.

Run ant tasks as below
``` 
ant retrieveBackup
ant deleteCode
```

If changes need to be rolled back run
```
ant deployCode
```
before running ant deplyCode make sure, the folders from retrieveBackup are moved into deploypkg.


