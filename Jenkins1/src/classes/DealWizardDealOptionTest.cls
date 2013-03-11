@isTest
public class DealWizardDealOptionTest {

  // describe: empty constructor
  static TestMethod void errors_is_initially_empty() {
    DealWizardDealOption deal_option = new DealWizardDealOption();

    System.assert( deal_option.errors != null );
    System.assert( deal_option.errors.isEmpty() );
  }

  // describe: normalize_display_order_on_options()

    // context: given one option with display order of 2
    static TestMethod void it_assigns_1_as_the_option_display_order() {

      DealWizardDeal deal = new DealWizardDeal();
      DealWizardDealOption option = new DealWizardDealOption();
      option.display_order = 2;
      deal.options.add( option );

      DealWizardDealOption.reorder_and_normalize_display_order_on_options( deal );
      System.assert( deal.options[0].display_order == 1 );
    }
    
    // context: given two options, one with display order of 1, and the other with 3
    static TestMethod void it_assigns_2_as_the_highest_option_display_order() {

      DealWizardDeal deal = new DealWizardDeal();
      
      DealWizardDealOption first_option = new DealWizardDealOption();
      first_option.display_order = 1;
      deal.options.add( first_option );
      
      DealWizardDealOption second_option = new DealWizardDealOption();
      second_option.display_order = 3;
      deal.options.add( second_option );

      DealWizardDealOption.reorder_and_normalize_display_order_on_options( deal );
      
      System.assert( deal.options[0].display_order == 1 );
      System.assert( deal.options[1].display_order == 2 );
    }
    
    // context: given two options, one with display order of 3, and the other with 1
    static TestMethod void it_assigns_2_as_the_highest_option_display_order_and_reorders_options() {

      DealWizardDeal deal = new DealWizardDeal();
      
      DealWizardDealOption first_option = new DealWizardDealOption();
      first_option.display_order = 1;
      deal.options.add( first_option );
      
      DealWizardDealOption second_option = new DealWizardDealOption();
      second_option.display_order = 3;
      deal.options.add( second_option );

      DealWizardDealOption.reorder_and_normalize_display_order_on_options( deal );
      
      System.assert( deal.options[0].display_order == 1 );
      System.assert( deal.options[1].display_order == 2 );
    }

  // describe: next_persisted_option_position(...)
  
    // context: given last position is -1 and failed positions is [1] and number of options in request is 2

    //static TestMethod void it_should_return_zero() {

    //  List<Integer> failed_positions = new List<Integer>();
    //  failed_positions.add( 1 );
    //  System.assert( DealWizardDealOption.next_successfully_persisted_position( -1, failed_positions, 2 ) == 0 );
    //}

  // TODO: finish writing test
  // describe: add_and_log_error
  //static TestMethod void an_error_can_be_added() {
  //  DealWizardDealOption deal_option = new DealWizardDealOption();


  //  System.debug( deal_option.errors );
  //  System.assert( !deal_option.errors.isEmpty() );
  //}

}