({
	handleCancel : function(cmp, event, helper){
		helper.cancel(cmp, event);
	},

	handleSubmit : function(cmp, event, helper){
		helper.successfulDelete(cmp, event);
	}

})