/*@Description Test Class for Visitor Trigger Handler
* Change Log - Latest Change
*
* Date        Author           Change Description
* -----------------------------------------------------------------------------
* 04/03/2015  Tammy Mistry     Created Test Class
*/

@isTest
public class VisitorTriggerHandlerTest {
    
	public static User adminUser;
    public static Visitor__c visitor;
    public static Visitor_Log__c parentLog;
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
        
        badge = new Visitor_Badge__c(Badge_Number__c = '00001');
        
        parentLog = new Visitor_Log__c(Visitor_Name__c = 'Test', Visitor_Company__c = 'Test',
                                      	Expected_Arrival__c = system.now(), Expected_Departure__c = system.now());
    }
    
    //Updates Badge to be 'Assigned' or 'Unassigned' depending on the 'Badge Assigned Hidden' field on the Visitor
    public static testMethod void updateBadge()
    {
		setup();
        test.startTest();
        
        system.runAs(adminUser)
        {
            insert badge;
            insert parentLog;
            
            visitor = new Visitor__c(Visitor_Log__c = parentLog.Id, Visitor_Name__c = 'Test', Badge_Number__c = badge.Id,
                                   	Badge_Assigned_Hidden__c = true, Time_Arrived__c = system.now());
            insert visitor;
            
            badge = [Select Id, Name, In_Use__c, Status__c From Visitor_Badge__c Where Id =: badge.Id];
            
            system.assertEquals(true,badge.In_Use__c);
            system.assertEquals('Assigned',badge.Status__c);
            
            visitor.Time_Departed__c = system.now();
            visitor.Badge_Assigned_Hidden__c = false;
            update visitor;
            
            badge = [Select Id, Name, In_Use__c, Status__c From Visitor_Badge__c Where Id =: badge.Id];
            
            system.assertEquals(false,badge.In_Use__c);
            system.assertEquals('Unassigned',badge.Status__c);
        }
        
        test.stopTest();
    }
}