public with sharing class FacebookClasses {  
        
    public class Cursors {
        public String before;
        public String after;
    }
    
    public class Paging {
        public Cursors cursors;
    }
    
    public class FieldDatum {
        public String name;
        public List<String> values;
    }
    
    public class Datum {
        public String created_time;
        public String id;
        public List<FieldDatum> field_data;
    }
    
    public class FacebookResponse {
        public List<Datum> data;
        public Paging paging;
    }
}