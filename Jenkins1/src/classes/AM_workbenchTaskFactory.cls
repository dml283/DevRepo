public class AM_workbenchTaskFactory {
  public interface FactoryInterface {
    AM_workbench.MerchantTask build(Task t, String defaultSubject, String defaultWhatId);
  }

  public static AM_workbench.MerchantTask build( Map<String, List<String>> subjectStatuses, Task t, String defaultSubject, String defaultWhatId ){
    AM_workbench.MerchantTask mt = new AM_workbench.MerchantTask();

    if( t != null ){
      mt.id = t.Id;
      mt.subject = t.Subject;
      mt.whatId = t.WhatId;
      mt.status = t.Status;
      mt.description = t.Description;
      mt.openModal = true;

      if( t.id == null ){
        mt.subject = defaultSubject;
        mt.whatId = defaultWhatId;
        mt.status = 'Completed';
        mt.description = '';
      }

      mt.statuses = subjectStatuses.get( t.Subject );
    }

    if( mt.statuses == null ){
      mt.statuses = subjectStatuses.get( defaultSubject );
    }

    return mt;
  }

  public static Map<String, Map<String, AM_workbench.Obj>> subjectStatusCode = new Map<String, Map<String, AM_workbench.Obj>>{
    'Prep: Prep Call' => new Map<String, AM_workbench.Obj>{
      'Not Started' => new AM_workbench.Obj('PREP', 'Prep: Prep Call', ''),
      'In Progress' => new AM_workbench.Obj('PREP', 'Prep: Prep Call', 'bg-caution'),
      'Deferred' => new AM_workbench.Obj('PREP', 'Prep: Prep Call', 'bg-inverse'),
      'Completed' => new AM_workbench.Obj('PREP', 'Prep: Prep Call', 'bg-inverse')
    },
    'Prep: Email' => new Map<String, AM_workbench.Obj>{
      'Not Started' => new AM_workbench.Obj('EMAIL', 'Prep: Email', ''),
      'In Progress' => new AM_workbench.Obj('EMAIL', 'Prep: Email', 'bg-caution'),
      'Completed' => new AM_workbench.Obj('EMAIL', 'Prep: Email', 'bg-inverse')
    },
    'Prep: Merchant Center Walkthrough' => new Map<String, AM_workbench.Obj>{
      'Not Started' => new AM_workbench.Obj('MC', 'Prep: Merchant Center Walkthrough', ''),
      'In Progress' => new AM_workbench.Obj('MC', 'Prep: Merchant Center Walkthrough', 'bg-caution'),
      'Deferred' => new AM_workbench.Obj('MC', 'Prep: Merchant Center Walkthrough', 'bg-inverse'),
      'Completed' => new AM_workbench.Obj('MC', 'Prep: Merchant Center Walkthrough', 'bg-inverse')
    },
    'Prep: Preview Delivered' => new Map<String, AM_workbench.Obj>{
      'Not Started' => new AM_workbench.Obj('PS', 'Prep: Preview Delivered', ''),
      'In Progress' => new AM_workbench.Obj('PS', 'Prep: Preview Delivered', 'bg-caution'),
      'Waiting on someone else' => new AM_workbench.Obj('PS', 'Prep: Preview Delivered', 'bg-caution'),
      'Completed' => new AM_workbench.Obj('PS', 'Prep: Preview Delivered', 'bg-inverse')
    },
    'Maintenance: Day After' => new Map<String, AM_workbench.Obj>{
      'Not Started' => new AM_workbench.Obj('DA', 'Maintenance: Day After', ''),
      'In Progress' => new AM_workbench.Obj('DA', 'Maintenance: Day After', 'bg-caution'),
      'Deferred' => new AM_workbench.Obj('DA', 'Maintenance: Day After', 'bg-inverse'),
      'Completed' => new AM_workbench.Obj('DA', 'Maintenance: Day After', 'bg-inverse')
    },
    'Maintenance: Pre Expiration' => new Map<String, AM_workbench.Obj>{
      'Not Started' => new AM_workbench.Obj('PE', 'Maintenance: Pre Expiration', ''),
      'In Progress' => new AM_workbench.Obj('PE', 'Maintenance: Pre Expiration', 'bg-caution'),
      'Deferred' => new AM_workbench.Obj('PE', 'Maintenance: Pre Expiration', 'bg-inverse'),
      'Completed' => new AM_workbench.Obj('PE', 'Maintenance: Pre Expiration', 'bg-inverse')
    },
    'Maintenance: Merchant Temperature Follow Up' => new Map<String, AM_workbench.Obj>{
      'Not Started' => new AM_workbench.Obj('MT', 'Maintenance: Merchant Temperature Follow Up', ''),
      'In Progress' => new AM_workbench.Obj('MT', 'Maintenance: Merchant Temperature Follow Up', 'bg-caution'),
      'Completed' => new AM_workbench.Obj('MT', 'Maintenance: Merchant Temperature Follow Up', 'bg-inverse')
    },
    'Maintenance: Sign of Life' => new Map<String, AM_workbench.Obj>{
      'Not Started' => new AM_workbench.Obj('SL', 'Maintenance: Sign of Life', ''),
      'In Progress' => new AM_workbench.Obj('SL', 'Maintenance: Sign of Life', 'bg-caution'),
      'Completed' => new AM_workbench.Obj('SL', 'Maintenance: Sign of Life', 'bg-inverse')
    },
    'Prep: Intro Call' => new Map<String, AM_workbench.Obj>{
      'Not Started' => new AM_workbench.Obj('IN', 'Prep: Intro Call', ''),
      'In Progress' => new AM_workbench.Obj('IN', 'Prep: Intro Call', 'bg-caution'),
      'Deferred' => new AM_workbench.Obj('IN', 'Prep: Intro Call', 'bg-inverse'),
      'Completed' => new AM_workbench.Obj('IN', 'Prep: Intro Call', 'bg-inverse')
    },
    'Prep: Getting Ready' => new Map<String, AM_workbench.Obj>{
      'Not Started' => new AM_workbench.Obj('GR', 'Prep: Getting Ready', ''),
      'Completed' => new AM_workbench.Obj('GR', 'Prep: Getting Ready', 'bg-inverse')
    },
    'Prep: Feature Date Confirmed' => new Map<String, AM_workbench.Obj>{
      'Not Started' => new AM_workbench.Obj('FD', 'Prep: Feature Date Confirmed', ''),
      'In Progress' => new AM_workbench.Obj('FD', 'Prep: Feature Date Confirmed', 'bg-caution'),
      'Deferred' => new AM_workbench.Obj('FD', 'Prep: Feature Date Confirmed', 'bg-danger'),
      'Completed' => new AM_workbench.Obj('FD', 'Prep: Feature Date Confirmed', 'bg-inverse')
    },
    'Prep: MC Walkthrough' => new Map<String, AM_workbench.Obj>{
      'Not Started' => new AM_workbench.Obj('MC', 'Prep: MC Walkthrough', ''),
      'In Progress' => new AM_workbench.Obj('MC', 'Prep: MC Walkthrough', 'bg-caution'),
      'Deferred' => new AM_workbench.Obj('MC', 'Prep: MC Walkthrough', 'bg-inverse'),
      'Completed' => new AM_workbench.Obj('MC', 'Prep: MC Walkthrough', 'bg-inverse')
    },
    'Prep: Preview Approved' => new Map<String, AM_workbench.Obj>{
      'Not Started' => new AM_workbench.Obj('PA', 'Prep: Preview Approved', ''),
      'In Progress' => new AM_workbench.Obj('PA', 'Prep: Preview Approved', 'bg-caution'),
      'Waiting on someone else' => new AM_workbench.Obj('PA', 'Prep: Preview Approved', 'bg-caution'),
      'Completed' => new AM_workbench.Obj('PA', 'Prep: Preview Approved', 'bg-inverse')
    }
  };

  public class Us implements FactoryInterface {
    private Map<String, List<String>> subjectStatuses = new Map<String, List<String>>{
      'Prep: Intro Call' => new List<String>{'Not Started', 'In Progress', 'Deferred', 'Completed'},
      'Prep: Getting Ready' => new List<String>{'Not Started', 'Completed'},
      'Prep: MC Walkthrough' => new List<String>{'Not Started', 'In Progress', 'Deferred', 'Completed'},
      'Prep: Feature Date Confirmed' => new List<String>{'Not Started', 'In Progress', 'Deferred', 'Completed'},
      'Prep: Preview Delivered' => new List<String>{'Not Started', 'Waiting on someone else', 'Completed'},
      'Prep: Preview Approved' => new List<String>{'Not Started', 'In Progress', 'Waiting on someone else', 'Completed'},
      'Maintenance: Day After' => new List<String>{'Not Started', 'In Progress', 'Deferred', 'Completed'},
      'Maintenance: Pre Expiration' => new List<String>{'Not Started', 'In Progress', 'Deferred', 'Completed'},
      'Maintenance: Merchant Temperature Follow Up' => new List<String>{'Not Started', 'In Progress', 'Completed'},
      'Maintenance: Sign of Life' => new List<String>{'Not Started', 'In Progress', 'Completed'}
    };

    public AM_workbench.MerchantTask build(Task t, String defaultSubject, String defaultWhatId){
      return AM_workbenchTaskFactory.build( subjectStatuses, t, defaultSubject, defaultWhatId );
    }
  }

  public class International implements FactoryInterface {
    private Map<String, List<String>> subjectStatuses = new Map<String, List<String>>{
      'Prep: Prep Call' => new List<String>{'Not Started', 'Deferred', 'In Progress', 'Completed'},
      'Prep: Email' => new List<String>{'Not Started', 'In Progress', 'Completed'},
      'Prep: Merchant Center Walkthrough' => new List<String>{'Not Started', 'Deferred', 'In Progress', 'Completed'},
      'Prep: Preview Delivered' => new List<String>{'Not Started', 'In Progress', 'Waiting on someone else', 'Completed'},
      'Prep: Preview Approved' => new List<String>{'Not Started', 'In Progress', 'Completed'},
      'Maintenance: Day After' => new List<String>{'Not Started', 'Deferred', 'In Progress', 'Completed'},
      'Maintenance: Pre Expiration' => new List<String>{'Not Started', 'Deferred', 'In Progress', 'Completed'}
    };

    public AM_workbench.MerchantTask build(Task t, String defaultSubject, String defaultWhatId){
      return AM_workbenchTaskFactory.build( subjectStatuses, t, defaultSubject, defaultWhatId );
    }
  }
}