trigger Technician_setCertificateImages on C4_Training_Certification__c (before insert, before update) {

    Map <String, Certificate_Default_Badge__mdt> typesMap = new Map<String, Certificate_Default_Badge__mdt>();
    Certificate_Default_Badge__mdt[] certificateBadges = [SELECT Certificate_Type__c, Certificate_Default_Badge_URL__c, Certificate_Color_Badge_URL__c FROM Certificate_Default_Badge__mdt];

    for (Certificate_Default_Badge__mdt certificateBadge : certificateBadges) {
        typesMap.put(certificateBadge.Certificate_Type__c, certificateBadge);
    }

    for (C4_Training_Certification__c certificate : trigger.New) {
        if (typesMap.containsKey(certificate.Type__c)) {
            Certificate_Default_Badge__mdt currentCertificateBadge = typesMap.get(certificate.Type__c);
            certificate.TBD__c = currentCertificateBadge.Certificate_Default_Badge_URL__c;
            certificate.TBD_Color__c = currentCertificateBadge.Certificate_Color_Badge_URL__c;
        }
    }
}