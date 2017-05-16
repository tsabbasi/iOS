package com.abbasiindustriesLLC.engineeringmemes;

import android.app.Activity;
import android.graphics.Color;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import java.util.Random;


public class EngineeringMemesActivity extends Activity {

    public static final String TAG = EngineeringMemesActivity.class.getSimpleName();

    private MemeBook mMemeBook = new MemeBook();
    private ColorWheel mColorWheel = new ColorWheel();

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        // onCreate gets called when our app starts up
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_engineering_memes);

        // Declare our View variables and assign the Views from the layout file
        final TextView memeLabel = (TextView) findViewById(R.id.memeTextView); // Typecasting the return type from a general view to a TextView
        final Button showMemeButton = (Button) findViewById(R.id.showMemeButton);
        final RelativeLayout relativeLayout = (RelativeLayout) findViewById(R.id.relativeLayout);
        final View.OnClickListener listener = new View.OnClickListener(){

            @Override
            public void onClick(View view) {
                String meme = mMemeBook.getMeme();
                // Update the label with our dynamic meme
                memeLabel.setText(meme);

                int color = mColorWheel.getColor();
                relativeLayout.setBackgroundColor(color);
                showMemeButton.setTextColor(color);
            }
        };
        showMemeButton.setOnClickListener(listener);

        //Toast.makeText(this, "Yay! Our Activity was created!", Toast.LENGTH_LONG).show();
        Log.d(TAG , "We're logging from the onCreate method!");
    }
}
