import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Toybox.Time;
using Toybox.Math;

class GBGVarvet25View extends WatchUi.WatchFace {
    private var targetDate;
    private var inspirationalMessages;
    private var currentMessageIndex;
    private var lastUpdateTime;
    private var background;
    private var width;
    private var height;
    
    // Cache font references
    private const FONT_SMALL = Graphics.FONT_SMALL;
    private const FONT_MEDIUM = Graphics.FONT_MEDIUM;
    private const FONT_TINY = Graphics.FONT_TINY;
    
    // Cache common calculations
    private const SECONDS_IN_DAY = 24 * 60 * 60;
    private const SECONDS_IN_HOUR = 60 * 60;
    private const SECONDS_IN_MINUTE = 60;

    function initialize() {
        WatchFace.initialize();
        
        // Set target date: Example - May 17, 2025 at 10:00 Stockholm time
        targetDate = Time.Gregorian.moment({
            :year => 2025,
            :month => 5,  // Month 5 for May
            :day => 16,
            :hour => 22,   // 10:00 Stockholm (UTC+2) = 08:00 UTC
            :minute => 0,
            :second => 0
        });
        
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

    function onShow() as Void {
    }

    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
        width = dc.getWidth();
        height = dc.getHeight();
        background = loadAppropriateBackground(width);
    }

    private function loadAppropriateBackground(width) {
        if (width <= 240) {
            return WatchUi.loadResource(Rez.Drawables.Background_240);
        } else if (width <= 260) {
            return WatchUi.loadResource(Rez.Drawables.Background_260);
        } else if (width <= 280) {
            return WatchUi.loadResource(Rez.Drawables.Background_280);
        } else if (width <= 320) {
            return WatchUi.loadResource(Rez.Drawables.Background_320);
        }
        return WatchUi.loadResource(Rez.Drawables.Background_454);
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        dc.drawBitmap(0, 0, background);

        var currentTime = Time.now();
        var isRaceDay = checkIfRaceDay(currentTime);

        if (isRaceDay) {
            drawRaceDayDisplay(dc);
        } else {
            drawCountdownDisplay(dc, currentTime);
        }

        drawCurrentTime(dc);
    }

    private function checkIfRaceDay(currentTime) {
        return currentTime.compare(targetDate) >= 0;
    }

    private function drawRaceDayDisplay(dc) {
        var currentTimer = System.getTimer();
        
        if (currentTimer - lastUpdateTime > 3000) {
            currentMessageIndex = (currentMessageIndex + 1) % inspirationalMessages.size();
            lastUpdateTime = currentTimer;
        }

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        
        dc.drawText(
            width / 2,
            height * 0.18,
            FONT_SMALL,
            "RACE!",
            Graphics.TEXT_JUSTIFY_CENTER
        );

        dc.drawText(
            width / 2,
            height * 0.4,
            FONT_SMALL,
            inspirationalMessages[currentMessageIndex],
            Graphics.TEXT_JUSTIFY_CENTER
        );
    }

    private function getTimeRemaining(currentTime) {
        var duration = targetDate.subtract(currentTime);
        return duration.value();
    }

    private function drawCountdownDisplay(dc, currentTime) {
        // Get time remaining in seconds
        var timeRemaining = getTimeRemaining(currentTime);
        
        // Calculate components
        var days = (timeRemaining / SECONDS_IN_DAY).toNumber();
        var remainingSeconds = timeRemaining % SECONDS_IN_DAY;
        var hours = (remainingSeconds / SECONDS_IN_HOUR).toNumber();
        remainingSeconds = remainingSeconds % SECONDS_IN_HOUR;
        var minutes = (remainingSeconds / SECONDS_IN_MINUTE).toNumber();
        var seconds = (remainingSeconds % SECONDS_IN_MINUTE).toNumber();

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        
        // Draw days
        dc.drawText(
            width / 2,
            height * 0.08,
            FONT_MEDIUM,
            days.format("%d"),
            Graphics.TEXT_JUSTIFY_CENTER
        );
        
        dc.drawText(
            width / 2,
            height * 0.20,
            FONT_SMALL,
            "DAYS",
            Graphics.TEXT_JUSTIFY_CENTER
        );

        // Draw time components
        var timeString = Lang.format(" $1$  $2$  $3$ ", [
            hours.format("%02d"),
            minutes.format("%02d"),
            seconds.format("%02d")
        ]);

        dc.drawText(
            width / 2,
            height * 0.4,
            FONT_SMALL,
            timeString,
            Graphics.TEXT_JUSTIFY_CENTER
        );

        dc.drawText(
            width / 2,
            height * 0.5,
            FONT_TINY,
            " hrs min sec",
            Graphics.TEXT_JUSTIFY_CENTER
        );
    }

    private function drawCurrentTime(dc) {
        var clockTime = System.getClockTime();
        var timeString = Lang.format("$1$:$2$", [
            clockTime.hour.format("%02d"),
            clockTime.min.format("%02d")
        ]);
        
        dc.drawText(
            width / 2,
            height * 0.85,
            FONT_SMALL,
            timeString,
            Graphics.TEXT_JUSTIFY_CENTER
        );
    }

    function onExitSleep() as Void {
    }

    function onEnterSleep() as Void {
    }
}