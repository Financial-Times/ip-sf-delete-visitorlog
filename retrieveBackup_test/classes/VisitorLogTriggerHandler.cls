/*@Description: Handler for the Visitor Log Trigger
* Change Log - Latest Change
*
* Date        Author          Change Description
* ------------------------------------------------------------------------------------
* 20/02/2015 Tammy Mistry     Created Class
*/

public class VisitorLogTriggerHandler {
    
    //Sets 'FT Host Name' field to be the current User
    public static void setFTHostName(List<Visitor_Log__c> visitorLogs)
    {
        User actingUser = [SELECT id FROM User WHERE Id = :UserInfo.getUserId()];
    	List<Visitor_Log__c> vLogs = new List<Visitor_Log__c>();
    	for (Visitor_Log__c vLog : visitorLogs)
    	{
        	vlog.FT_Host_Name__c = actingUser.Id;     
    	}
    }
    
    //Sets the Badge to be Assigned if the 'Badge Assigned Hidden' field is true on the Visitor Log or Unassigned if it's false
    public static void updateBadges(List<Visitor_Log__c> visitorLogList)
    {                     
        //Lists of Visitor Logs with and without Badges In Use
        List<Visitor_Log__c> visitorLogsWithBadge = new List<Visitor_Log__c>();
        List<Visitor_Log__c> visitorLogsWithoutBadge = new List<Visitor_Log__c>();
        
        for(Visitor_Log__c vl : visitorLogList)
        {
            if(vl.Badge_Assigned_Hidden__c == true)
            {
                visitorLogsWithBadge.add(vl);
            }
            else
            {
                visitorLogsWithoutBadge.add(vl);
            }
        }
        
        //Set of the Badge Ids that need to be updated to Assigned and List of the Badges
        Set<Id> badgeIdsAssigned = new Set<Id>();
        List<Visitor_Badge__c> assignedBadges = new List<Visitor_Badge__c>();
        //Set of the Badge Ids that need to be updated to Unassigned and List of the Badges
        Set<Id> badgeIdsUnassigned = new Set<Id>();
        List<Visitor_Badge__c> unassignedBadges = new List<Visitor_Badge__c>();
                
        for(Visitor_Log__c vl1 : visitorLogsWithBadge)
        {
            badgeIdsAssigned.add(vl1.Badge_Number__c);
        }
        
        for(Visitor_Log__c vl2 : visitorLogsWithoutBadge)
        {
            badgeIdsUnassigned.add(vl2.Badge_Number__c);
        }
        
        if(badgeIdsAssigned.size() > 0)
        {
            assignedBadges = [Select Id, Name, Badge_Number__c, In_Use__c, Status__c From Visitor_Badge__c Where Id In : badgeIdsAssigned];
        }
        
        if(badgeIdsUnassigned.size() > 0)
        {
         	unassignedBadges = [Select Id, Name, Badge_Number__c, In_Use__c, Status__c From Visitor_Badge__c Where Id In : badgeIdsUnassigned];
        }
         
        //Set Badge to be In Use and set Status to 'Assigned'
        for(Visitor_Badge__c ab : assignedBadges)
        {                        
            ab.In_Use__c = true;
            ab.Status__c = 'Assigned';    
        }
        
        //Set Badge to be Not In Use and set Status to 'Unassigned'
        for(Visitor_Badge__c ub : unassignedBadges)
        {
            ub.In_Use__c = false;
            ub.Status__c = 'Unassigned';
        }
        
        update assignedBadges;
        update unassignedBadges;
    }
}