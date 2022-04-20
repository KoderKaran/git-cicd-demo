window._snapinsSnippetSettingsFile = (function() {
console.log("Snippet settings file loaded.");    // Logs that the snippet settings file was loaded successfully

embedded_svc.snippetSettingsFile.autoOpenPostChat = false;

var prechatFormData;
embedded_svc.snippetSettingsFile.directToButtonRouting = function(prechatFormData) {
    
console.log("Prechat Values");
console.log("prechatFormData[0] " + prechatFormData[0].value);
console.log("prechatFormData[1] " + prechatFormData[1].value);
console.log("prechatFormData[2] " + prechatFormData[2].value);
console.log("prechatFormData[3] " + prechatFormData[3].value);
console.log("prechatFormData[4] " + prechatFormData[4].value);    

if (prechatFormData[4].value === "Control4")
  return "57350000000PBKI";
else if (prechatFormData[4].value === "Pakedge")
  return "57338000000PBMi";
else if (prechatFormData[4].value === "Triad")
  return "57338000000Caoe";
else if (prechatFormData[4].value === "Araknis")
 return "57338000000Gn1E";
else if (prechatFormData[4].value === "Binary")
 return "573380000004CmX";
else if (prechatFormData[4].value === "Luma")
 return "573380000004CmX";
else if (prechatFormData[4].value === "Wattbox")
 return "573380000004CmX";
else if (prechatFormData[4].value === "Episode")
 return "573380000004CmX";
else if (prechatFormData[4].value === "Other")
 return "573380000004CmX";
};

embedded_svc.snippetSettingsFile.extraPrechatFormDetails = [
{"label":"Subject","value":"Testing","displayToAgent":true, "transcriptFields": ["Subject__c"]},
{"label":"LastName","value":"Doe","displayToAgent":true}
}]; 



embedded_svc.snippetSettingsFile.extraPrechatInfo = [{
"entityName": "Contact",
"showOnCreate": true,
"linkToEntityName": "Case",
"linkToEntityField": "ContactId",
"saveToTranscript": "ContactId",
"entityFieldMaps" : [{
"doFind":true,
"doCreate":false,
"fieldName":"Email",
"isExactMatch":true,
"label":"Email"
}],
}, {
"entityName":"Case",
"showOnCreate": true,
"saveToTranscript": "CaseId",
"entityFieldMaps": [{
"isExactMatch": false,
"fieldName": "Subject",
"doCreate": true,
"doFind": false,
"label": "Subject"
}, {
"isExactMatch": false,
"fieldName": "Status",
"doCreate": false,
"doFind": false,
"label": "Status"
}, {
"isExactMatch": false,
"fieldName": "Origin",
"doCreate": false,
"doFind": false,
"label": "Origin"
}]
}];
})();