/**
 * The copyrights, all other intellectual and industrial
 * property rights are retained by XMOS and/or its licensors.
 * Terms and conditions covering the use of this code can
 * be found in the Xmos End User License Agreement.
 *
 * Copyright XMOS Ltd 2013
 *
 * In the case where this code is a modification of existing code
 * under a separate license, the separate license terms are shown
 * below. The modifications to the code are still covered by the
 * copyright notice above.
 *
 **/
#include "usb_tile_support.h"
#include "debug_print.h"

#define PRINT_PERIOD    10000000
#define TRIGGER_PERIOD    100000

port trigger_port = PORT_ADC_TRIGGER;
clock cl = XS1_CLKBLK_2;

void adc_example(chanend c)
{
    timer        print_timer;
    unsigned int print_time;

    // A value that is not possible to get from the 12-bit ADC
    unsigned int current_value = 0xfff;
    unsigned int new_value = 0;

    adc_config_t adc_config = { { 0, 0, 0, 0, 0, 0, 0, 0 }, 0, 0, 0 };

    adc_config.input_enable[0] = 1;
    adc_config.bits_per_sample = ADC_32_BPS;
    adc_config.samples_per_packet = 1;
    adc_config.calibration_mode = 0;

    adc_enable(xs1_su, c, trigger_port, adc_config);

    print_timer :> print_time;
    print_time += PRINT_PERIOD;

    adc_trigger_packet(trigger_port, adc_config);

    while (1)
    {
        unsigned data[1];

        select
        {
            case print_timer when timerafter(print_time) :> void:
                if (new_value != current_value)
                {
                    debug_printf("ADC value: 0x%x\n", new_value);
                    current_value = new_value;
                }
                print_time += PRINT_PERIOD;
                break;

            case adc_read_packet(c, adc_config, data):
                new_value = data[0];
                adc_trigger_packet(trigger_port, adc_config);
                break;
        }
    }
}

int main()
{
    chan c;

    par {
        on stdcore[0]: adc_example(c);
        xs1_su_adc_service(c);
    }

    return 0;
}

