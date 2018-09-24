/*@Description: Handler for the Visitor Trigger 
* Change Log - Latest Change
*
* Date        Author          Change Description
* ------------------------------------------------------------------------------------
* 23/02/2015  Tammy Mistry    Created Class
*/

public class VisitorTriggerHandler {
	
    //Sets the Badge to be Assigned if the 'Badge Assigned Hidden' field is true on the Visitor or Unassigned if it's false
    public static void updateBadges(List<Visitor__c> visitorList)
    {
        //Lists of Visitors with and without Badges In Use
        List<Visitor__c> visitorsWithBadge = new List<Visitor__c>();
        List<Visitor__c> visitorsWithoutBadge = new List<Visitor__c>();
        
        for(Visitor__c v : visitorList)
        {
            if(v.Badge_Assigned_Hidden__c == true)
            {
                visitorsWithBadge.add(v);
            }
            else
            {
                visitorsWithoutBadge.add(v);
            }
        }
        
        //Set of the Badge Ids that need to be updated to Assigned and List of the Badges
        Set<Id> badgeIdsAssigned = new Set<Id>();
        List<Visitor_Badge__c> assignedBadges = new List<Visitor_Badge__c>();
        //Set of the Badge Ids that need to be updated to Unassigned and List of the Badges
        Set<Id> badgeIdsUnassigned = new Set<Id>();
        List<Visitor_Badge__c> unassignedBadges = new List<Visitor_Badge__c>();
                
        for(Visitor__c v1 : visitorsWithBadge)
        {
            badgeIdsAssigned.add(v1.Badge_Number__c);
        }
        
        for(Visitor__c v2 : visitorsWithoutBadge)
        {
            badgeIdsUnassigned.add(v2.Badge_Number__c);
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