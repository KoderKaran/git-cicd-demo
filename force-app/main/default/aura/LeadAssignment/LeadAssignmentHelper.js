({
    getUrlParameter : function(sParam) {
        var sPageURL = decodeURIComponent(window.location.search.substring(1)),
            sURLVariables = sPageURL.split('&'),
            sParameterName,
            i;

        for (i = 0; i < sURLVariables.length; i++) {
            sParameterName = sURLVariables[i].split('=');

            if (sParameterName[0] === sParam) {
                return sParameterName[1] === undefined ? true : sParameterName[1];
            }
        }
    },

    buttonUpdate : function(component) {

        if (component.get("v.sendImmediately").length + component.get("v.sendLater") == 0) {
            component.set("v.disabledSent", true);
        } else {
            component.set("v.disabledSent", false);
        }

    }

    // refreshDealers : function(component) {

    //     var dealers = component.get("v.dealers");
    //     var sendImmediately = component.get("v.sendImmediately");
    //     var sendLater = component.get("v.sendLater");

    //     for (var i = sendImmediately.length - 1; i >= 0; i--) {
    //         dealers.push(sendImmediately[i]);
    //         sendImmediately.splice(i, 1);
    //     }

    //     for (var i = sendLater.length - 1; i >= 0; i--) {
    //         dealers.push(sendLater[i]);
    //         sendLater.splice(i, 1);
    //     }

    //     component.set('v.sendImmediately', []);
    //     component.set('v.sendLater', []);
    //     component.set('v.dealers', dealers);
    //     component.set('v.disabledSent', true);
    // }

})