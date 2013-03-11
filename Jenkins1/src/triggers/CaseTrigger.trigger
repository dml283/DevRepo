trigger CaseTrigger on Case (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
	if (trigger.isBefore) {
		if (trigger.isInsert) {
			CaseUtils.processCases(trigger.new);
		}
		
		if (trigger.isUpdate) {
		}
		
		if (trigger.isDelete) {
		}
	}

	if (trigger.isAfter) {
		if (trigger.isInsert) {
			CaseUtils.markForDeletion(trigger.new);
		} 
		
		if (trigger.isUpdate) {
		}
		
		if (trigger.isDelete) {
		}
		
		if (trigger.isUndelete) {
		}
	}
}