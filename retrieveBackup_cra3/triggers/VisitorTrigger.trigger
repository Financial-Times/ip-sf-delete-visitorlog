/*@Description: Trigger for Visitor Object 
* Change Log 
*
* Date        Author          Change Description
* ------------------------------------------------------------------------------------
* 23/02/2015  Tammy Mistry    Created Trigger
*/

trigger VisitorTrigger on Visitor__c (after insert, after update) 
{    
    if(trigger.isAfter)
    {
        if(trigger.isInsert)
        {
            VisitorTriggerHandler.updateBadges(trigger.new);
        }
        
        if(trigger.isUpdate)
        {
            VisitorTriggerHandler.updateBadges(trigger.new);
        }
    }
}