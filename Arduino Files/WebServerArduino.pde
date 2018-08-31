#include <SPI.h>
#include <Ethernet.h>

#include <Wire.h>
#include "rgb_lcd.h"

rgb_lcd lcd;

const int colorR = 255;
const int colorG = 0;
const int colorB = 0;

int auxNameChange = 0;
int varName = -1;
int pressed = 0;

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


        if (c == '\n' && currentLineIsBlank) {
		// send a standard http response header
		client.println("HTTP/1.1 200 OK");
		client.println("Content-Type: text/html");
		client.println("Connection: close");  // the connection will be closed after completion of the response
		//client.println("Refresh: 5");  // refresh the page automatically every 5 sec
		client.println();
		client.println("<!DOCTYPE HTML>");
		client.println("<html>");


		//Condicoes de acionamento via button
         
            	client.println("<input type=button value=Ligar style=height:60px; width:300px ");
            	client.println(" onclick=\"document.location='/led1_on'\" />");
            	client.println("<input type=button value=Desligar style=height:60px; width:300px ");
           	client.println(" onclick=\"document.location='/led1_off'\" />");
           	client.println("<br>");
			
		//Alterar o endString para alterar a exibição do nome
            	client.println("<input type=\"text\" onkeypress=\"document.location='/name_change'\">");            
            	client.println("<br>");
			
		delay(10);
			
		//Verifica EndString da URL
		if (vars.endsWith("/name_change"))
		{
			pressed = 1;
			if(auxNameChange == 0)  
				varName = 0;	//Eduardo
			else
				varName = 1;	//Gustavo
		}
		else if(vars.endsWith("/"))
			varName = -1;  
						
			
            	if (varName == 0)             //Eduardo
            	{  
                	lcd.begin(16, 2);
                	lcd.setRGB(55, 200, 24);
    
                	// Print a message to the LCD.
                	lcd.print("Eduardo");
                	//auxNameChange = 1;
                	     
                 
            	}else if (varName == 1)         //Gustavo
              	 	{  
                    		lcd.begin(16, 2);
                    		lcd.setRGB(255, 00, 135);
    
                   		 // Print a message to the LCD.
                    		lcd.print("Gustavo");
                    		//auxNameChange = 0;

                	}else
                
                if (varName == -1)             //Mensagem Inicial
                {  
                    lcd.begin(16, 2);
                    lcd.setRGB(255, 255, 255);
                    
                    // Print a message to the LCD.
                    lcd.print("Entre com um");
                    lcd.setCursor(0,1);
                    lcd.print(" caractere:");
                    client.println(" onload=\"document.location='/'\" />");
                }  
				
			if(varName != -1 && pressed == 1)
			{
				if(auxNameChange == 1)
					auxNameChange = 0;
				else if(auxNameChange == 0)
					auxNameChange = 1;
				
				pressed = 0;
			}
                
			// output the value of each analog input pin
			for (int analogChannel = 0; analogChannel < 6; analogChannel++) 
			{
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
