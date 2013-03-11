@isTest
public class REST_task_API_tests {
  static testMethod void testGet() {
    RestContext.request = new RestRequest();
    User user = new GrouponTestUtil().createTestUser('System Administrator');

    System.runAs(user) {
      Task task = new GrouponTestUtil().createTask('My Task');
      insert task;

      RestContext.request.addParameter('id', task.Id);
      Task receivedTask = REST_task_API.get();

      System.assertEquals('My Task', receivedTask.Subject);
    }
  }

  static testMethod void testPost() {
    RestContext.request = new RestRequest();
    User user = new GrouponTestUtil().createTestUser('System Administrator');

    System.runAs(user) {
      Task task = new GrouponTestUtil().createTask('My Task');
      insert task;
      task.Subject = 'Changed Task';

      REST_task_API.post(task);

      Task changedTask = [SELECT Subject FROM Task WHERE Id = :task.id LIMIT 1];

      System.assertEquals('Changed Task', changedTask.Subject);
    }
  }
}