/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class RESTs3API_ContactTest {

  static testMethod void testContactPUTReturnsContactHavingNonNullIdWhenGivenValidCreateRequest() {
    S3Contact postedContact = new S3Contact();
    postedContact.first_name = 'new Name for Merchant';
    postedContact.last_name     = 'new Last Name for Merchant';
    postedContact.phone       = '5551231234';
    postedContact.email    = 'test@email.com';

    // call the REST controller method
    S3Contact returnedContact = RESTs3API_Contact.contact_PUT( postedContact );

    // assertion
    System.assertEquals( 'test@email.com', returnedContact.email );
    
    // assertion
    System.assertNotEquals( null, returnedContact.id );
  }

  static testMethod void testContactPOSTReturnsContactHavingNonNullIdWhenGivenValidUpdateRequest() {

    // Given an account
    Contact Contact = LibraryRESTControllerTestHelpers.buildContact(); 
    insert contact;

    // Provide POST params as a basic S3MerchantAccount
    S3Contact postedContact = new S3Contact();
    postedContact.first_name = 'new Name for Merchant';
    postedContact.last_name     = 'new Last Name for Merchant';
    postedContact.phone       = '5551231234';
    postedContact.email    = 'test@email.com';
    postedContact.id = contact.Id;

    // call the REST controller method
    S3Contact returnedContact = RESTs3API_Contact.contact_POST( postedContact );

    // assertion
    System.assertEquals( 'test@email.com', returnedContact.email );
  }

  static testMethod void testContactGETReturnsContactHavingNonNullIdWhenGivenValidAccountId() {

    // Given an account
    Contact contact = LibraryRESTControllerTestHelpers.buildContact(); 
    insert contact;

    // Set parameters on request
    RestRequest request = new RestRequest();
    request.params.put( 'salesforce_id', contact.id );
    System.RestContext.request = request;
    
    // call controller method
    S3Contact returnedContact = RESTs3API_Contact.contact_get();

    // assertion
    System.assertNotEquals( null, returnedContact.id );
  }
}