/**
 * Copyright (c), FinancialForce.com, inc
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification, 
 *   are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice, 
 *      this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice, 
 *      this list of conditions and the following disclaimer in the documentation 
 *      and/or other materials provided with the distribution.
 * - Neither the name of the FinancialForce.com, inc nor the names of its contributors 
 *      may be used to endorse or promote products derived from this software without 
 *      specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
 *  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
 *  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL 
 *  THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
 *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 *  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 *  OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 *  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/

@IsTest
private with sharing class fflib_SObjectSelectorTest 
{
	
	static testMethod void testGetSObjectName()
	{
		Testfflib_SObjectSelector selector = new Testfflib_SObjectSelector();
		system.assertEquals(null, selector.getSObjectFieldSetList());
		system.assertEquals('Account',selector.getSObjectName());
	}
	
	static testMethod void testSOQL()
	{
		Testfflib_SObjectSelector selector = new Testfflib_SObjectSelector();
		String soql = selector.newQueryFactory().toSOQL();
		Pattern p = Pattern.compile('SELECT (.*) FROM Account ORDER BY Name DESC NULLS FIRST , AnnualRevenue ASC NULLS LAST ');
		Matcher m = p.matcher(soql);
		System.assert(m.matches(), 'Generated SOQL does not match expected pattern. Here is the generated SOQL: ' + soql);
		System.assertEquals(1, m.groupCount(), 'Unexpected number of groups captured.');
		String fieldListString = m.group(1);
		assertFieldListString(fieldListString, null);
	}
	
	static testMethod void testDefaultConfig()
	{
		Testfflib_SObjectSelector selector = new Testfflib_SObjectSelector();
		System.assertEquals(false, selector.isEnforcingFLS());
		System.assertEquals(true, selector.isEnforcingCRUD());
		System.assertEquals(false, selector.isIncludeFieldSetFields());
		
		System.assertEquals('Account', selector.getSObjectName());
		System.assertEquals(Account.SObjectType, selector.getSObjectType2());
	}
	
	private static void assertFieldListString(String fieldListString, String prefix) {
		String prefixString = (!String.isBlank(prefix)) ? prefix + '.' : '';
		List<String> fieldList = fieldListString.split(',{1}\\s?');
		System.assertEquals(UserInfo.isMultiCurrencyOrganization() ? 5 : 4, fieldList.size()); 
		Set<String> fieldSet = new Set<String>();
		fieldSet.addAll(fieldList);
		String expected = prefixString + 'AccountNumber';
		System.assert(fieldSet.contains(expected), expected + ' missing from field list string: ' + fieldListString);
		expected = prefixString + 'AnnualRevenue';
		System.assert(fieldSet.contains(expected), expected + ' missing from field list string: ' + fieldListString);
		expected = prefixString + 'Id';
		System.assert(fieldSet.contains(expected), expected + ' missing from field list string: ' + fieldListString);
		expected = prefixString + 'Name';
		System.assert(fieldSet.contains(expected), expected + ' missing from field list string: ' + fieldListString);
		if (UserInfo.isMultiCurrencyOrganization()) {
			expected = prefixString + 'CurrencyIsoCode';
			System.assert(fieldSet.contains(expected), expected + ' missing from field list string: ' + fieldListString);
		}
	}
	

	@isTest
	static void testWithoutSorting()
	{
		//Given
		Testfflib_SObjectSelector selector = new Testfflib_SObjectSelector(false, false, false, false);
		fflib_QueryFactory qf = selector.newQueryFactory();
		
		Set<String> expectedSelectFields = new Set<String>{ 'Name', 'Id', 'AccountNumber', 'AnnualRevenue' };
		if (UserInfo.isMultiCurrencyOrganization())
		{
			expectedSelectFields.add('CurrencyIsoCode');
		}

		//When
		String soql = qf.toSOQL();

		//Then
		Pattern soqlPattern = Pattern.compile('SELECT (.*) FROM Account ORDER BY Name DESC NULLS FIRST , AnnualRevenue ASC NULLS LAST ');
		Matcher soqlMatcher = soqlPattern.matcher(soql);
		soqlMatcher.matches();

		List<String> actualSelectFields = soqlMatcher.group(1).deleteWhiteSpace().split(',');
		System.assertEquals(expectedSelectFields, new Set<String>(actualSelectFields));
	}

	// Test case of ordering with NULLS LAST option passed into the ordering method
	@isTest
	static void testWithOrderingNullsLast()
	{
		// Build the selector to test with
		Testfflib_SObjectSelector selector = new Testfflib_SObjectSelector(false, false, false, false);
		fflib_QueryFactory qf = selector.newQueryFactory();
		
		// Add in the expected fields
		Set<String> expectedSelectFields = new Set<String>{ 'Name', 'Id', 'AccountNumber', 'AnnualRevenue' };
		if (UserInfo.isMultiCurrencyOrganization())
		{
			expectedSelectFields.add('CurrencyIsoCode');
		}

		// Generate the SOQL string
		String soql = qf.toSOQL();

		// Assert that the
		Pattern soqlPattern = Pattern.compile('SELECT (.*) FROM Account ORDER BY Name DESC NULLS FIRST , AnnualRevenue ASC NULLS LAST ');
		Matcher soqlMatcher = soqlPattern.matcher(soql);
		system.assert(soqlMatcher.matches(), 'The SOQL should have that expected.');
	}


	private static void assertEqualsSelectFields(String expectedSelectFields, String actualSelectFields)
	{
		Set<String> expected = new Set<String>(expectedSelectFields.deleteWhiteSpace().split(','));
		Set<String> actual = new Set<String>(actualSelectFields.deleteWhiteSpace().split(','));

		System.assertEquals(expected, actual);
	}
	
	private class Testfflib_SObjectSelector extends fflib_SObjectSelector
	{
		public Testfflib_SObjectSelector()
		{
			super();
		}

		public Testfflib_SObjectSelector(Boolean includeFieldSetFields, Boolean enforceCRUD, Boolean enforceFLS, Boolean sortSelectFields)
		{
			super(includeFieldSetFields, enforceCRUD, enforceFLS, sortSelectFields);
		}
		
		public List<Schema.SObjectField> getSObjectFieldList()
		{
			return new List<Schema.SObjectField> {
				Account.Name,
				Account.Id,
				Account.AccountNumber,
				Account.AnnualRevenue
			};
		}
		
		public Schema.SObjectType getSObjectType()
		{
			return Account.sObjectType;
		}
		
		public override String getOrderBy()
		{
			return 'Name DESC, AnnualRevenue ASC NULLS LAST';
		}
	}
	
}