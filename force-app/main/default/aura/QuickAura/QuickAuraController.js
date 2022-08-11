({
	myAction : function(component, event, helper) {
		
	},

	handleCancel : function(){
		var dismissActionPanel = $A.get("e.force:closeQuickAction");
		dismissActionPanel.fire();
	},

	handleSubmit : function(cmp, event, helper){
		helper.successfulDelete(cmp, event);
	}

})