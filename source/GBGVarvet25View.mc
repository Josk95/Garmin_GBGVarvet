import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Toybox.Time;
using Toybox.Math;

class GBGVarvet25View extends WatchUi.WatchFace {
    var targetDate;
    var inspirationalMessages;
    var currentMessageIndex;
    var lastUpdateTime;


    function initialize() {
        WatchFace.initialize();
        // Set target date: May 17, 2025
        targetDate = Time.Gregorian.moment({
            :year => 2025,
            :month => 5,
            :day => 17,
            :hour => 0,
            :minute => 0,
            :second => 0
        });
        
        // Initialize inspirational messages
        inspirationalMessages = [
            "You've Got This!",
            "Time to Shine!",
            "Make History Today!",
            "Trust Your Training!",
            "Strong & Ready!",
            "Feel the Energy!",
            "Embrace the Challenge!",
            "Your Day to Conquer!",
            "Run with Heart!"
        ];
        
        currentMessageIndex = 0;
        lastUpdateTime = System.getTimer();
    }

    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    function onShow() as Void {
    }

    function onUpdate(dc) {

        requestUpdate();
        // Clear the screen
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();


        // Get screen dimensions
        var width = dc.getWidth();
        var height = dc.getHeight();

            // Choose the correct background image based on resolution
        var background;
        
        if (width <= 240) {
            background = Application.loadResource(Rez.Drawables.Background_240);
        } else if (width <= 260) {
            background = Application.loadResource(Rez.Drawables.Background_260);
        } else if (width <= 280) {
            background = Application.loadResource(Rez.Drawables.Background_280);
        } else if (width <= 320) {
            background = Application.loadResource(Rez.Drawables.Background_320);
        } else {
            background = Application.loadResource(Rez.Drawables.Background_454);
        }


        // Draw your background image
        dc.drawBitmap(0, 0, background);

      var utcMoment = Time.now(); // Get current time as a Moment
var utcInfo = Time.Gregorian.info(utcMoment, Time.FORMAT_SHORT); // Extract UTC time components

// Define offset (3600s for UTC+1, 7200s for UTC+2)
var stockholmOffsetHours = 1; // Default: Winter time (UTC+1)
if (isDST()) {
    stockholmOffsetHours = 2; // Summer time (UTC+2)
}

// Adjust the hour manually
var localHour = utcInfo.hour + stockholmOffsetHours;

// Handle day overflow (if hour goes above 23, move to next day)
var localDay = utcInfo.day;
var localMonth = utcInfo.month;
var localYear = utcInfo.year;

if (localHour >= 24) {
    localHour -= 24;
    localDay += 1;
}

    // Handle month overflow (e.g., going from June 30 → July 1)
    var daysInCurrentMonth = getDaysInMonth(localYear, localMonth);
    if (localDay > daysInCurrentMonth) {
        localDay = 1;
        localMonth += 1;

        // Handle year overflow (December → January)
      if (localHour >= 24) {
            localHour -= 24;
            localDay += 1;
        }
    }

        var currentTimeStockholm = Time.Gregorian.moment({
            :year   => localYear,
            :month  => localMonth,
            :day    => localDay,
            :hour   => localHour,
            :minute => utcInfo.min,
            :second => utcInfo.sec
        });

         var targetInfo = Time.Gregorian.info(targetDate, Time.FORMAT_SHORT); 

        var targetLocal = Time.Gregorian.moment({
            :year   => targetInfo.year,  
            :month  => targetInfo.month,
            :day    => targetInfo.day,
            :hour   => targetInfo.hour,  
            :minute => targetInfo.min,
            :second => targetInfo.sec
        });


      
        var duration = targetLocal.subtract(currentTimeStockholm);
        var timeRemaining = duration.value();

        var currentInfo = Time.Gregorian.info(currentTimeStockholm, Time.FORMAT_SHORT);

        var isRaceDay = (currentInfo.year * 10000 + currentInfo.month * 100 + currentInfo.day) >= 
                (targetInfo.year * 10000 + targetInfo.month * 100 + targetInfo.day);

        if (isRaceDay) {
            // It's race day! Display rotating inspirational messages
            var currentTimer = System.getTimer();
            
            // Change message every 3 seconds
            if (currentTimer - lastUpdateTime > 3000) {
                currentMessageIndex = (currentMessageIndex + 1) % inspirationalMessages.size();
                lastUpdateTime = currentTimer;
            }

            // Draw "RACE DAY!" text
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(
                dc.getWidth() / 2,
                dc.getHeight() * 0.18,
                Graphics.FONT_SMALL,
                "RACE!",
                Graphics.TEXT_JUSTIFY_CENTER
            );

            // Draw inspirational message
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(
                dc.getWidth() / 2,
                dc.getHeight() * 0.4,
                Graphics.FONT_SMALL,
                inspirationalMessages[currentMessageIndex],
                Graphics.TEXT_JUSTIFY_CENTER
            );
        } else {
            // Calculate time remaining using integer math
            var secondsInDay = 24 * 60 * 60;
            var secondsInHour = 60 * 60;
            var secondsInMinute = 60;

            var totalSeconds = timeRemaining;
            var days = (totalSeconds / secondsInDay).toNumber();
            totalSeconds = totalSeconds % secondsInDay;
            
            var hours = (totalSeconds / secondsInHour).toNumber();
            totalSeconds = totalSeconds % secondsInHour;
            
            var minutes = (totalSeconds / secondsInMinute).toNumber();
            var seconds = (totalSeconds % secondsInMinute).toNumber();

         
                  // Draw days at the top
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(
                dc.getWidth() / 2,
                dc.getHeight() * 0.08,
                Graphics.FONT_MEDIUM,
                days.format("%d"),
                Graphics.TEXT_JUSTIFY_CENTER
            );
            
            // Draw "DAYS" label
            //dc.setColor(Graphics.createColor(255, 255, 4, 148), Graphics.COLOR_TRANSPARENT); 
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(
                dc.getWidth() / 2,
                dc.getHeight() * 0.20,
                Graphics.FONT_SMALL,
                "DAYS",
                Graphics.TEXT_JUSTIFY_CENTER
            );

    
            var timeString = Lang.format(" $1$  $2$  $3$ ", [
                hours.format("%02d"),
                minutes.format("%02d"),
                seconds.format("%02d")
            ]);

            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            
            dc.drawText(
                dc.getWidth() / 2,
                dc.getHeight() * 0.4,
                Graphics.FONT_SMALL,
                timeString,
                Graphics.TEXT_JUSTIFY_CENTER
            );

            // Draw labels for hours, minutes, seconds
            var labelsString = " hrs min sec";
            dc.drawText(
                dc.getWidth() / 2,
                dc.getHeight() * 0.5,
                Graphics.FONT_TINY,
                labelsString,
                Graphics.TEXT_JUSTIFY_CENTER
            );
            
        

     
        }

        // Draw current time at the bottom
        var clockTime = System.getClockTime();
        var timeString = Lang.format("$1$:$2$", [
            clockTime.hour.format("%02d"),
            clockTime.min.format("%02d")
        ]);
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            dc.getWidth() / 2,
            dc.getHeight() * 0.85,
            Graphics.FONT_SMALL,
            timeString,
            Graphics.TEXT_JUSTIFY_CENTER
        );
    }

    function onHide() as Void {
    }

    function onExitSleep() as Void {
    }

    function onEnterSleep() as Void {
    }

function isDST() {
    var now = Time.Gregorian.info(Time.now(), Time.FORMAT_SHORT);

    // DST is always active between April and September
    if (now.month > 3 && now.month < 10) {
        return true;
    }

    // Check for last Sunday of March (DST starts)
    if (now.month == 3) {
        var lastSunday = getLastSunday(now.year, 3);
        return now.day >= lastSunday;
    }

    // Check for last Sunday of October (DST ends)
    if (now.month == 10) {
        var lastSunday = getLastSunday(now.year, 10);
        return now.day < lastSunday;
    }

        return false;
    }

    function getLastSunday(year, month) {
        var lastDay = getDaysInMonth(year, month);

        for (var day = lastDay; day > lastDay - 7; day--) {
            var moment = Time.Gregorian.moment({:year => year, :month => month, :day => day});
            var info = Time.Gregorian.info(moment, Time.FORMAT_SHORT);

            if (info.day_of_week == 0) { // Sunday (0 = Sunday in CIQ)
                return day;
            }
        }

        return lastDay; // Fallback (should never happen)
    }

    function getDaysInMonth(year, month) {
    var days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

    // Check for leap year (only affects February)
    if (month == 2 && isLeapYear(year)) {
        return 29;
    }

    return days[month - 1]; // Convert 1-based month to 0-based index
}

function isLeapYear(year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
}



}