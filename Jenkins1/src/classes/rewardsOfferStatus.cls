public class rewardsOfferStatus {

  public Map<Id,String> offerStatus {get;set;}
  public Set<String> offerStatusSet = new set<string>();
  public Map<Id,List<Opportunity>> opptyRewards = new Map<Id,List<Opportunity>>();
  public String status = '';
  public List<Account> accountsToUpdate = new List<Account>();
    
  public rewardsOfferStatus(Account a, List<Opportunity> oList) {
    this.offerStatus = new Map<Id,String>();
            
    for(Opportunity o : oList) {
      if(o.Feature_date__c < = System.today() && o.Feature_end_date__c >= System.today() && o.StageName == 'Closed Won') {
        offerStatusSet.add('Live');
      } else if(o.Feature_end_date__c <= System.today() && o.StageName =='Closed Won') {
        offerStatusSet.add('Pulled');
      } else {
        offerStatusSet.add(o.StageName);
      }
    }
                
    status = getOfferStatus(offerStatusSet);
    a.Rewards_Offer_Status__c = status;
  }
        
  public string getOfferStatus(Set<String> offerStatusSet) {
    String offerStatus = '';

    if(offerStatusSet.Contains('Not Contacted')) {
      offerStatus = 'Not Contacted';
    } 
    if(offerStatusSet.Contains('Rejected')) {
      offerStatus = 'Rejected';  
    }
    if(offerStatusSet.Contains('Closed Lost')) {
      offerStatus = 'Closed Lost';
    } 
    if(offerStatusSet.Contains('Closed Expired')) {
      offerStatus = 'Closed Expired';
    } 
    if(offerStatusSet.Contains('Contacted')) {
      offerStatus = 'Contacted';
    }
    if(offerStatusSet.Contains('In Negotiations')) {
      offerStatus = 'In Negotiations';
    }
    if(offerStatusSet.Contains('Contract Sent')) {
      offerStatus = 'Contract Sent';
    }
    if(offerStatusSet.Contains('Closed Won')) {
      offerStatus = 'Closed Won';
    }
    if(offerStatusSet.Contains('Pulled')) {
      offerStatus = 'Pulled';
    }
    if(offerStatusSet.Contains('Live')) {
      offerStatus = 'Live';
    }        
    return offerStatus;
  }
}