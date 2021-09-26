/*

Created By :- Arulmozhi.R
Description:- This Class Saves the Student Application Form(SLDS VF Page)

*/

public class StudentApplicationClass {
    
    
  
    
    
    /* Wrapper  Class For Universities */
    public class University {
        public String id;
        public String label;
        public String metaLabel;
        
        public University( String id, String label, String metaLabel ) {
            this.id         = id;
            this.label      = label;
            this.metaLabel  = metaLabel;
        }
        
        public University( University__c  UniversityRecord ) {
            id          = UniversityRecord.Id;
            label       = UniversityRecord.Name;
            metaLabel   = UniversityRecord.University_Address__c;
        }
    }
    
    @RemoteAction
    public static List<University> getExistingUniversities() {
        List<University__c> universityList = [
            SELECT   Id
            ,Name
            ,University_Address__c
            FROM    University__c
        ];
        
        if( universityList != NULL ) {
            List<University> allUniversities = new List<University>();
            for( University__c univVal : universityList ) {
                University univ = new University( univVal );
                allUniversities.add( univ );
            }
            
            return allUniversities;
        }
        
        return NULL;
    }
    
    /* Constructor to call Methods to get all picklist values from Object */
    public StudentApplicationClass() {
        
        getpickvalues();
        qcmap = new Map<String,Qualification__c>();
    }
    
    
    
    public string input1 { get;set; }
    public Map<String,Qualification__c> qcmap{get;set;}
    public string input2 { get;set; }
    
    public list<String> genderList { get;set; }
    public list<String> statusList { get;set; }
    public list<String> maritalStatusList { get;set; }
    public list<String> englishProfList { get;set; }
    public list<String> healthcovertypeList { get;set; }
    public list<String> startMonthList { get;set; }
    public list<String> finishMonthList { get;set; }
    public list<String> sourceList { get;set; }
    public String IsAgent{ get;set; }
    
    public void getpickvalues(){
        
        genderList = new List<String>();
        Schema.DescribeFieldResult gender = Account.Gender__c.getDescribe();
        List<Schema.PicklistEntry> genderVal = gender.getPicklistValues();
        for (Schema.PicklistEntry pickListVal : genderVal)
        {
            genderList.add(pickListVal.getLabel());
        }        
        
        statusList = new List<String>();
        Schema.DescribeFieldResult status = Account.Rating.getDescribe();
        List<Schema.PicklistEntry> statusVal = status.getPicklistValues();
        for (Schema.PicklistEntry pickListVal : statusVal)
        {
            statusList.add(pickListVal.getLabel());
        }
        
        maritalStatusList = new List<String>();
        Schema.DescribeFieldResult maritalStatus = Account.Marital_Status__c.getDescribe();
        List<Schema.PicklistEntry> maritalStatusVal = maritalStatus.getPicklistValues();
        for (Schema.PicklistEntry pickListVal : maritalStatusVal)
        {
            maritalStatusList.add(pickListVal.getLabel());
        }
        
        englishProfList = new List<String>();
        Schema.DescribeFieldResult englishproficiency = Account.Type.getDescribe();
        List<Schema.PicklistEntry> engVal = englishproficiency.getPicklistValues();
        for (Schema.PicklistEntry pickListVal : engVal)
        {
            englishProfList.add(pickListVal.getLabel());
        }
        
        healthcovertypeList = new List<String>();
        Schema.DescribeFieldResult healthcovertype = Account.Industry.getDescribe();
        List<Schema.PicklistEntry> covrtype = healthcovertype.getPicklistValues();
        for (Schema.PicklistEntry pickListVal : covrtype)
        {
            healthcovertypeList.add(pickListVal.getLabel());
        }
        
        startMonthList = new List<String>();
        Schema.DescribeFieldResult qualifstartMonth = Qualification__c.Started_Month__c.getDescribe();
        List<Schema.PicklistEntry> startmonthVal = qualifstartMonth.getPicklistValues();
        for (Schema.PicklistEntry pickListVal : startmonthVal)
        {
            startMonthList.add(pickListVal.getLabel());
        }
        
        finishMonthList = new List<String>();
        Schema.DescribeFieldResult qualiffinishMonth = Qualification__c.Finish_Month__c.getDescribe();
        List<Schema.PicklistEntry> finishmonthVal = qualiffinishMonth.getPicklistValues();
        for (Schema.PicklistEntry pickListVal : finishmonthVal)
        {
            finishMonthList.add(pickListVal.getLabel());
        }
        
        sourceList = new List<String>();
        Schema.DescribeFieldResult accountSource = Account.AccountSource.getDescribe();
        List<Schema.PicklistEntry> sourceVal = accountSource.getPicklistValues();
        for (Schema.PicklistEntry pickListVal : sourceVal)
        {
            sourceList.add(pickListVal.getLabel());
        }
    }
    
    public static String getCountryInterestedIn(){
        
        List<String> productPickListValue = new List<String>();
        Schema.DescribeFieldResult productFieldDescribe = Lead__c.Country_Interested_In__c.getDescribe();
        for(Schema.PicklistEntry loop_var : productFieldDescribe.getPicklistValues()){
            productPickListValue.add(loop_var.getLabel());
        }
        return JSON.serialize(productPickListValue);
    }  
    
    public static String getEducationPickValues(){
        
        List<String> EductnPickListValue = new List<String>();
        Schema.DescribeFieldResult educatnFieldDescribe = Account.Education_Qualification__c.getDescribe();
        for(Schema.PicklistEntry loop_var : educatnFieldDescribe.getPicklistValues()){
            EductnPickListValue.add(loop_var.getLabel());
        }
        return JSON.serialize(EductnPickListValue);
    }  
    
    /* To add Dynamic Qualification for each Education Qualification */
    public PageReference receiveInput() {
        String input1 = Apexpages.currentPage().getParameters().get('input1');
        qcmap.put(input1,new Qualification__c());
        return null;
    }
    
    public PageReference removeInput() {
        String input2 = Apexpages.currentPage().getParameters().get('input2');
        qcmap.remove(input2);
        return null;
    }   
    
    
    /* Form save Method*/
    @RemoteAction
    public static String saveApplication( Application app ) {
        /* Insert Account (Student)*/
        Account acc = new Account();
        
        /* PersonalInformation */
        acc.Agent_Id__c = app.PersonalInformation.agentID;
        acc.First_Name__c = app.PersonalInformation.firstName;
        acc.Last_Name__c = app.PersonalInformation.lastName;
        acc.Email__c = app.PersonalInformation.email;
        acc.Gender__c = app.PersonalInformation.gender;
        acc.Home_Telephone_No__c = app.PersonalInformation.homeTelephone;
        acc.Middle_Name__c = app.PersonalInformation.middleName;
        acc.Marital_Status__c = app.PersonalInformation.maritalStatus;
        acc.Mobile__c = app.PersonalInformation.mobile;
        acc.PersonalCity__c = app.PersonalInformation.city;
        acc.AccountNumber = app.PersonalInformation.passportNo;
        acc.AccountSource = app.PersonalInformation.accountSource;
        
        
        /* Date of Birth Parsing for Personal Information */
        String dob = app.PersonalInformation.DOB ;
        Date dt = Date.parse(dob);
        acc.Date_of_Birth__c = dt;

        
        /* Study Interest */
        acc.Country_Interested_In__c = app.studyInterest.countryInterestedIn;
        acc.Interested_Field_of_Study__c = app.studyInterest.interestedFieldOfStudy;
        acc.Preferred_University__c = app.studyInterest.preferredUniversity;
        
        /* Personal Address */
        acc.BillingStreet = app.personalAddressInformation.personalAddressLine;
        acc.BillingCity = app.personalAddressInformation.personalCity;
        acc.BillingCountry = app.personalAddressInformation.personalCountry;
        acc.BillingPostalCode = app.personalAddressInformation.personalZipcode;
        
        /* Correspondence Address */
        acc.Copy_address_from_permanent_Address__c = app.correspondenceAddressInformation.isCheck;
        acc.ShippingStreet = app.correspondenceAddressInformation.correspondenceAddressLine;
        acc.ShippingCity = app.correspondenceAddressInformation.correspondenceCity;
        acc.ShippingCountry = app.correspondenceAddressInformation.correspondenceCountry;
        acc.ShippingPostalCode = app.correspondenceAddressInformation.correspondenceZipcode;
        
        /* Emergency Contact Person */
        acc.Emergency_Contact_Person_Name__c = app.emergencyContactPerson.emergencyContactPersonName;
        acc.Contact_Number__c = app.emergencyContactPerson.emergencyNumber;
        acc.Industry = app.emergencyContactPerson.emergencyCoverType;
        acc.Emergency_Email__c   = app.emergencyContactPerson.emergencyEmail;
        acc.What_is_your_first_language__c = app.emergencyContactPerson.firstLanguage;
        
        /* Account Education Qualification */
        acc.Type = app.EducationalQualification.englishProficiency;
        
        String Score = app.EducationalQualification.ieltsScore;
        if( Score != NULL && Score != '' ) {
            acc.IELTS_Score__c = Decimal.valueOf(Score);
        }
        
        String eduDate = app.EducationalQualification.testDate ;
        
        if( eduDate != NULL ) {
            Date testDate = Date.parse(eduDate);
            acc.Test_Date__c = testDate;
        }
        
        acc.Education_Qualification__c = app.EducationalQualification.educationQualification;
        String abc = app.PersonalInformation.firstName + '' +app.PersonalInformation.lastName;
        // app.EducationalQualification.nameofCourseAward;
        
        INSERT acc;  
      
        
        /* Insert Application */
        
        Application__c appln;
        List<Application__c> applications = new List<Application__c>();
        
        String str = app.studyInterest.countryInterestedIn;
        
        if(str != null){ 
            List<String> listval = str.split(';');

            for(Integer i=0;i<listval.size();i++){
                
              appln = new Application__c();
              appln.Student__c    = acc.Id;
              appln.University_in_Country__c = listval[i];
                if(i==0){
                  appln.Preferred_University__c = app.studyInterest.preferredUniversity;
                }
                 applications.add(appln);
                }
            
              Insert applications;
             }
        
        
        List<Qualification__c> qualificationsToCreate = new List<Qualification__c>();
        for( String key : app.educationalQualification.qualifications.keySet() ) {
            qualificationsToCreate.add(
                new Qualification__c(
                    Name = key
                    ,Student__c = acc.Id
                    ,Name_of_course_award__c = app.educationalQualification.qualifications.get( key ).courseName
                    ,School_institution__c = app.educationalQualification.qualifications.get( key ).schoolName
                    ,Country__c = app.educationalQualification.qualifications.get( key ).country
                    ,Language__c = app.educationalQualification.qualifications.get( key ).language
                    ,Started_Month__c = app.educationalQualification.qualifications.get( key ).startedMonth
                    ,Started_Year__c = app.educationalQualification.qualifications.get( key ).startedYear
                    ,Finish_Month__c =  app.educationalQualification.qualifications.get( key ).finishedMonth
                    ,Finish_Year__c =  app.educationalQualification.qualifications.get( key ).finishedYear
                )
            );
        }
        
        INSERT qualificationsToCreate;
        
        List<Attachment> attachmentsToCreate = new List<Attachment>();
        for( Qualification__c quali : qualificationsToCreate ) {
            for( String key : app.educationalQualification.qualifications.keySet() ) {
                if( quali.Name == key ) {
                    Document doc = [
                        SELECT  Id, Name, ContentType, Body 
                        FROM    Document
                        WHERE   Id = :app.educationalQualification.qualifications.get( key ).documentId
                    ];
                    if (doc != null) {
                        Attachment att = new Attachment();
                        
                        att.parentId = quali.Id;
                        att.Name = doc.Name;
                        att.ContentType = doc.ContentType;
                        att.Body = doc.Body;
                        
                        attachmentsToCreate.add( att );
                    }
                }
            }
        }
        
        INSERT attachmentsToCreate;
        
        return NULL;
        
    }
    
    /* Wrapper Class to get all Instances of Objects*/
    public class PersonalInformation {
        
        public PersonalInformation(){}
        
        public String agentID;
        public String firstName;
        public String lastName;
        public String email;
        public String gender;
        public String DOB;
        public String homeTelephone;
        //public String status;
        public String middleName;
        public String maritalStatus;
        public String mobile;
        public String city;
        public String passportNo;
        public String accountSource; 
        
    }
    
    public class StudyInterest {
        
        public StudyInterest(){}
        
        public String countryInterestedIn;
        public String interestedFieldOfStudy;
        public String preferredUniversity;
        
    }
    
    public class PersonalAddressInformation {
        
        public PersonalAddressInformation(){}             
        
        public String personalAddressLine;
        public String personalCity;
        public String personalCountry;
        public String personalZipcode;
        
    }
    
    public class CorrespondenceAddressInformation {
        
        public CorrespondenceAddressInformation(){}
        
        public Boolean isCheck;
        public String correspondenceAddressLine;
        public String correspondenceCity;
        public String correspondenceCountry;
        public String correspondenceZipcode;
        
    }
    
    public class EmergencyContactPerson {
        
        public EmergencyContactPerson(){}
        
        public String emergencyContactPersonName;
        public String emergencyNumber;
        public String emergencyCoverType;
        public String emergencyEmail;
        public String firstLanguage;
        
    }
    
    public class Qualification {
        
        public Qualification(){}
        
        public String country;
        public String courseName;
        public String finishDate;
        public String language;
        public String schoolName;
        public String startedMonth;
        public String startedYear;
        public String finishedMonth;
        public String finishedYear;
        public String documentId;
    }
    
    public class EducationalQualification {
        
        public EducationalQualification(){}
        
        public String englishProficiency;
        public String ieltsScore;
        public String testDate;
        public String educationQualification;
        public Map<String, Qualification> qualifications;
        
    }
    
    public class Application {
        
        public Application(){}
        
        public PersonalInformation personalInformation;
        public StudyInterest studyInterest;
        public personalAddressInformation personalAddressInformation;
        public CorrespondenceAddressInformation correspondenceAddressInformation;
        public EmergencyContactPerson emergencyContactPerson;
        public EducationalQualification educationalQualification;
        
    }
    
    @RemoteAction
    public static Boolean isEmailExisting( String email ) {
        List<Account> accEmail = new List<Account>();
        
        accEmail = [
            SELECT  Id,Email__c 
            FROM    Account
            WHERE   Email__c = :email
        ];
        
        return !accEmail.isEmpty();
    }
    
}