({
	successfulDelete : function(cmp, event) {
		var secondHeaderLabel = $A.get("$Label.c.ToastTitleDelete");
		var secondMsgLabel = $A.get("$Label.c.DeletionProcess");

		var action = cmp.get("c.DeleteAllLeadsCallBatch");
		action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
				console.log('Result from server-->>> ' + response.getReturnValue());
			}
		});
		$A.enqueueAction(action);
		var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
 					"title": secondHeaderLabel,
 					"message": secondMsgLabel,
					"type": "success"
 				});
 		toastEvent.fire();
		var dismissActionPanel = $A.get("e.force:closeQuickAction");
		dismissActionPanel.fire();
	}
})