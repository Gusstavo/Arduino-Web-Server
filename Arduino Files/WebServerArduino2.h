#include <SPI.h>
#include <Ethernet.h>

#include <Wire.h>
#include "rgb_lcd.h"

rgb_lcd lcd;

const int colorR = 255;
const int colorG = 0;
const int colorB = 0;

int controlName = 1;
int auxControl = 0;

// Enter a MAC address and IP address for your controller below.
// The IP address will be dependent on your local network:
byte mac[] = {
  0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED
};
IPAddress ip(200, 18, 97, 71);

// Initialize the Ethernet server library
// with the IP address and port you want to use
// (port 80 is default for HTTP):
EthernetServer server(80);


void setup() {
    pinMode(LED_BUILTIN, OUTPUT);
    digitalWrite(LED_BUILTIN, LOW);

    /*
      digitalWrite(LED_BUILTIN, HIGH);   // turn the LED on (HIGH is the voltage level)
  delay(1000);                       // wait for a second
  digitalWrite(LED_BUILTIN, LOW);    // turn the LED off by making the voltage LOW
  delay(1000);                       // wait for a second
  */
  // Open serial communications and wait for port to open:
  Serial.begin(9600);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for native USB port only
  }


  // start the Ethernet connection and the server:
  Ethernet.begin(mac, ip);
  server.begin();
  Serial.print("server is at ");
  Serial.println(Ethernet.localIP());

  
  // LCD!!
    // set up the LCD's number of columns and rows:
    lcd.begin(16, 2);
    
    lcd.setRGB(255, 255, 255);
    
    // Print a message to the LCD.
    lcd.print("Entre com um");
    lcd.setCursor(0,1);
    lcd.print(" caractere:");
    
}

void loop() {
  // listen for incoming clients
  EthernetClient client = server.available();
  if (client) {
    Serial.println("new client");

          
///////////////////
    // Variaveis 
    String vars;
    
    // an http request ends with a blank line
    boolean currentLineIsBlank = true;
    while (client.connected()) 
    {
      if (client.available()) {
        char c = client.read();
        Serial.write(c);
        vars.concat(c);

         // Maniuplacao das variaveis na url
        //if (vars.endsWith("/led1_on")) varled1_OnOff = 1;
        //if (vars.endsWith("/led1_off")) varled1_OnOff = 2;

         if (vars.endsWith("/Eduardo_on"))
        {
            auxControl = 1;  
        }
        else         
        if (vars.endsWith("/Gustavo_on"))
        {
           auxControl = 2;  
        }
        else
        if(vars.endsWith("/") || vars.endsWith("/x"))
           auxControl = 0;  


        if (c == '\n' && currentLineIsBlank) {
          // send a standard http response header
          client.println("HTTP/1.1 200 OK");
          client.println("Content-Type: text/html");
          client.println("Connection: close");  // the connection will be closed after completion of the response
          //client.println("Refresh: 5");  // refresh the page automatically every 5 sec
          client.println();
          client.println("<!DOCTYPE HTML>");
          client.println("<html>");


          // Condicoes de acionamento da aula 4 ////////////////////////////
         
            client.println("<input type=button value=Ligar style=height:60px; width:300px ");
            client.println(" onclick=\"document.location='/led1_on'\" />");
            client.println("<input type=button value=Desligar style=height:60px; width:300px ");
            client.println(" onclick=\"document.location='/led1_off'\" />");
            client.println("<br>");

                if(ControlName == 1)
                {
                    client.println("<input type=\"text\" onkeypress=\"document.location='/Eduardo_on'\">");
                }else
                if(ControlName == 2)
                {
                    client.println("<input type=\"text\" onkeypress=\"document.location='/Gustavo_on'\">");
                }

            
            client.println("<br>");

                if (auxControl == 1)             //Eduardo
            	{  
                	lcd.begin(16, 2);
                	lcd.setRGB(55, 200, 24);
    
                	// Print a message to the LCD.
                	lcd.print("Eduardo");
                 
                }else
                if (auxControl == 2)             //Gustavo
               {  
						lcd.begin(16, 2);
						lcd.setRGB(255, 00, 135);
    
                   		// Print a message to the LCD.
                    	lcd.print("Gustavo");

                }else
                
                if (auxControl == 0)             //////////
               {  
                    lcd.begin(16, 2);
                    lcd.setRGB(255, 255, 255);
                    
                    // Print a message to the LCD.
                    lcd.print("Entre com um");
                    lcd.setCursor(0,1);
                    lcd.print(" caractere:");
                    client.println(" onload=\"document.location='/x'\" />");
                }  
                
          // output the value of each analog input pin
          for (int analogChannel = 0; analogChannel < 6; analogChannel++) {
            int sensorReading = analogRead(analogChannel);
            client.print("analog input ");
            client.print(analogChannel);
            client.print(" is ");
            client.print(sensorReading);
            client.println("<br />");
          }
    
          client.println("</html>");
          break;
        }
        if (c == '\n') {
          // you're starting a new line
          currentLineIsBlank = true;
        } else if (c != '\r') {
          // you've gotten a character on the current line
          currentLineIsBlank = false;
        }
      }
    }
    // give the web browser time to receive the data
    delay(1);
    // close the connection:
    client.stop();
    Serial.println("client disconnected");
  }
}
