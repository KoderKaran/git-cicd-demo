@isTest
private class GlobalVariablesTest {

    @isTest
    static void variablesTest() {
        Integer fieldTypeMapSize = GlobalVariables.FieldTypeMap.size();
        Integer fieldLabelToNameMapSize = GlobalVariables.fieldLabelToNameMap.size();
        Integer descirbeFieldResultMapSize = GlobalVariables.descirbeFieldResultMap.size();
        System.assert(fieldTypeMapSize > 0);
        System.assert(fieldLabelToNameMapSize > 0);
        System.assert(descirbeFieldResultMapSize > 0);
    }
}