@isTest
public class StudentApplicationClassTest {
    @isTest static void insertStudentJSONRecords() {
        
        Document documentObj = new Document(Body = Blob.valueOf('Some Document Text'),ContentType = 'application/pdf',DeveloperName = 'my_document'
                                           ,IsPublic = true,Name = 'My Document',FolderId = UserInfo.getUserId());
        Insert documentObj;        
      
        /* For Lookup to University */
        
        University__c   univ = new University__c(Name ='University',DoPaymentAfterVisa__c = True,IsReady__c = True,Currency_Type__c	= 'AFN'
                                                 ,Commision_Rate_Type__c = 'Percentage',Commision_Rate_Year_01__c = 100,Bonus_Amount__c = 1000,Bonus_Amount_2__c = 2000
                                                 ,Number_of_Students_Per_the_Bonus_Amount__c = 1,Bonus_Description_1__c = 'Per Head Bonus (PHB)'
                                                 ,Number_of_Students_Per_Bonus_Amount_2__c = 1,Bonus_Description_2__c = 'Per Head Bonus (PHB)');       
        Insert univ; 
        
        /* 2nd Declare all Variables */      
        
        StudentApplicationClass.PersonalInformation PI = new StudentApplicationClass.PersonalInformation();
        PI.agentID 			= '001';
        PI.firstName        = 'First';
        PI.lastName         = 'Last';
        PI.email            = 'Email@example.com';
        PI.gender           = 'Female';
       // PI.DOB              = '2018-11-20';
        	PI.DOB 				= '09/05/1991';
       						
        PI.homeTelephone    = '1234567890';
        PI.middleName       = 'Middle';
        PI.maritalStatus    = 'Single';
        PI.mobile           = '9003036399';
        PI.city             = 'Bangalore';
        PI.passportNo       = 'BKBPA6662C';
        PI.accountSource    = 'Call';
        
        StudentApplicationClass.studyInterest SI = new StudentApplicationClass.studyInterest();
        SI.countryInterestedIn      = 'Canada';
        SI.interestedFieldOfStudy   = 'Engineering';
        SI.preferredUniversity      =  univ.ID;
        
        StudentApplicationClass.personalAddressInformation PAI = new StudentApplicationClass.personalAddressInformation();
        PAI.personalAddressLine     = '4,BuckingHam Palace Road';
        PAI.personalCity            = 'Westminster';
        PAI.personalCountry         = 'United Kingdom';
        PAI.personalZipcode         = 'SW1A 1AA';
        
        StudentApplicationClass.correspondenceAddressInformation CAI = new StudentApplicationClass.correspondenceAddressInformation();
        CAI.isCheck                       = True;
        CAI.correspondenceAddressLine     = '4,BuckingHam Palace Road';
        CAI.correspondenceCity            = 'Westminster';
        CAI.correspondenceCountry         = 'United Kingdom';
        CAI.correspondenceZipcode         = 'SW1A 1AA';
        
        StudentApplicationClass.emergencyContactPerson ECP = new StudentApplicationClass.emergencyContactPerson();
        ECP.emergencyContactPersonName  = 'Andrew';
        ECP.emergencyNumber             = '1234567890';
        ECP.emergencyCoverType          = 'Single';
        ECP.emergencyEmail              = 'Andrew@Emergency.com';
        ECP.firstLanguage               = 'English';
        
        StudentApplicationClass.Qualification  quali = new StudentApplicationClass.Qualification();
        quali.courseName    = 'MCA';
        quali.startedMonth  =  'April';
        quali.startedYear   = '2018';
        quali.finishedMonth = 'April';
        quali.finishedYear  = '2020';
        quali.language      = 'English UK';
        quali.country       = 'UK';
        quali.documentId    = documentObj.Id;
        
        
        StudentApplicationClass.educationalQualification EQ = new StudentApplicationClass.educationalQualification();
        EQ.englishProficiency      = 'Average';
       // EQ.testDate                = '2018-11-20';
       EQ.testDate                = '05/06/2018';
        EQ.ieltsScore			   =  '12.40';		
        EQ.educationQualification  = 'Postgraduate';
        EQ.qualifications          = new Map<String,StudentApplicationClass.Qualification>{'Postgraduate' => quali};            
          
        /* 1st Create Instance with Appication Class */
        
        StudentApplicationClass.Application app = new StudentApplicationClass.Application();
        app.personalInformation              = PI;
        app.studyInterest                    = SI;
        app.personalAddressInformation       = PAI;
        app.correspondenceAddressInformation = CAI;
        app.emergencyContactPerson           = ECP;
        app.educationalQualification         = EQ;
                
        /* Calling all Methods in Apex Class */
        StudentApplicationClass.isEmailExisting('Email@example.com');
        StudentApplicationClass STA = new StudentApplicationClass();
        STA.getpickvalues();
        STA.receiveInput();
        STA.removeInput();
        StudentApplicationClass.getCountryInterestedIn();
        StudentApplicationClass.getEducationPickValues();
        StudentApplicationClass.getExistingUniversities();
        StudentApplicationClass.saveApplication(app);             
    }
}