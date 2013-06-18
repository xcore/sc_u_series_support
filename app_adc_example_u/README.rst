Example xCORE-USB Peripheral Tile ADC Usage
===========================================

:scope: Example
:description: A simple demo of using the xCORE-USB peripheral tile ADC
:keywords: adc

This demo shows an example of configuring the ADCs to enable ADC input 0 and
get it to return 32-bit samples, one per packet.

Import and Build the Application
++++++++++++++++++++++++++++++++

   #. Open xTIMEcomposer and open the edit perspective (Window->Open Perspective->XMOS Edit).
   #. Locate the ``xCORE-USB ADC Example`` item in the xSOFTip pane on the bottom left
      of the window and drag it into the Project Explorer window in the xTIMEcomposer.
      This will also cause the modules on which this application depends (in this case,
      module_xassert, module_logging) to be imported as well. 
   #. Click on the ``app_adc_example_u`` item in the Explorer pane then click on the
      build icon (hammer) in xTIMEcomposer. Check the console window to verify that the
      application has built successfully.

Run the Application
+++++++++++++++++++

Now that the application has been compiled, the next step is to run it on the
board using the tools to load the application over JTAG (via the XTAG-2 Adaptor card)
into the xCORE multicore microcontroller.

   #. Click on the ``Run`` icon (the white arrow in the green circle). A dialog will appear
      asking which device to connect to. Select ``XMOS XTAG2``.
   #. The application will start running and print the value of the ADC which should be
      connected to the potentiometer on the board.
   #. Turning the potentiometer will change the value the ADC is reading.

