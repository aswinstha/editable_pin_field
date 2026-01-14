package com.example.demo;

import androidx.test.ext.junit.rules.ActivityScenarioRule;
import androidx.test.ext.junit.runners.AndroidJUnit4;
import androidx.test.filters.LargeTest;

import org.junit.Rule;
import org.junit.Test;
import org.junit.runner.RunWith;

import static androidx.test.espresso.Espresso.onView;
import static androidx.test.espresso.action.ViewActions.click;
import static androidx.test.espresso.assertion.ViewAssertions.matches;
import static androidx.test.espresso.matcher.ViewMatchers.isDisplayed;
import static androidx.test.espresso.matcher.ViewMatchers.withText;

/**
 * Instrumentation test for Firebase Test Lab.
 * Tests the basic functionality of the editable PIN field demo app.
 */
@RunWith(AndroidJUnit4.class)
@LargeTest
public class MainActivityTest {

    @Rule
    public ActivityScenarioRule<MainActivity> activityRule =
            new ActivityScenarioRule<>(MainActivity.class);

    /**
     * Test that the app launches successfully and displays the main button.
     */
    @Test
    public void testAppLaunches() {
        // Wait for Flutter to initialize
        try {
            Thread.sleep(2000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        // Verify the app is displayed
        onView(withText("My Pin Code Editor")).check(matches(isDisplayed()));
    }

    /**
     * Test navigation to PIN code editor screen.
     */
    @Test
    public void testNavigateToPinEditor() {
        // Wait for Flutter to initialize
        try {
            Thread.sleep(2000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        // Click the button to open PIN editor
        onView(withText("My Pin Code Editor")).perform(click());

        // Wait for navigation
        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        // Verify PIN editor screen is displayed
        onView(withText("Dummy Editor")).check(matches(isDisplayed()));
    }
}
