/*@Description: Controller for VisitorLogDetailPage Visualforce Page
* Change Log - Latest Change
*
* Date        Author          Change Description
* ------------------------------------------------------------------------------------
* 24/02/2015  Tammy Mistry     Created Class
*/

public class VisitorLogDetailPageController
{
    private final ApexPages.StandardController theController;
    public Visitor_Log__c visitorLogObj;
    public Visitor_Log__c currentLog {get;set;}
    public List<VisitorWrapper> visitorList {get;set;}
    public boolean allVisitorsSelected {get;set;}
    public boolean visitorSelected {get;set;}
    
    //Constructor
    public VisitorLogDetailPageController(ApexPages.StandardController controller)
    {
        this.visitorLogObj = (Visitor_Log__c)controller.getRecord();
        this.theController = controller;
        this.currentLog = [Select Id, Name, Arrival_Email_Sent_Hidden__c, Departure_Email_Sent_Hidden__c 
                            From Visitor_Log__c 
                            Where Id =: visitorLogObj.Id];
        getVisitors();
    }
    
    //Causes a workflow email alert to fire when the 'Arrival Email Sent Hidden' field is changed
    public PageReference sendArrivalEmail()
    {     
        try
        {
            if(currentLog.Arrival_Email_Sent_Hidden__c == false)
            {
                currentLog.Arrival_Email_Sent_Hidden__c = true;
            }
            else
            {
                currentLog.Arrival_Email_Sent_Hidden__c = false;
            }
            
            update currentLog;           
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: ' + e.getMessage()));
        }
        
        return null;
    }
    
    //Causes a workflow email alert to fire when the 'Departure Email Sent Hidden' field is changed
    public PageReference sendDepartureEmail()
    {     
        try
        {
            if(currentLog.Departure_Email_Sent_Hidden__c == false)
            {
                currentLog.Departure_Email_Sent_Hidden__c = true;
            }
            else
            {
                currentLog.Departure_Email_Sent_Hidden__c = false;
            }
                       
            update currentLog;
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: ' + e.getMessage()));
        }
        
        return null;
    }
    
    //Gets a list of the Visitors where the Visitor Log is the current Visitor Log
    public List<VisitorWrapper> getVisitors()
    {
        if(visitorList == null)
        {
            visitorList = new List<VisitorWrapper>();
            
            for(Visitor__c v : [SELECT Id, Name, Badge_Number__c, Badge_Type__c, No_Show__c, Time_Arrived__c, Time_Departed__c, 
                                        Visitor_Log__c, Visitor_Log__r.Id, Visitor_Name__c FROM Visitor__c WHERE Visitor_Log__c =: visitorLogObj.Id])
            {
                visitorList.add(new VisitorWrapper(v));
            }
        }
      
        return visitorList;       
    }
    
    //Custom button to create a new Visitor record and then return to the Visitor Log page
    public PageReference newVisitor()
    {
        PageReference newVis = new PageReference(Label.New_Visitor+'?saveURL=/apex/VisitorLogDetailPage?id='+currentLog.Id+
                                                 '&retURL=/apex/VisitorLogDetailPage?id='+currentLog.Id+
                                                 '&'+Label.Visitor_Log_Id+'='+currentLog.Name);
        return newVis.setRedirect(true);
    }
    
    //Custom button to set Arrival Time to the current time for multiple Visitors
    public PageReference visitorsArrived()
    {
        List<Visitor__c> selectedVisitors = new List<Visitor__c>();
        
        for(VisitorWrapper visitor : getVisitors())
        {
            if(visitor.selected == true)
            {
                visitor.vis.Time_Arrived__c = system.now();
                selectedVisitors.add(visitor.vis); 
                visitor.selected = false;
            }
        }
        
        if(selectedVisitors.size() > 0)
        {
            update selectedVisitors;
        }

        allVisitorsSelected = false;
        return null;
    }
    
    //Custom button to set Departed Time to the current time for multiple Visitors
    public PageReference visitorsDeparted()
    {
        List<Visitor__c> selectedVisitors = new List<Visitor__c>();
        
        for(VisitorWrapper visitor : getVisitors())
        {
            if(visitor.selected == true)
            {
                visitor.vis.Time_Departed__c = system.now();
                selectedVisitors.add(visitor.vis);
                visitor.selected = false;
            }
        }
        
        if(selectedVisitors.size() > 0)
        {
            update selectedVisitors;
        }
        
        allVisitorsSelected = false;
        return null;
    }
    
    //Wrapper class
    public class VisitorWrapper
    {
        public Visitor__c vis {get;set;}
        public boolean selected {get;set;}
        public VisitorWrapper(Visitor__c v)
        {
            vis = v;
            selected = false;
        }
    }
}