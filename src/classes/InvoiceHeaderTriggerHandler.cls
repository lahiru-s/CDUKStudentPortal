/*

Created By :- Arulmozhi.R
Description:- Apex Class for Invoice Trigger which Creates Invoice Items as many Applications

*/

public with sharing class InvoiceHeaderTriggerHandler {
    
    public InvoiceHeaderTriggerHandler(){
    }
    
    public Static void beforeInsert(List<Invoice_Header__c> invoiceHeaderNewList){
        
        Set<Id> universityIds = new Set<Id>(); 
        /* To get Other Invoice Record Type */
        Id otherRecordTypeId = Schema.SObjectType.Invoice_Header__c.getRecordTypeInfosByName().get('Other Invoice').getRecordTypeId();
        
        for(Invoice_Header__c invHead : invoiceHeaderNewList) {           
            universityIds.add(invHead.University__c);  
        } 
        
        if(universityIds.size() > 0 )
        {
            Map<Id, University__c> universityMap = new Map<Id, University__c>([
                SELECT  Id
                ,Name
                , Currency_Type__c
                ,ACCOUNT_NO__c
                ,ACCOUNT_NAME__c
                ,BANK_ADDRESS__c
                ,BANK_NAME__c
                ,SWIFT_CODE__c
                FROM    University__c 
                WHERE   Id in : universityIds
            ]);
            
            for(Invoice_Header__c invHead : invoiceHeaderNewList) {
                if(universityMap.containsKey(invHead.University__c))
                {
                    invHead.Currency_Type__c =universityMap.get(invHead.University__c).Currency_Type__c ;
                    invHead.Account_No__c = universityMap.get(invHead.University__c).ACCOUNT_NO__c;
                    invHead.Account_Name__c = universityMap.get(invHead.University__c).ACCOUNT_NAME__c;
                    invHead.Bank_Address__c = universityMap.get(invHead.University__c).BANK_ADDRESS__c;
                    invHead.Bank_Name__c = universityMap.get(invHead.University__c).BANK_NAME__c;
                    invHead.Swift_Code__c = universityMap.get(invHead.University__c).SWIFT_CODE__c;
                }
                
                if(invHead.RecordTypeId == otherRecordTypeId){
                    invHead.Invoice_for_University__c = false;
                }
            }
        }
    }    
    public Static void afterInsert(List<Invoice_Header__c> invoiceHeaderNewList){
        
        /* To get University Invoice Record Type */
        Id universityRecordTypeId = Schema.SObjectType.Invoice_Header__c.getRecordTypeInfosByName().get('University Invoice').getRecordTypeId();
        
        Set<Id> universityIds = new Set<Id>();
        Set<Date> startDates = new Set<Date>();
        Set<Date> endDates = new Set<Date>();
        Invoice_Item__c invItem;
        
        for(Invoice_Header__c invHead : invoiceHeaderNewList) {
            if(invHead.RecordTypeId == universityRecordTypeId){
                universityIds.add(invHead.University__c);
                
                if(invHead.Start_Date__c != null){
                    startDates.add(invHead.Start_Date__c);
                }
                
                if(invHead.End_Date__c != null){
                    endDates.add(invHead.End_Date__c);
                }
            }
        } 
        
        if(universityIds.size() > 0 )
        {
            Map<Id, University__c> universityMap = new Map<Id, University__c>([
                SELECT  Id
                ,Name
                ,Commision_Rate_Type__c
                ,Commision_Rate_Year_01__c
                ,Commision_Rate_Year_02__c
                ,Bonus_Amount__c
                ,Bonus_Amount_2__c
                ,Commission_Rate_Year_03__c
                ,Number_of_Students_Per_the_Bonus_Amount__c
                ,Number_of_Students_Per_Bonus_Amount_2__c
                ,DoPaymentAfterVisa__c
                ,Bonus_Description_1__c
                ,Bonus_Description_2__c
                ,Payment_Cycle__c, Currency_Type__c
                FROM    University__c 
                WHERE   Id in : universityIds
            ]);
            
            System.debug('startDates::::'+ startDates);
            System.debug('endDates::::'+ endDates);
            System.debug('invoiceHeaderNewList[0].Start_Date__c::::'+ invoiceHeaderNewList[0].Start_Date__c);
            System.debug('invoiceHeaderNewList[0].End_Date__c::::'+ invoiceHeaderNewList[0].End_Date__c);
            List<Invoice_Item__c> invoiceItemsList = new List<Invoice_Item__c>();
            List<Application__c> applicationList = [
                SELECT  Id
                ,Name
                ,Preferred_University__c
                ,Status__c
                ,Student__r.Student_ID__c
                ,Student__r.Name
                ,Student__r.Last_Name__c	
                ,Student__r.Date_of_Birth__c
                ,Student_ID__c
                ,Course_Name__c
                ,Full_Course_fees_Annual__c
                ,Scholarship__c
                ,Program_Start_date__c
                ,Program_End_date__c
                FROM    Application__c
                WHERE   (Preferred_University__c in : universityIds)
                //AND Program_Start_date__c >=: invoiceHeaderNewList[0].Start_Date__c
                //AND Program_Start_date__c <=: invoiceHeaderNewList[0].End_Date__c
                AND Program_Start_date__c >=: startDates
                AND Program_Start_date__c <=: endDates
                AND      (Status__c = 'Visa Granted')
                //(Status__c = 'Visa Granted' AND Preferred_University__r.DoPaymentAfterVisa__c = False)
                //OR
                //(Status__c = 'Payment Made' AND Preferred_University__r.DoPaymentAfterVisa__c = True)
                
                LIMIT   50000
            ];
              System.debug('applicationList::::'+ applicationList);
            Map<Id,List<Application__c>> applicationMap = new Map<Id,List<Application__c>>();
            
            for( Application__c app : applicationList )
            {
                if(applicationMap.containsKey(app.Preferred_University__c))
                {
                    List<Application__c> lstApp = applicationMap.get(app.Preferred_University__c);
                    lstApp.add(app);
                }
                else
                {
                    List<Application__c> lstApp = new List<Application__c>();
                    lstApp.add(app);
                    applicationMap.put(app.Preferred_University__c,lstApp);
                }
            }
            
            
            for(Invoice_Header__c invHead : invoiceHeaderNewList) {
                
                if(invHead.University__c != NULL && applicationMap.containsKey(invHead.University__c) )
                {
                    /* Creates the Invoice Items as Many Applications */
                    for(Application__c appList : applicationMap.get(invHead.University__c)) {
                        
                        DateTime yourDOB = appList.Student__r.Date_of_Birth__c;
                        String formattedDOB = yourDOB.format('dd-MM-yyyy');
                        
                        invItem = new Invoice_Item__c();
                        invItem.Invoice_Header__c = invHead.Id;
                        invItem.Invoice_Item_Type__c =  'Addition';
                        invItem.Course__c =  appList.Course_Name__c;
                        invItem.Fee__c =  appList.Full_Course_fees_Annual__c;
                        invItem.Scholarship__c =  appList.Scholarship__c;
                        
                        if(universityMap.containsKey(invHead.University__c) && universityMap.get(invHead.University__c).Commision_Rate_Year_01__c != NULL)
                        {
                            if(universityMap.get(invHead.University__c).Commision_Rate_Type__c == 'Percentage' && invItem.Fee__c != NULL && invItem.Scholarship__c != NULL)
                            {
                                invItem.Net_Amount__c = ((invItem.Fee__c - invItem.Scholarship__c) * universityMap.get(invHead.University__c).Commision_Rate_Year_01__c)/100;
                                invItem.Rate__c = universityMap.get(invHead.University__c).Commision_Rate_Year_01__c;  
                                
                            }
                            else if(universityMap.get(invHead.University__c).Commision_Rate_Type__c == 'Per Student')
                            {
                                invItem.Net_Amount__c = universityMap.get(invHead.University__c).Commision_Rate_Year_01__c;
                                invItem.Rate__c = universityMap.get(invHead.University__c).Commision_Rate_Year_01__c;
                                
                            }
                        }
                        invItem.Description__c =  'Student Name:' + '  ' +appList.Student__r.Name + '  ' + appList.Student__r.Last_Name__c + ',' + '<br/>' + 'Student Id:' + '  ' +appList.Student_ID__c + ','+ '<br/>'  + 'Student DOB:' + '  ' +formattedDOB;
                        invoiceItemsList.add(invItem); 
                    }
                    
                    /* Creates a Invoice Item if Bonus Amount 1 is not Empty */
                    if(universityMap.containsKey(invHead.University__c))
                    {
                        if(universityMap.get(invHead.University__c).Bonus_Amount__c != NULL 
                           && universityMap.get(invHead.University__c).Number_of_Students_Per_the_Bonus_Amount__c != NULL
                           && universityMap.get(invHead.University__c).Number_of_Students_Per_the_Bonus_Amount__c != 0
                           && universityMap.get(invHead.University__c).Number_of_Students_Per_the_Bonus_Amount__c <= applicationMap.get(invHead.University__c).size() )
                        {
                            invItem = new Invoice_Item__c();
                            invItem.Invoice_Header__c = invHead.Id;
                            invItem.Invoice_Item_Type__c =  'Addition';
                            invItem.Description__c = universityMap.get(invHead.University__c).Bonus_Description_1__c == NULL ? 'Per Head Bonus (PHB)' : universityMap.get(invHead.University__c).Bonus_Description_1__c;
                            invItem.Course__c =  'N/A';
                            invItem.Fee__c =  universityMap.get(invHead.University__c).Bonus_Amount__c;
                            invItem.Rate__c = math.Floor(applicationMap.get(invHead.University__c).size()/universityMap.get(invHead.University__c).Number_of_Students_Per_the_Bonus_Amount__c);
                            invItem.Net_Amount__c = invItem.Fee__c * invItem.Rate__c;
                            invoiceItemsList.add(invItem);
                        }
                        
                        /* Creates a Invoice Item if Bonus Amount 2 is not Empty */
                        
                        if(universityMap.get(invHead.University__c).Bonus_Amount_2__c != NULL 
                           && universityMap.get(invHead.University__c).Number_of_Students_Per_Bonus_Amount_2__c	 != NULL
                           && universityMap.get(invHead.University__c).Number_of_Students_Per_Bonus_Amount_2__c	 != 0
                           && universityMap.get(invHead.University__c).Number_of_Students_Per_Bonus_Amount_2__c	 <= applicationMap.get(invHead.University__c).size() )
                        {
                            
                            invItem = new Invoice_Item__c();
                            invItem.Invoice_Header__c = invHead.Id;
                            invItem.Invoice_Item_Type__c =  'Addition';
                            invItem.Description__c = universityMap.get(invHead.University__c).Bonus_Description_2__c == NULL ? 'Per Head Bonus (PHB)' : universityMap.get(invHead.University__c).Bonus_Description_2__c;
                            invItem.Course__c =  'N/A';
                            invItem.Fee__c =  universityMap.get(invHead.University__c).Bonus_Amount_2__c;
                            invItem.Rate__c = math.Floor(applicationMap.get(invHead.University__c).size()/universityMap.get(invHead.University__c).Number_of_Students_Per_Bonus_Amount_2__c);
                            invItem.Net_Amount__c = invItem.Fee__c * invItem.Rate__c;
                            invoiceItemsList.add(invItem);
                        } 
                    }
                }
            }         
            
            try{
                INSERT invoiceItemsList;
            }
            
            Catch(exception e){
                System.debug('Exception has Occured'+e.getMessage());
            }
        }
    }
}