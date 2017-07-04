Requirement is to copy the updated files of the website to the target environment (Production, Staging etc.) automatically using copy task in release manager.

It can be easily implemented by using the copy task which is internally a Robocopy operation.

Issue is that the copy task will fail, if some user is already accessing the website and at the same time this task is trying to copy the files.

This problem can be handled by implementing following steps in the given order :

1) Stop the application pool.
2) Copy the updated web files.
3) Start the application pool.

Step 2 above is the available copy task in TFS RM.

Step 1 and 3 can be implemented using this extension.

Please use it and send your valuable suggestions/inputs at - mohd.aslam1@gmail.com.