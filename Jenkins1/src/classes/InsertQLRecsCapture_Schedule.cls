global class InsertQLRecsCapture_Schedule {
	global void execute (SchedulableContext scMain) {
		InsertQLRecsCapture cls = new InsertQLRecsCapture();
		Database.executeBatch(cls);
	}
}