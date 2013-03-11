public class WorkbenchRedirect{

public PageReference redirect() {
        return new PageReference('https://sales-workbench.groupondev.com/call_list');
    }
public PageReference redirectCommission() {
        return new PageReference('https://sales-workbench.groupondev.com/commission');
    }
}