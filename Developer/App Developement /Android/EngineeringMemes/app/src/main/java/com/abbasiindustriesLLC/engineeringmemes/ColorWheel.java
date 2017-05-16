package com.abbasiindustriesLLC.engineeringmemes;

import android.graphics.Color;

import java.util.Random;

/**
 * Created by Tuba on 5/16/2015.
 */
public class ColorWheel {

    // Member variable (properties about the object)
    public String[] mColors = {
            "#39add1", // light blue
            "#3079ab", // dark blue
            "#c25975", // mauve
            "#e15258", // red
            "#f9845b", // orange
            "#838cc7", // lavender
            "#7d669e", // purple
            "#53bbb4", // aqua
            "#51b46d", // green
            "#e0ab18", // mustard
            "#637a91", // dark gray
            "#f092b0", // pink
            "#b7c0c7"  // light gray
    };

    // Method (abilities: things the object can do)
    public int getColor(){


        String color = "";

        // Randomly select a meme
        Random randomGenerator = new Random();
        int randomNumber = randomGenerator.nextInt(mColors.length);

        color = mColors[randomNumber];
        int colorAsInt = Color.parseColor(color); // converting String color into a hexadecimal representation

        return colorAsInt;
    }
}
