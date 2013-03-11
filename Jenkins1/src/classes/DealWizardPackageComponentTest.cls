@isTest
public class DealWizardPackageComponentTest {
// TODO: extract setUp() method and other helper methods, to remove duplication

  static DealWizardDeal setup_deal_with_deal_option() {
    Opportunity opportunity = DealWizardTestHelper.buildOpportunity();
    insert opportunity;
    Account account = DealWizardTestHelper.buildAccount();
    insert account;

    DealWizardDeal deal = DealWizardTestHelper.buildDealWizardDealWithOption(opportunity, account);

    deal.do_upsert();
    return deal;
  }

  // describe: persist_all_specified_and_delete_all_excluded
    // context (create): no components exist initially (in the database associated with a deal option)

    static testMethod void testComponentIsCreatedWhenSpecified() {

      DealWizardDeal deal = setup_deal_with_deal_option();
      DealWizardDealOption deal_option = deal.options[0];
      //System.assert( deal_option.id != null );  // NOTE: this assertion failed, so option had a null id at this point

      // add (unpersisted) component to an option on a deal
      DealWizardPackageComponent first_component = new DealWizardPackageComponent();
      first_component.description = 'the whole is greater than sum of parts';
      first_component.option_id = deal_option.id;
      first_component.value = 10.50;

      List<DealWizardPackageComponent> components = new List<DealWizardPackageComponent>();
      components.add( first_component );
      deal_option.package_components = components;
      System.assert( deal_option.package_components.size() == 1 );

      // call method under test
      DealWizardPackageComponent.persist_all_specified_and_delete_all_excluded( deal_option, deal ); 
      
      // fetch (persisted) components from database
      List<Package_Component__c> components_on_option = [select id from Package_Component__c where Multi_Deal__c = :deal_option.id];

      System.assert( components_on_option.size() == 1 ); 
    }

    // context: one field does not pass validations, match field type, or exceeds field size

    static testMethod void testComponentIsNotCreatedWhenOneOfItsFieldsIsInvalid() {

      DealWizardDeal deal = setup_deal_with_deal_option();
      DealWizardDealOption deal_option = deal.options[0];
      //System.assert( deal_option.id != null );  // NOTE: this assertion failed, so option had a null id at this point

      // add (unpersisted) component to an option on a deal
      DealWizardPackageComponent first_component = new DealWizardPackageComponent();
      first_component.description = 'the whole is greater than sum of parts';
      first_component.option_id = deal_option.id;
      first_component.value = 123456789012345678901.5;  // NOTE: field is too large and will trigger error

      List<DealWizardPackageComponent> components = new List<DealWizardPackageComponent>();
      components.add( first_component );
      deal_option.package_components = components;
      System.assert( deal_option.package_components.size() == 1 );

      // call method under test
      DealWizardPackageComponent.persist_all_specified_and_delete_all_excluded( deal_option, deal ); 
      
      // fetch (persisted) components from database
      List<Package_Component__c> components_on_option = [select id from Package_Component__c where Multi_Deal__c = :deal_option.id];

      System.assert( components_on_option.size() == 0 );  // assert: wasn't persisted
      System.assert( deal.has_errors == true );           // assert: deal option has errors
      System.assert( deal_option.errors.size() == 1 );    // assert: deal option has errors
    }


    // context (update): a component exists initially (in the database associated with this deal)
 
//    static testMethod void testQuestionIsUpdatedWhenSpecified() {
//
//      DealWizardDeal deal = DealWizardTestHelper.buildDeal();
//      System.assert( deal.id != null );
//
//      // add (unpersisted) question to deal
//      Question_DW__c question_sobject = new Question_DW__c();
//      question_sobject.opportunity__c = deal.id;
//      question_sobject.dwid__c = '1234';
//      question_sobject.questions__c = 'What am I thinking?';
//      question_sobject.Answer__c = 'Whether I can guess.';
//      Database.insert( question_sobject );
//      // fetch (persisted) questions from database, to establish existence
//      List<Question_DW__c> questions_on_deal = [ select id, Answer__c from Question_DW__c where Opportunity__c = : deal.id ];
//      System.assert( questions_on_deal.size() == 1 ); 
//      System.assert( questions_on_deal.get(0).Answer__c == 'Whether I can guess.' ); 
//
//      // provide an updated answer to store
//      DealWizardDealQuestion first_question = new DealWizardDealQuestion( question_sobject );
//      first_question.answer = 'My foot hurts.';
//
//      List<DealWizardDealQuestion> questions = new List<DealWizardDealQuestion>();
//      questions.add( first_question );
//      deal.questions = questions;
//
//      System.assert( deal.questions.size() == 1 );
//      System.assert( first_question.id != null );
//
//      // call method under test
//      DealWizardDealQuestion.create_or_update_all_for_deal( deal ); 
//      
//      // fetch (persisted) questions from database
//      questions_on_deal = [ select id, Answer__c from Question_DW__c where Opportunity__c = : deal.id ];
//      Question_DW__c first_processed_question = questions_on_deal.get(0);
//
//      System.debug( '==== stored answer on this question (' + first_processed_question.id + '):  ' + first_processed_question.Answer__c );
//
//      System.assert( first_processed_question.Answer__c == 'My foot hurts.' ); 
//    }
//
//

  // context: some components exist initially and an empty array is sent as the components collection
 
//    
//    static testMethod void testAllQuestionsAreDeletedWhenNoneAreSpecified() {
//    }
//
//
//    // NOTE: expect to fail
//    static testMethod void testAllButOneQuestionIsDeletedWhenThatOneIsSpecified() {
//
//      DealWizardDeal deal = DealWizardTestHelper.buildDeal();
//
//      // Given one (persisted) question on deal
//      Question_DW__c question_sobject = new Question_DW__c();
//      question_sobject.opportunity__c = deal.id;
//      question_sobject.dwid__c = '1234';
//      question_sobject.questions__c = 'What am I thinking?';
//      question_sobject.Answer__c = 'Whether I can guess.';
//      Database.insert( question_sobject );
//
//      // fetch (persisted) questions from database, to establish existence
//      List<Question_DW__c> questions_on_deal = [ select id from Question_DW__c where Opportunity__c = : deal.id ];
//      System.assert( questions_on_deal.size() == 1 ); 
//
//      // provide that single question on the deal object from the request
//      DealWizardDealQuestion first_question = new DealWizardDealQuestion( question_sobject );
//      List<DealWizardDealQuestion> questions = new List<DealWizardDealQuestion>();
//      questions.add( first_question );
//      deal.questions = questions;
//
//      System.assert( deal.questions.size() == 1 );
//
//      // call method under test (delete all but specified question, means, delete nothing in this case)
//      DealWizardDealQuestion.delete_all_unspecified_on_deal( deal ); 
//      
//      // fetch (persisted) questions from database
//      questions_on_deal = [ select id from Question_DW__c where Opportunity__c = : deal.id ];
//      
//      System.assert( questions_on_deal.size() == 1 );
//    }
//
//

}