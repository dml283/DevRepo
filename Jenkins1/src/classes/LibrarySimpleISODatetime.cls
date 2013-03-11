//
// This class is versioned: git clone github:sales-and-planning-tools/mocha-apex-endpoints
//

//
// Supports dates in this format: "2012-08-31T11:10:55-05:00"
//

global class LibrarySimpleISODatetime {
    Datetime datetimeValue;

    public LibrarySimpleISODatetime(Datetime datetimeValue) {
        this.datetimeValue = datetimeValue;
    }

    public String formatISO8601() {
        return datetimeValue.format('yyyy-MM-dd\'T\'HH:mm:ssZ');
    }

    public String formatISO8601Gmt() {
        return datetimeValue.formatGmt('yyyy-MM-dd\'T\'HH:mm:ssZ');
    }

    public static Datetime parseISO8601(String dateTimeString) {
        String dateString = dateTimeString.substring(0, 10);
        Date dateValue = Date.valueOf(dateString);

        Integer hour = Integer.valueOf(dateTimeString.substring(11, 13));
        Integer minute = Integer.valueOf(dateTimeString.substring(14, 16));
        Integer second = Integer.valueOf(dateTimeString.substring(17, 19));

        String zone = datetimeString.substring(19).replace(':', '');
        if (zone != '' && zone != 'Z') {
            String sign = zone.substring(0,1);
            Integer hourOffset = Integer.valueOf(zone.substring(1,3));
            Integer minuteOffset = Integer.valueOf(zone.substring(3));

            if (sign == '-') {
                minute += minuteOffset;
                hour += hourOffset;
            } else {
                minute -= minuteOffset;
                hour -= hourOffset;
            }

            if (minute > 59) {
                minute -= 60;
                hour++;
            } else if (minute < 0) {
                minute += 60;
                hour--;
            }

            if (hour > 23) {
                hour -= 24;
                dateValue = dateValue.addDays(1);
            } else if (hour < 0) {
                hour += 24;
                dateValue = dateValue.addDays(-1);
            }
        }

        Time timeValue = Time.newInstance(hour, minute, second, 0);
        return Datetime.newInstanceGmt(dateValue, timeValue);
    }
}