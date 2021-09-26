public class FileUploaderController {
    public FileUploaderController( ApexPages.StandardController controller ) {
        Document d = (Document) controller.getRecord();
        d.FolderId = UserInfo.getUserId();
    }
}