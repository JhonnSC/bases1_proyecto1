package com.example.finderapiapp;

import androidx.appcompat.app.AppCompatActivity;

import android.annotation.SuppressLint;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.DataOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

public class MainActivity extends AppCompatActivity {
    Button boton_ejecutar;
    EditText textoSP, textoArgumentos;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        // asignar valores a los inputs
        boton_ejecutar = findViewById(R.id.boton_ejecutar);
        textoArgumentos = findViewById(R.id.textoArgumentos);
        textoSP = findViewById(R.id.textoSP);

        // listeners
        Log.d("notificaicon", "saTANAS");

        boton_ejecutar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                Log.d("notificaicon", "saTANAS"+ textoArgumentos.getText().toString()+"/"+textoSP.getText().toString());

                String input = new String();
                input.concat(textoSP.getText().toString());
                input.concat(",");
                input.concat(textoArgumentos.getText().toString());
                JSONObject postData = new JSONObject();
                try {

                    postData.put("nombreSP",textoSP.getText().toString() );
                    postData.put("argumentos", textoArgumentos.getText().toString());
                    postData.get("nombreSP");
                    Log.d("notificaicon", "saTANAS    " + postData.get("nombreSP"));
                    //postData.put("nombreSP", textoSP.getText().toString());
                    //postData.put("argumentos", textoArgumentos.getText().toString());
    //https://localhost:5000/usar_sp?
                    Log.d("notificaicon", "saTANAS    " + postData);
                    new SendDeviceDetails().execute("http://172.30.144.1:5000/storedprocedures", postData.toString());
                } catch (JSONException e) {
                    e.printStackTrace();
                }

            }
            @SuppressLint("StaticFieldLeak")
            class SendDeviceDetails extends AsyncTask<String, Void, String> {

                @Override
                protected String doInBackground(String... params) {

                    String data = "";

                    HttpURLConnection httpURLConnection = null;
                    try {

                        httpURLConnection = (HttpURLConnection) new URL(params[0]).openConnection();
                        httpURLConnection.setRequestMethod("POST");

                        httpURLConnection.setDoOutput(true);

                        DataOutputStream wr = new DataOutputStream(httpURLConnection.getOutputStream());
                        wr.writeBytes("PostData=" + params[1]);
                        wr.flush();
                        wr.close();

                        InputStream in = httpURLConnection.getInputStream();
                        InputStreamReader inputStreamReader = new InputStreamReader(in);

                        int inputStreamData = inputStreamReader.read();
                        while (inputStreamData != -1) {
                            char current = (char) inputStreamData;
                            inputStreamData = inputStreamReader.read();
                            data += current;
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    } finally {
                        if (httpURLConnection != null) {
                            httpURLConnection.disconnect();
                        }
                    }

                    return data;
                }

                @Override
                protected void onPostExecute(String result) {
                    super.onPostExecute(result);
                    Log.e("TAG", result); // this is expecting a response code to be sent from your server upon receiving the POST data
                }
            }






        });

    }





}

