/*@Description Test Class for Visitor Log Trigger Handler
* Change Log - Latest Change
*
* Date        Author           Change Description
* -----------------------------------------------------------------------------
* 04/03/2015  Tammy Mistry     Created Test Class
*/

@isTest
public class VisitorLogTriggerHandlerTest {

    public static User adminUser;
    public static Visitor_Log__c visitorLog;
    public static Visitor_Badge__c badge;
    
    private static void setup()
    {        
        adminUser = TestHelper.createUser();
        insert adminUser;
        
        PermissionSet visitorLogAdminPerm;
        visitorLogAdminPerm = [SELECT Id, Name FROM PermissionSet WHERE Name = 'Visitor_Logging_Administrator'];
        
        PermissionSetAssignment adminPermission = new PermissionSetAssignment();
        adminPermission.AssigneeId = adminUser.Id;
        adminPermission.PermissionSetId = visitorLogAdminPerm.Id;
        insert adminPermission;
        
        badge = new Visitor_Badge__c(Badge_Number__c = '00001', In_Use__c = false, Status__c = 'Unassigned');
    }
    
    //Updates Badge to be 'Assigned' or 'Unassigned' depending on the 'Badge Assigned Hidden' field on the Visitor Log
    public static testMethod void updateBadge()
    {
		setup();
        test.startTest();
        
        system.runAs(adminUser)
        {
            insert badge;
            
            visitorLog = new Visitor_Log__c(Visitor_Name__c = 'Test Visitor', Visitor_Company__c = 'Test Company', 
        	                            Expected_Arrival__c = system.now(), Expected_Departure__c = system.now(),
                                       	Badge_Number__c = badge.Id, Time_Arrived__c = system.now(), Badge_Assigned_Hidden__c = true);
            insert visitorLog;
            
            badge = [Select Id, Name, Status__c, In_Use__c From Visitor_Badge__c Where Id =: badge.Id]; 
            
            system.assertEquals(true,badge.In_Use__c);
       		system.assertEquals('Assigned',badge.Status__c);
            
            visitorLog.Time_Departed__c = system.now();
            visitorLog.Badge_Assigned_Hidden__c = false;
            update visitorLog;
            
            badge = [Select Id, Name, Status__c, In_Use__c From Visitor_Badge__c Where Id =: badge.Id];
            
            system.assertEquals(false,badge.In_Use__c);
            system.assertEquals('Unassigned',badge.Status__c);
        }     	
        
        test.stopTest();
    }
}