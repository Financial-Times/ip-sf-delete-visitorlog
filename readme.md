# ip-sf-delete-visitorlog
This is the ant package used to delete the apex code associated to Editorial Equipment App in Salesforce Global

### Release Doc
https://docs.google.com/spreadsheets/d/1Heg5Xxry-0NLQPgdsPC8Pr7oDOt6I5E0fzGIhNrQCLE/edit#gid=1

### Steps
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


