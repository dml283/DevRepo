global class UpdateAccountQLValsBatch_Schedule {
	global void execute (SchedulableContext scMain) {
		UpdateAccountQLValsBatch cls = new UpdateAccountQLValsBatch();
		Database.executeBatch(cls);
	}
}