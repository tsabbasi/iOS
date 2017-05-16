package com.abbasiindustriesLLC.engineeringmemes;

import android.widget.Toast;

import java.util.ArrayList;
import java.util.Random;

/**
 * Created by Tuba on 5/16/2015.
 */
public class MemeBook {
    private String mPrevMeme = "";
    private int mRandomNumber;
    private ArrayList<Integer> randomNumberList = new ArrayList<Integer>();

    // Member variable (properties about the object)
    public String[] mMemes = {
            "COFFEE.\nIf you're not shaking, you need another cup.",
            "I wish I was your derivative, so I could lie tangent to your curves ;)",
            "classwork: A\nhomework: A\nclasswork: A\nhomework: A\nclasswork: A\nhomework: A\n\ntest: F\nfinal grade: F",
            "Light travels faster than sound...that is why some people appear bright until you hear them speak.",
            "If Apple made a car, would it still have Windows?",
            "Don't give up on your dreams.\nKEEP SLEEPING :)",
            "Engineering is about making approximations...except for your grades.",
            "My area of study has become so complex\nI can no longer just Wikipedia the answer :/",
            "I need coffee to wake up...but I need to wake up to get coffee :(",
            "Unpaid internship?\nAIN'T NOBODY GOT TIME FOR THAT."};



    // Method (abilities: things the object can do)
    public String getMeme(){


        String meme = "";

        if (randomNumberList.size() == mMemes.length){
            randomNumberList.clear();
            //Toast.makeText(this, "Yay! Our Activity was created!", Toast.LENGTH_LONG).show();
        }



        // Randomly select a meme
        Random randomGenerator = new Random();
        if (randomNumberList.contains(mRandomNumber)){
            mRandomNumber = randomGenerator.nextInt(mMemes.length);

        }
        //randomNumberList.add(randomGenerator.nextInt(mMemes.length));
        randomNumberList.add(mRandomNumber);
        meme = mMemes[mRandomNumber];

        return meme;
    }
}
