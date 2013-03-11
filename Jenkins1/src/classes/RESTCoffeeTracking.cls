@RestResource(urlMapping = '/v1.0/coffee_tracking/*')
global without sharing class RESTCoffeeTracking {
    @HttpGET
    global static TrackingInfo getTrackingInfo() {
        RestRequest request = RestContext.request;
        Id id = request.requestURI.substring(request.requestURI.lastIndexOf('/') + 1);

        return new TrackingInfo(id);
    }

    @HttpPOST
    global static TrackingInfo setTrackingInfo(
            String merchantLastOpenedRoiAt,
            String repLastOpenedRoiBy,
            String repLastOpenedRoiAt,
            String repLastOpenedCoffeeBy,
            String repLastOpenedCoffeeAt)
    {
        return updateTrackingInfo(merchantLastOpenedRoiAt, repLastOpenedRoiBy, repLastOpenedRoiAt, repLastOpenedCoffeeBy, repLastOpenedCoffeeAt);
    }

    @HttpPUT
    global static TrackingInfo updateTrackingInfo(
            String merchantLastOpenedRoiAt,
            String repLastOpenedRoiBy,
            String repLastOpenedRoiAt,
            String repLastOpenedCoffeeBy,
            String repLastOpenedCoffeeAt)
    {
        RestRequest request = RestContext.request;
        Id id = request.requestURI.substring(request.requestURI.lastIndexOf('/') + 1);
        TrackingInfo trackingInfo = new TrackingInfo(id);

        if (merchantLastOpenedRoiAt != null) {
            trackingInfo.merchantLastOpenedRoiAt = merchantLastOpenedRoiAt;
        }

        if (repLastOpenedCoffeeAt != null) {
            trackingInfo.repLastOpenedCoffeeAt = repLastOpenedCoffeeAt;
        }

        if (repLastOpenedCoffeeBy != null) {
            trackingInfo.repLastOpenedCoffeeBy = repLastOpenedCoffeeBy;
        }

        if (repLastOpenedRoiAt != null) {
            trackingInfo.repLastOpenedRoiAt = repLastOpenedRoiAt;
        }

        if (repLastOpenedRoiBy != null) {
            trackingInfo.repLastOpenedRoiBy = repLastOpenedRoiBy;
        }

        trackingInfo.updateLeadOrAccount();

        return trackingInfo;
    }

    global class TrackingInfo {
        private transient Lead lead;
        private transient Account account;

        public TrackingInfo(Id id) {
            this.account = null;
            this.lead = null;

            Account[] accounts = [
                SELECT
                    Id,
                    Coffee_Pressed_At__c,
                    Coffee_Pressed_by__c,
                    ROI_Viewed_At__c,
                    ROI_Viewed_By__c,
                    ROI_Viewed_By_Merchant_At__c
                FROM Account
                WHERE id = :id
            ];

            Lead[] leads = [
                SELECT
                    Id,
                    Coffee_Pressed_At__c,
                    Coffee_Pressed_by__c,
                    ROI_Viewed_At__c,
                    ROI_Viewed_By__c,
                    ROI_Viewed_By_Merchant_At__c
                FROM Lead
                WHERE id = :id
            ];

            if (leads.size() > 0) {
                this.lead = leads[0];
            } else if (accounts.size() > 0) {
                this.account = accounts[0];
            }
        }

        public String merchantLastOpenedRoiAt {
            get {
                if (this.lead != null) {
                    if (this.lead.ROI_Viewed_By_Merchant_At__c != null) {
                        return new LibrarySimpleISODatetime(this.lead.ROI_Viewed_By_Merchant_At__c).formatISO8601Gmt();
                    } else {
                        return null;
                    }
                } else if (this.account != null) {
                    if (this.account.ROI_Viewed_By_Merchant_At__c != null) {
                        return new LibrarySimpleISODatetime(this.account.ROI_Viewed_By_Merchant_At__c).formatISO8601Gmt();
                    } else {
                        return null;
                    }
                } else {
                    return null;
                }
            }

            set {
                if (this.lead != null) {
                    this.lead.ROI_Viewed_By_Merchant_At__c = LibrarySimpleISODatetime.parseISO8601(value);
                } else if (this.account != null) {
                    this.account.ROI_Viewed_By_Merchant_At__c = LibrarySimpleISODatetime.parseISO8601(value);
                }
            }
        }

        public String repLastOpenedRoiBy {
            get {
                if (this.lead != null) {
                    return this.lead.ROI_Viewed_By__c;
                } else if (this.account != null) {
                    return this.account.ROI_Viewed_By__c;
                } else {
                    return null;
                }
            }

            set {
                if (this.lead != null) {
                    this.lead.ROI_Viewed_By__c = value;
                } else if (this.account != null) {
                    this.account.ROI_Viewed_By__c = value;
                }
            }
        }

        public String repLastOpenedRoiAt {
            get {
                if (this.lead != null) {
                    if (this.lead.ROI_Viewed_At__c != null) {
                        return new LibrarySimpleISODatetime(this.lead.ROI_Viewed_At__c).formatISO8601Gmt();
                    } else {
                        return null;
                    }
                } else if (this.account != null) {
                    if (this.account.ROI_Viewed_At__c != null) {
                        return new LibrarySimpleISODatetime(this.account.ROI_Viewed_At__c).formatISO8601Gmt();
                    } else {
                        return null;
                    }
                } else {
                    return null;
                }
            }

            set {
                if (this.lead != null) {
                    this.lead.ROI_Viewed_At__c = LibrarySimpleISODatetime.parseISO8601(value);
                } else if (this.account != null) {
                    this.account.ROI_Viewed_At__c = LibrarySimpleISODatetime.parseISO8601(value);
                }
            }
        }

        public String repLastOpenedCoffeeBy {
            get {
                if (this.lead != null) {
                    return this.lead.Coffee_Pressed_by__c;
                } else if (this.account != null) {
                    return this.account.Coffee_Pressed_by__c;
                } else {
                    return null;
                }
            }

            set {
                if (this.lead != null) {
                    this.lead.Coffee_Pressed_by__c = value;
                } else if (this.account != null) {
                    this.account.Coffee_Pressed_by__c = value;
                }
            }
        }

        public String repLastOpenedCoffeeAt {
            get {
                if (this.lead != null) {
                    if (this.lead.Coffee_Pressed_At__c != null) {
                        return new LibrarySimpleISODatetime(this.lead.Coffee_Pressed_At__c).formatISO8601Gmt();
                    } else {
                        return null;
                    }
                } else if (this.account != null) {
                    if (this.account.Coffee_Pressed_At__c != null) {
                        return new LibrarySimpleISODatetime(this.account.Coffee_Pressed_At__c).formatISO8601Gmt();
                    } else {
                        return null;
                    }
                } else {
                    return null;
                }
            }

            set {
                if (this.lead != null) {
                    this.lead.Coffee_Pressed_At__c = LibrarySimpleISODatetime.parseISO8601(value);
                } else if (this.account != null) {
                    this.account.Coffee_Pressed_At__c = LibrarySimpleISODatetime.parseISO8601(value);
                }
            }
        }

        public void updateLeadOrAccount() {
            if (this.lead != null) {
                Database.update(lead);
            } else if (this.account != null) {
                Database.update(account);
            }
        }
    }
}