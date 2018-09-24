/*@Description: Trigger for Visitor Log Object 
* Change Log - Latest Change
*
* Date        Author          Change Description
* ------------------------------------------------------------------------------------
* 20/02/2015  Tammy Mistry    Added After Insert and After Update
*/

trigger VisitorLogTrigger on Visitor_Log__c (before insert, after insert, after update) 
{
	if(trigger.isBefore)
    {
    	if(trigger.isInsert)
        {
      		visitorLogTriggerHandler.setFTHostName(trigger.new);
        }
    }
    
    if(trigger.isAfter)
    {
        if(trigger.isInsert)
        {
            VisitorLogTriggerHandler.updateBadges(trigger.new);
        }
        
        if(trigger.isUpdate)
        {
            VisitorLogTriggerHandler.updateBadges(trigger.new);
        }        
    }
}