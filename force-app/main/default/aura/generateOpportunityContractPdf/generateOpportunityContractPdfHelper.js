({
    getStep : function(component) {
        var currentStep = component.get('c.getStep');
        currentStep.setParams({
            "recordId": component.get("v.recordId")
        });
        currentStep.setCallback(this, function(response){
            component.set("v.selectedStep", response.getReturnValue());
            if (response.getReturnValue() == "step5"){
               component.set("v.hasError", false);
            }
        });
        $A.enqueueAction(currentStep);
    }
})