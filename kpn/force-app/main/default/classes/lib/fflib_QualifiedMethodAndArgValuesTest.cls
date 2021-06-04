@isTest
private class fflib_QualifiedMethodAndArgValuesTest {

    @isTest
    static void myUnitTest() {

        fflib_QualifiedMethod qm1 = new fflib_QualifiedMethod('Type1', 'Method1', new List<Type>{ Integer.class } );
        fflib_MethodArgValues args = new fflib_MethodArgValues(new List<Object>{ 'hello' });

        fflib_QualifiedMethodAndArgValues myObj = new fflib_QualifiedMethodAndArgValues(qm1,args,null);

        myObj.getQualifiedMethod();
        myObj.getMethodArgValues();
        myObj.getMockInstance();
        myObj.toString();
    }
}