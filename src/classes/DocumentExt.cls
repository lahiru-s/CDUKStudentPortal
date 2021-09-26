public class DocumentExt {
    public documentExt( ApexPages.StandardController controller ) {
        Document d = (Document) controller.getRecord();
        d.FolderId = UserInfo.getUserId();
    }
}