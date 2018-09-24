/*@Description Test Class for Visitor Log Detail Page Controller
* Change Log - Latest Change
*
* Date        Author           Change Description
* -----------------------------------------------------------------------------
* 03/03/2015  Tammy Mistry     Created Test Class
*/

@isTest
public with Sharing class VisitorLogDetailPageControllerTest {

    public static User adminUser;
    public static Visitor_Log__c visitorLog;
    
    private static void setup()
    {
        adminUser = testHelper.createUser();
        insert adminUser;
        
        PermissionSet visitorLogAdminPerm;
        visitorLogAdminPerm = [SELECT Id, Name FROM PermissionSet WHERE Name = 'Visitor_Logging_Administrator'];
        
        PermissionSetAssignment adminPermission = new PermissionSetAssignment();
        adminPermission.AssigneeId = adminUser.Id;
        adminPermission.PermissionSetId = visitorLogAdminPerm.Id;
        insert adminPermission;
        
        visitorLog = new Visitor_Log__c(Visitor_Name__c = 'Test Visitor', Visitor_Company__c = 'Test Company', 
        	                            Expected_Arrival__c = system.now(), Expected_Departure__c = system.now(),
                                       	Arrival_Email_Sent_Hidden__c = false, Departure_Email_Sent_Hidden__c = false);
    }
    
    //Changes the value of the checkboxes that cause the Workflows to fire and send the Arrival and Departure Emails 
    //and changes the Arrival and Departure Times on the Visitor to be the current time
    public static testMethod void testEmailsSentAndTimeAdded()
    {
        setup();
        test.startTest();       	
        
       	system.runAs(adminUser)
       	{
           	insert visitorLog;
            
            Visitor__c visitor = new Visitor__c(Visitor_Log__c = visitorLog.Id, Visitor_Name__c = 'Test Visitor');
            insert visitor;
            
            VisitorLogDetailPageController controller = new VisitorLogDetailPageController(new ApexPages.StandardController(visitorLog));
           	controller.sendArrivalEmail();           
           	controller.sendDepartureEmail(); 
            
            system.assertEquals(true,controller.currentLog.Arrival_Email_Sent_Hidden__c);
        	system.assertEquals(true,controller.currentLog.Departure_Email_Sent_Hidden__c);
            
            controller.visitorList.get(0).selected = true;
            controller.visitorsArrived();            
            visitor = [Select Id, Name, Time_Arrived__c From Visitor__c Where Id =: controller.visitorList.get(0).vis.Id];
            
            system.assert(visitor.Time_Arrived__c != null);   
           	
            controller.visitorList.get(0).selected = true;
            controller.visitorsDeparted();
            visitor = [Select Id, Name, Time_Departed__c From Visitor__c Where Id =: controller.visitorList.get(0).vis.Id];
            
            system.assert(visitor.Time_Departed__c != null);
        }    	     	
        
        test.stopTest();
    }
}